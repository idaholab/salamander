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

#include "SimpleStepper.h"

registerMooseObject("SalamanderApp", SimpleStepper);

InputParameters
SimpleStepper::validParams()
{
  auto params = ParticleStepperBase::validParams();
  params.addClassDescription(
      "This stepper does not modify the particle velocity just "
      "updates the direction and maximum distance based on the currently velocity and timestep.");
  return params;
}

SimpleStepper::SimpleStepper(const InputParameters & parameters) : ParticleStepperBase(parameters)
{
}

void
SimpleStepper::setupStep(Ray & ray,
                         Point & v,
                         const Real /*q_m_ratio*/,
                         const Real /*disatnce*/) const
{
  setMaxDistanceAndDirection(ray, v, _dt);
}
