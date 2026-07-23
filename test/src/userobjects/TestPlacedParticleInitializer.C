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
    const auto & start_point = _start_points[i];
    const Elem * particle_elem = nullptr;
    // We'll check to see if this processor owns any of the points
    // where we want to put particles. We could do this with replicated rays;
    // however, we don't want to have to use replicated rays every time we need
    // a new ray during the transient study
    for (auto elem : *_fe_problem.mesh().getActiveLocalElementRange())
    {
      if (!elem->contains_point(_start_points[i]))
        continue;
      // This check is a bit hacky; however, since this is only for a few simple tests, it should be
      // fine. On some of the test cases, we have particles placed at nodes; this means that, in
      // parallel, two processors will determine that the particle is in their element. To get
      // around this, we just add a check that looks to see if the point on the right-most side of
      // the element, and only the elements that are on the boundary are allowed to claim the
      // particles on the right-most node. Since the tests cases this check is for are 1D, this
      // check is fine for this case but is not a general solution.
      if (elem->get_nodes()[elem->n_nodes() - 1]->absolute_fuzzy_equals(start_point) &&
          !elem->on_boundary())
        continue;

      particle_elem = elem;
      break;
    }

    // The pointer will be null when/if the processor doesn't own the point.
    if (particle_elem == nullptr)
      continue;

    auto & data = particle_data.emplace_back();

    data.position = _start_points[i];
    data.velocity = velocities[i];
    data.weight = _weight;
    data.elem = particle_elem;
  }

  size_t total_particles_created = particle_data.size();

  comm().sum(total_particles_created);

  if (total_particles_created != _start_points.size())
    mooseError(
        std::to_string(_start_points.size()) + " particles were supposed to be created but " +
        std::to_string(total_particles_created) +
        " were created. You may have tried to place a particle outside of the domain, and it "
        "could not be created. Alternatively, it might have been placed on an element boundary, "
        "and it was created twice.");
  return particle_data;
}
