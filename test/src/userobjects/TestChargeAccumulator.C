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

#include "TestChargeAccumulator.h"
#include "ParticleStepperBase.h"

registerMooseObject("SalamanderTestApp", TestChargeAccumulator);

InputParameters
TestChargeAccumulator::validParams()
{
  auto params = TestPICStudyUserDefinedRays::validParams();
  params.addRequiredParam<AuxVariableName>("variable",
                                           "The auxvariable that you want to accumulate into");
  return params;
}

TestChargeAccumulator::TestChargeAccumulator(const InputParameters & parameters)
  : TestPICStudyUserDefinedRays(parameters), _var_name(getParam<AuxVariableName>("variable"))
{
}

void
TestChargeAccumulator::postExecuteStudy()
{
  // lets make a new accumulator each time so we can reset the aux variable each time
  SALAMANDER::AuxAccumulator accumulator = SALAMANDER::AuxAccumulator(_fe_problem, _var_name);
  TestPICStudyUserDefinedRays::postExecuteStudy();
  for (auto & ray : _banked_rays)
  {
    accumulator.add(*ray->currentElem(), ray->currentPoint(), 1);
  }
  accumulator.finalize();
}
