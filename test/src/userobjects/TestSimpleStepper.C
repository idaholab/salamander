//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic confinement for Numerical Design, Engineering & Research,
//* A multiphysics application for modeling plasma facing components
//* https://github.com/idaholab/salamander
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

#include "TestSimpleStepper.h"

registerMooseObject("SalamanderTestApp", TestSimpleStepper);

InputParameters
TestSimpleStepper::validParams()
{
  auto params = ParticleStepperBase::validParams();
  params.addClassDescription("Simple test stepper which does not modify the particle velocity just "
                             "updates the direction and maximum distance");
  return params;
}

TestSimpleStepper::TestSimpleStepper(const InputParameters & parameters)
  : ParticleStepperBase(parameters)
{
}

void
TestSimpleStepper::setupStep(Ray & ray,
                             Point & v,
                             const Real /*q_m_ratio*/,
                             const Real /*disatnce*/) const
{
  setMaxDistanceAndDirection(ray, v, _dt);
}
