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

#pragma once
#include "TestParticleDataVectorPostprocessor.h"

class TestSingleParticleDataVectorPostprocessor : public TestParticleDataVectorPostprocessor
{
public:
  static InputParameters validParams();

  TestSingleParticleDataVectorPostprocessor(const InputParameters & parameters);

  virtual void initialize() override {};
};
