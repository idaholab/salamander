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

#include "ParticleDataVectorPostprocessor.h"
#include "PICStudyBase.h"

registerMooseObject("SalamanderApp", ParticleDataVectorPostprocessor);

InputParameters
ParticleDataVectorPostprocessor::validParams()
{
  InputParameters params = GeneralVectorPostprocessor::validParams();
  params.addClassDescription(
      "Collects data which is stored in RayData on particles on a per timestep basis.");
  params.addRequiredParam<UserObjectName>("study", "The PICStudy that owns the Ray");
  params.addParam<std::vector<std::string>>("additional_ray_data_outputs",
                                            {},
                                            "The names of any Ray data in addition to the particle "
                                            "position and velocity that will be output");
  return params;
}

ParticleDataVectorPostprocessor::ParticleDataVectorPostprocessor(const InputParameters & parameters)
  : GeneralVectorPostprocessor(parameters),
    _study(getUserObject<PICStudyBase>("study")),
    _ray_data_indices(_study.getVelocityIndicies(true)),
    _data_values({&declareVector("t_pos"),
                  &declareVector("t_vel"),
                  &declareVector("x"),
                  &declareVector("y"),
                  &declareVector("z"),
                  &declareVector("v_x"),
                  &declareVector("v_y"),
                  &declareVector("v_z")})
{
  const auto & additional_ray_data =
      getParam<std::vector<std::string>>("additional_ray_data_outputs");

  if (additional_ray_data.empty())
    return;

  const auto & additional_data_indicies = _study.getRayDataIndices(additional_ray_data);
  _ray_data_indices.insert(
      _ray_data_indices.end(), additional_data_indicies.begin(), additional_data_indicies.end());

  for (const auto & data_name : additional_ray_data)
    _data_values.push_back(&declareVector(data_name));
}

void
ParticleDataVectorPostprocessor::initialize()
{
  for (auto & data : _data_values)
    data->clear();
}

void
ParticleDataVectorPostprocessor::execute()
{

  const auto rays = _study.getBankedRays();
  for (const auto & ray : rays)
  {
    // storing the time at which the particle position is known
    _data_values[0]->push_back(_t);
    // storing the time at which the particle velocity is known
    _data_values[1]->push_back(_t - _dt / 2);
    const auto & point = ray->currentPoint();
    for (const auto i : make_range(2, 5))
      _data_values[i]->push_back(point(i - 2));

    for (const auto i : make_range(5, int(5 + _ray_data_indices.size())))
      _data_values[i]->push_back(ray->data(_ray_data_indices[i - 5]));
  }
}

void
ParticleDataVectorPostprocessor::finalize()
{
  for (auto data : _data_values)
    comm().gather(0, *data);
}
