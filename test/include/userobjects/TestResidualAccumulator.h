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

#pragma once

#include "TestAccumulatorBase.h"

/**
 * UserObject for testing the ResidualAccumulator
 */
class TestResidualAccumulator : public TestAccumulatorBase
{
public:
  static InputParameters validParams();

  TestResidualAccumulator(const InputParameters & params);

  virtual void execute() override;

protected:
  virtual std::unique_ptr<SALAMANDER::AccumulatorBase> buildAccumulator() override final;
};
