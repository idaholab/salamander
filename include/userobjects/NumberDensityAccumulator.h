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
#include "ParticleQuantityResidualAccumulatorBase.h"

class NumberDensityAccumulator : public ParticleQuantityResidualAccumulatorBase
{
public:
  static InputParameters validParams();

  NumberDensityAccumulator(const InputParameters & params);

  /**
   * Accumulates the contribution to the residual the inner product
   * of the particle number density and the test function
   */
  virtual void execute() override;
};
