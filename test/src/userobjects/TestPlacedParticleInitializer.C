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
    _weight(getParam<Real>("weight"))
{
}

std::vector<InitialParticleData>
TestPlacedParticleInitializer::getParticleData() const
{

  std::vector<InitialParticleData> particle_data;
  particle_data.reserve(_start_points.size());

  const auto & velocities = _velocity_initializer.getParticleVelocities(_start_points.size());

  for (unsigned int i = 0; i < _start_points.size(); ++i)
  {
    const Elem * particle_elem = nullptr;
    // we'll check to see if this processor owns any of the points
    // where we want to put particles. We could do this with replicated rays
    // however we don't want to have to use replicated rays everytime we need
    // a new ray during the transient study
    for (auto elem : *_fe_problem.mesh().getActiveLocalElementRange())
    {
      if (elem->contains_point(_start_points[i]))
      {
        particle_elem = elem;
      }
    }
    // the pointer will be null in the case that the processor doesn't own the point
    if (particle_elem == nullptr)
      continue;

    auto & data = particle_data.emplace_back();

    data.position = _start_points[i];
    data.velocity = velocities[i];
    data.mass = _mass;
    data.charge = _charge;
    data.weight = _weight;
    data.elem = particle_elem;
  }

  size_t total_particles_created = particle_data.size();

  comm().sum(total_particles_created);

  if (total_particles_created != _start_points.size())
    mooseError(std::to_string(_start_points.size()) +
               " particles were supposed to be created but only " +
               std::to_string(total_particles_created) +
               " were created. You may have tried to place a particle outside of the domain and it "
               "could not be created.");
  return particle_data;
}
