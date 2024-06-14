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

#pragma once

#include "ParticleStepperBase.h"
#include "VariableSampler.h"

class LeapFrogStepper : public ParticleStepperBase
{
public:
  LeapFrogStepper(const InputParameters & parameters);

  static InputParameters validParams();

  /**
   * Stepper using a leap frog scheme for stepping
   */
  virtual void setupStep(Ray & ray,
                         Point & v,
                         const Real q_m_ratio = 0,
                         const Real distance = 0) const override final;

private:
  /// the variable names for each component of the force vector
  const std::vector<VariableName> _field_vars;
  /// the samplers for sampling each force component at the point of a particle
  std::vector<SALAMANDER::VariableSampler> _field_samplers;
};
