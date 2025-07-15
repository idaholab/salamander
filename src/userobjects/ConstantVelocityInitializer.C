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

registerMooseObject("SalamanderApp", ConstantVelocityInitializer);

InputParameters
ConstantVelocityInitializer::validParams()
{
  auto params = VelocityInitializerBase::validParams();
  params.addClassDescription(
      "Base class for defining how particles are given and initial velocity distribution.");
  params.addRequiredParam<Point>("velocity", "The velocity which all particles will have.");
  return params;
}

ConstantVelocityInitializer::ConstantVelocityInitializer(const InputParameters & parameters)
  : VelocityInitializerBase(parameters), _velocity(getParam<Point>("velocity"))
{
}

const Point
ConstantVelocityInitializer::getParticleVelocity() const
{
  return _velocity;
}
