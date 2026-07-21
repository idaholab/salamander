//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
//* confinement for Numerical Design, Engineering & Research,
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
//* Copyright 2025, Battelle Energy Alliance, LLC and North Carolina State University
//* ALL RIGHTS RESERVED
//*

#include "PICStudyBase.h"
#include "ParticleInitializerBase.h"
#include "ParticleStepperBase.h"
#include <libmesh/fuzzy_equals.h>

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
  params.addRequiredParam<std::vector<UserObjectName>>(
      "particle_initializers", "The initializers that will place particles");
  params.set<bool>("_use_ray_registration") = false;

  return params;
}

PICStudyBase::PICStudyBase(const InputParameters & parameters)
  : RayTracingStudy(parameters),
    _banked_rays(
        declareRestartableDataWithContext<std::vector<std::shared_ptr<Ray>>>("_banked_rays", this)),
    _velocity_indicies({registerRayData("v_x"), registerRayData("v_y"), registerRayData("v_z")}),
    _weight_index(registerRayData("weight")),
    _charge_index(registerRayData("charge")),
    _mass_index(registerRayData("mass")),
    _species_index(registerRayData("species")),
    _stepper(getUserObject<ParticleStepperBase>("stepper")),
    _has_generated(declareRestartableData<bool>("has_generated", false))
{
  std::set<std::string_view> name_set;
  std::vector<std::string_view> initializer_names;
  std::set<std::string_view> initializer_name_set;

  for (const auto & name : getParam<std::vector<UserObjectName>>("particle_initializers"))
  {
    const auto & initializer = getUserObjectByName<ParticleInitializerBase>(name);
    const auto & species = initializer.species();
    const auto mass = initializer.mass();
    const auto charge = initializer.charge();

    if (initializer_name_set.count(name) != 0)
    {
      paramError("particle_initializers",
                 "Particle initializer " + name +
                     " was provided multiple times. Each initializer may only be provided once.");
    }
    initializer_name_set.emplace(name);

    if (name_set.count(species) == 0)
    {
      name_set.emplace(species);
      initializer_names.emplace_back(initializer.name());
      _species_names.emplace_back(species);
      _species_masses.emplace_back(mass);
      _species_charges.emplace_back(charge);
      continue;
    }

    const auto it = std::find(_species_names.begin(), _species_names.end(), species);
    const auto species_index = std::distance(_species_names.begin(), it);

    if (!libMesh::absolute_fuzzy_equals(_species_masses[species_index], mass))
    {
      paramError(
          "particle_initializers",
          static_cast<std::string>(initializer_names[species_index]) + ", and " +
              initializer.name() + " provided different masses for species " + species,
          ". If there are multiple initializers for a single species they must provide consistent "
          "physical properties.");
    }

    if (!libMesh::absolute_fuzzy_equals(_species_charges[species_index], charge))
    {
      paramError(
          "particle_initializers",
          static_cast<std::string>(initializer_names[species_index]) + ", and " +
              initializer.name() + " provided different charges for species " + species,
          ". If there are multiple initializers for a single species they must provide consistent "
          "physical properties.");
    }
  }
}

void
PICStudyBase::generateRays()
{
  // We generate rays the first time only, after that we will
  // pull from the bank and update velocities/max distances
  if (!_has_generated)
  {
    initializeParticles();
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
PICStudyBase::initializeParticles()
{
  std::vector<const ParticleInitializerBase *> initializers;
  for (const auto & name : getParam<std::vector<UserObjectName>>("particle_initializers"))
  {
    initializers.push_back(&getUserObjectByName<ParticleInitializerBase>(name));
  }

  AssignedParticleData assigned_data;
  for (const auto & initializer : initializers)
  {
    assigned_data.charge = initializer->charge();
    assigned_data.mass = initializer->mass();
    assigned_data.species_id = speciesId(initializer->species());
    for (const auto & initial_data : initializer->getParticleData())
    {
      _banked_rays.push_back(createParticle(assigned_data, initial_data));
    }
  }
  moveRaysToBuffer(_banked_rays);
}

void
PICStudyBase::reinitializeParticles()
{
  // Reset each ray
  for (auto & particle : _banked_rays)
  {
    // Store off the ray's info before we reset it
    const auto elem = particle->currentElem();
    const auto point = particle->currentPoint();
    const auto distance = particle->distance();

    velocity(*particle, _temporary_velocity);
    // Reset it (this is required to reuse a ray)
    particle->resetCounters();
    particle->clearStartingInfo();

    // And set the new starting information
    particle->setStart(point, elem);
    _stepper.setupStep(*particle,
                       _temporary_velocity,
                       particle->data(_charge_index) / particle->data(_mass_index),
                       distance);

    setVelocity(*particle, _temporary_velocity);
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

unsigned int
PICStudyBase::speciesId(const std::string & species_name) const
{
  const auto it = std::find(_species_names.begin(), _species_names.end(), species_name);
  if (it == _species_names.end())
  {
    mooseError("The requested species " + species_name + " does not exist in the PIC Study.");
  }

  return std::distance(_species_names.begin(), it);
}

void
PICStudyBase::setVelocity(Ray & particle, const Point & v) const
{
  for (size_t i = 0; i < _velocity_indicies.size(); ++i)
  {
    particle.data(_velocity_indicies[i]) = v(i);
  }
}

const std::vector<std::shared_ptr<Ray>> &
PICStudyBase::particles() const
{
  return _banked_rays;
}

void
PICStudyBase::setInitialParticleData(std::shared_ptr<Ray> & particle,
                                     const AssignedParticleData & assigned_data,
                                     const InitialParticleData & data)

{
  particle->setStart(data.position, data.elem);
  setVelocity(*particle, data.velocity);
  particle->data(_weight_index) = data.weight;
  particle->data(_mass_index) = assigned_data.mass;
  particle->data(_charge_index) = assigned_data.charge;
  particle->data(_species_index) = assigned_data.species_id;
}

const Real
PICStudyBase::weight(const Ray & particle) const
{
  return particle.data(_weight_index);
}

const Real
PICStudyBase::charge(const Ray & particle) const
{
  return particle.data(_charge_index);
}

const Real
PICStudyBase::mass(const Ray & particle) const
{
  return particle.data(_mass_index);
}

const unsigned int
PICStudyBase::species(const Ray & particle) const
{
  return particle.data(_species_index);
}

void
PICStudyBase::velocity(const Ray & particle, Point & velocity) const
{
  for (size_t i = 0; i < 3; ++i)
  {
    velocity(i) = particle.data(_velocity_indicies[i]);
  }
}

const Real
PICStudyBase::velocityComponent(const Ray & particle, const unsigned int component) const
{
  mooseAssert(component < 3, "The maximum value of component allowed is 2.");
  return particle.data(_velocity_indicies[component]);
}

std::shared_ptr<Ray>
PICStudyBase::createParticle(const AssignedParticleData & assigned_data,
                             const InitialParticleData & data)
{
  auto particle = acquireRay();
  setInitialParticleData(particle, assigned_data, data);
  velocity(*particle, _temporary_velocity);
  _stepper.setupStep(
      *particle, _temporary_velocity, particle->data(_charge_index) / particle->data(_mass_index));
  setVelocity(*particle, _temporary_velocity);
  return particle;
}
