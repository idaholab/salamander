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

#include "NumberDensityAccumulator.h"
#include "ResidualAccumulator.h"
#include "PICStudyBase.h"
#include "MooseMesh.h"

registerMooseObject("SalamanderApp", NumberDensityAccumulator);

InputParameters
NumberDensityAccumulator::validParams()
{
  auto params = GeneralUserObject::validParams();
  params.addClassDescription(
      "Accumulator used to evaluate the inner product of the charge density and the test function "
      "required for solving electromagnetic equations");
  params.addRequiredParam<UserObjectName>("study", "The PICStudy that owns the charged particles");
  // These parameters are necessary when using ResidualAccumulator
  params += TaggingInterface::validParams();
  // This exec flag is necessary for the NumberDensityAccumulator to contribute to residuals
  ExecFlagEnum & exec_enum = params.set<ExecFlagEnum>("execute_on", true);
  exec_enum.addAvailableFlags(EXEC_PRE_KERNELS);
  params.set<ExecFlagEnum>("execute_on") = EXEC_PRE_KERNELS;
  // making this input parameter private so the user cannot use the object incorrectly
  params.suppressParameter<ExecFlagEnum>("execute_on");
  params.addRequiredParam<NonlinearVariableName>("variable",
                                                 "The variable to contribute to the residual of");
  return params;
}

NumberDensityAccumulator::NumberDensityAccumulator(const InputParameters & params)
  : GeneralUserObject(params),
    _var_name(getParam<NonlinearVariableName>("variable")),
    _study(getUserObject<PICStudyBase>("study")),
    _weight_index(_study.getRayDataIndex("weight"))
{
}

void
NumberDensityAccumulator::execute()
{
  if (_fe_problem.currentlyComputingResidual())
  {
    std::unique_ptr<SALAMANDER::AccumulatorBase> accumulator =
        std::make_unique<SALAMANDER::ResidualAccumulator>(_fe_problem, this, _var_name, 0);

    auto particles = _study.getBankedRays();

    for (auto & p : particles)
    {
      accumulator->add(
          *p->currentElem(), p->currentPoint(), p->data(_weight_index));
    }

    accumulator->finalize();
  }
}
