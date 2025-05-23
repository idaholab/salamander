//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic confinement for Numerical Design, Engineering & Research,
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

#include "ParticleStepperBase.h"

InputParameters
ParticleStepperBase::validParams()
{
  auto params = GeneralUserObject::validParams();
  params.addClassDescription("Base class for ParticleStepper. Provides the basic implementation"
                             "for dimensional dependent velocity updating."
                             "And the ability to sample vector fields for use in a particle step");
  return params;
}

ParticleStepperBase::ParticleStepperBase(const InputParameters & parameters)
  : GeneralUserObject(parameters), _mesh_dimension(_fe_problem.mesh().dimension())
{
}

void
ParticleStepperBase::setMaxDistanceAndDirection(Ray & ray, const Point & v, const Real dt) const
{

  // if the particle velocity is the zero vector the ray needs to be explicitly
  // made stationary otherwise a zero velocity will create a divide by zero
  // when trying to compute the unit direction vector
  if (v.absolute_fuzzy_equals(Point(0, 0, 0)))
  {
    ray.setStationary();
    return;
  }
  // temporary point to store the new velocity as we work on it
  Point velocity = Point(0, 0, 0);

  if (_mesh_dimension >= 1)
    velocity(0) = v(0);

  if (_mesh_dimension >= 2)
    velocity(1) = v(1);

  if (_mesh_dimension == 3)
    velocity(2) = v(2);

  // max distance is v^2 dt
  const auto max_distance = std::sqrt(velocity * velocity) * dt;

  ray.setStartingMaxDistance(max_distance);
  ray.setStartingDirection(velocity);
}

Point
ParticleStepperBase::sampleField(const std::vector<SALAMANDER::VariableSampler> & field_samplers,
                                 const Ray & ray) const
{
  const auto p = ray.currentPoint();
  const auto e = ray.currentElem();
  return Point(field_samplers[0].sampleVariable(p, e),
               field_samplers[1].sampleVariable(p, e),
               field_samplers[2].sampleVariable(p, e));
}

Point
ParticleStepperBase::linearImpulse(const Point & v,
                                   const Point & F,
                                   const Real q_m_ratio,
                                   const Real dt) const
{
  return v + q_m_ratio * F * dt;
}
