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

#include "TestResidualAccumulator.h"

#include "ResidualAccumulator.h"

registerMooseObject("SalamanderTestApp", TestResidualAccumulator);

InputParameters
TestResidualAccumulator::validParams()
{
  auto params = TestAccumulatorBase::validParams();

  // Make sure that you add these params when using the ResidualAccumulator
  params += TaggingInterface::validParams();

  // You need to add this exec flag so it can contribute to residuals
  ExecFlagEnum & exec_enum = params.set<ExecFlagEnum>("execute_on", true);
  exec_enum.addAvailableFlags(EXEC_PRE_KERNELS);

  params.addParam<NonlinearVariableName>("variable", "The variable to accumulate into");

  return params;
}

TestResidualAccumulator::TestResidualAccumulator(const InputParameters & params)
  : TestAccumulatorBase(params)
{
}

void
TestResidualAccumulator::execute()
{
  if (_fe_problem.currentlyComputingResidual())
    TestAccumulatorBase::execute();
}

std::unique_ptr<SALAMANDER::AccumulatorBase>
TestResidualAccumulator::buildAccumulator()
{
  std::unique_ptr<SALAMANDER::AccumulatorBase> accumulator =
      std::make_unique<SALAMANDER::ResidualAccumulator>(
          _fe_problem, this, getParam<NonlinearVariableName>("variable"), 0);
  return accumulator;
}
