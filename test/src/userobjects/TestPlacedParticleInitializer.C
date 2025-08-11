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
//* Copyright 2025, Battelle Energy Alliance, LLC
//* ALL RIGHTS RESERVED
//*

#include "TestPlacedParticleInitializer.h"
#include "VelocityInitializerBase.h"

registerMooseObject("SalamanderTestApp", TestPlacedParticleInitializer);

InputParameters
TestPlacedParticleInitializer::validParams()
{
  auto params = ParticleInitializerBase::validParams();
  params.addRequiredParam<std::vector<Point>>("start_points",
                                              "The point(s) where the ray(s) start");
  params.addParam<Real>(
      "weight", 0, "The number of physical particles a computational particle represents");
  return params;
}

TestPlacedParticleInitializer::TestPlacedParticleInitializer(const InputParameters & parameters)
  : ParticleInitializerBase(parameters),
    _start_points(getParam<std::vector<Point>>("start_points")),
    _mass(getParam<Real>("mass")),
    _charge(getParam<Real>("charge")),
    _weight(getParam<Real>("weight"))
{
}

std::vector<InitialParticleData>
TestPlacedParticleInitializer::getParticleData() const
{

  std::vector<InitialParticleData> data = std::vector<InitialParticleData>(_start_points.size());
  const auto & velocities = _velocity_initializer.getParticleVelocities(_start_points.size());

  for (unsigned int i = 0; i < _start_points.size(); ++i)
  {
    data[i].position = _start_points[i];
    data[i].velocity = velocities[i];
    data[i].mass = _mass;
    data[i].charge = _charge;
    data[i].weight = _weight;
    data[i].elem = nullptr;
    data[i].species = "";
  }

  return data;
}
