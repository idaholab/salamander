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

#include "ReflectParticleBC.h"

registerMooseObject("SalamanderApp", ReflectParticleBC);

InputParameters
ReflectParticleBC::validParams()
{
  auto params = ReflectRayBC::validParams();
  params.addClassDescription(
      "Relfective boundary condition for particles that ensures velocity data is consistent with "
      "its direction after relfection.");
  return params;
}

ReflectParticleBC::ReflectParticleBC(const InputParameters & params)
  : ReflectRayBC(params),
    _mesh_dimension(_fe_problem.mesh().dimension()),
    _velocity_indicies({_study.getRayDataIndex("v_x"),
                        _study.getRayDataIndex("v_y"),
                        _study.getRayDataIndex("v_z")})
{
}

void
ReflectParticleBC::onBoundary(const unsigned int num_applying)
{
  // reflect the particle normally and then update velocity data
  ReflectRayBC::onBoundary(num_applying);
  // collect the components of the velocity that need to be consistent with the direction
  for (const auto i : make_range(_mesh_dimension))
  {
    _temporary_velocity(i) = currentRay()->data(_velocity_indicies[i]);
  }
  // compute what the velocity data should be to be consistent with direction
  _temporary_velocity = _temporary_velocity.norm() * currentRay()->direction();

  for (const auto i : make_range(_mesh_dimension))
  {
    currentRay()->data(_velocity_indicies[i]) = _temporary_velocity(i);
  }
}
