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

#include "VariableSampler.h"
#include "TestInitializedPICStudy.h"

class TestVariableSampler : public TestInitializedPICStudy
{
public:
  TestVariableSampler(const InputParameters & parameters);

  static InputParameters validParams();

protected:
  virtual void postExecuteStudy() override;

private:
  /// The utility used to sample a moose variable as a ray is traveling
  const SALAMANDER::VariableSampler _sampler;
  /// The ray data index where the value of sampled field will be stored
  const RayDataIndex _field_idx;
};
