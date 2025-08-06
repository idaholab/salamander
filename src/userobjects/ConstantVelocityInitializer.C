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
#include "ConstantVelocityInitializer.h"
#include <algorithm>

registerMooseObject("SalamanderApp", ConstantVelocityInitializer);

InputParameters
ConstantVelocityInitializer::validParams()
{
  auto params = VelocityInitializerBase::validParams();
  params.addClassDescription(
      "Provides particles with velocities sampled from a user provided list of velocities.");
  params.addRequiredParam<std::vector<Point>>(
      "velocities", "The velocites which will be cycled through when initializing particles.");
  return params;
}

ConstantVelocityInitializer::ConstantVelocityInitializer(const InputParameters & parameters)
  : VelocityInitializerBase(parameters), _velocities(getParam<std::vector<Point>>("velocities"))
{
}

const std::vector<Point>
ConstantVelocityInitializer::getParticleVelocities(const size_t num_samples) const
{
  auto velocities = std::vector<Point>(num_samples);

  std::generate(velocities.begin(),
                velocities.end(),
                [this, i = 0]() mutable { return _velocities[i++ % _velocities.size()]; });
  return velocities;
}
