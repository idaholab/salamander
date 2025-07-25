//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
// confinement for Numerical Design, Engineering & Research,
//* A multiphysics application for modeling plasma facing components
//* https://github.com/idaholab/salamander
//* https://mooseframework.inl.gov/salamander
//*
//* SALAMANDER is powered by the MOOSE Framework
//* https://www.mooseframework.inl.gov
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
//*
//* Copyright 2025, Battelle Energy Alliance, LLC
//* ALL RIGHTS RESERVED
//*

#include "PICStudyBase.h"
#include "ParticleStepperBase.h"
#include "libmesh/int_range.h"

InputParameters
PICStudyBase::validParams()
{
  auto params = RayTracingStudy::validParams();
  params.addClassDescription("Base class for PIC studies. Provides some of the basic ray data "
                             "needed for particle tracking."
                             "Basic logic for resetting rays to be used as particles after the "
                             "original generation is complete is also provided");
  params.addRequiredParam<UserObjectName>(
      "stepper",
      "The ParticleStepper UserObject that has the rules for how particle"
      "velocities should be updated");
  // We're not going to use registration because we don't care to name our rays because
  // we will have a lot of them
  params.set<bool>("_use_ray_registration") = false;

  return params;
}

PICStudyBase::PICStudyBase(const InputParameters & parameters)
  : RayTracingStudy(parameters),
    _banked_rays(
        declareRestartableDataWithContext<std::vector<std::shared_ptr<Ray>>>("_banked_rays", this)),
    _v_x_index(registerRayData("v_x")),
    _v_y_index(registerRayData("v_y")),
    _v_z_index(registerRayData("v_z")),
    _weight_index(registerRayData("weight")),
    _charge_index(registerRayData("charge")),
    _mass_index(registerRayData("mass")),
    _species_index(registerRayData("species")),
    _stepper(getUserObject<ParticleStepperBase>("stepper")),
    _has_generated(declareRestartableData<bool>("has_generated", false))
{
}

void
PICStudyBase::generateRays()
{
  // We generate rays the first time only, after that we will
  // pull from the bank and update velocities/max distances
  if (!_has_generated)
  {
    this->initializeParticles();
    _has_generated = true;
  }
  else
  {
    reinitializeParticles();
    // Add the rays to be traced
    moveRaysToBuffer(_banked_rays);
    _banked_rays.clear();
  }
}

void
PICStudyBase::reinitializeParticles()
{
  // Reset each ray
  for (auto & ray : _banked_rays)
  {
    // Store off the ray's info before we reset it
    const auto elem = ray->currentElem();
    const auto point = ray->currentPoint();
    const auto distance = ray->distance();

    getVelocity(*ray, _temporary_velocity);
    // Reset it (this is required to reuse a ray)
    ray->resetCounters();
    ray->clearStartingInfo();

    // And set the new starting information
    ray->setStart(point, elem);
    _stepper.setupStep(
        *ray, _temporary_velocity, ray->data()[_charge_index] / ray->data()[_mass_index], distance);

    setVelocity(*ray, _temporary_velocity);
  }
}

void
PICStudyBase::postExecuteStudy()
{
  // we are going to be re using the same rays which just took a step so
  // we store them here to reset them in the generateRays method
  _banked_rays = rayBank();
  // removing all of the rays which were killed during their tracing
  _banked_rays.erase(std::remove_if(_banked_rays.begin(),
                                    _banked_rays.end(),
                                    [](const std::shared_ptr<Ray> & ray)
                                    {
                                      if (ray->stationary())
                                        return false;

                                      return std::abs(ray->distance() - ray->maxDistance()) /
                                                 ray->maxDistance() >
                                             1e-6;
                                    }),
                     _banked_rays.end());
}

void
PICStudyBase::getVelocity(const Ray & ray, Point & v) const
{
  v(0) = ray.data(_v_x_index);
  v(1) = ray.data(_v_y_index);
  v(2) = ray.data(_v_z_index);
}

void
PICStudyBase::setVelocity(Ray & ray, const Point & v) const
{
  ray.data(_v_x_index) = v(0);
  ray.data(_v_y_index) = v(1);
  ray.data(_v_z_index) = v(2);
}

const std::vector<std::shared_ptr<Ray>> &
PICStudyBase::getBankedRays() const
{
  return _banked_rays;
}

void
PICStudyBase::setInitialParticleData(std::shared_ptr<Ray> & ray, const InitialParticleData & data)
{
  ray->setStart(data.position, data.elem);
  ray->data(_v_x_index) = data.velocity(0);
  ray->data(_v_y_index) = data.velocity(1);
  ray->data(_v_z_index) = data.velocity(2);
  ray->data(_mass_index) = data.mass;
  ray->data(_weight_index) = data.weight;
  ray->data(_charge_index) = data.charge;
}

const std::vector<RayDataIndex>
PICStudyBase::getVelocityIndicies(const bool all_components) const
{
  const unsigned int vel_dim = all_components ? 3 : _mesh.dimension();

  std::vector<RayDataIndex> indicies(vel_dim);
  for (const auto dim : make_range(vel_dim))
    indicies[dim] = getRayDataIndex(std::string("v_") + (dim == 0 ? "x" : (dim == 1 ? "y" : "z")));

  return indicies;
}
