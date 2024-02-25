//* This file is part of SALAMANDER: Fusion Energy Integrated Multiphys-X,
//* A multiphysics application for modeling plasma facing components
//* https://github.com/idaholab/salamander
//*
//* SALAMANDER is powered by the MOOSE Framework
//* https://www.mooseframework.inl.gov
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "TestAuxAccumulator.h"

#include "AuxAccumulator.h"

registerMooseObject("SalamanderTestApp", TestAuxAccumulator);

InputParameters
TestAuxAccumulator::validParams()
{
  auto params = TestAccumulatorBase::validParams();
  params.addParam<AuxVariableName>("variable", "The variable to accumulate into");
  return params;
}

TestAuxAccumulator::TestAuxAccumulator(const InputParameters & params) : TestAccumulatorBase(params)
{
}

std::unique_ptr<SALAMANDER::AccumulatorBase>
TestAuxAccumulator::buildAccumulator()
{
  std::unique_ptr<SALAMANDER::AccumulatorBase> accumulator =
      std::make_unique<SALAMANDER::AuxAccumulator>(_fe_problem, getParam<AuxVariableName>("variable"));
  return accumulator;
}
