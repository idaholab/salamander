//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
//confinement for Numerical Design, Engineering & Research,
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
//* Copyright 2025, Battelle Energy Alliance, LLC and North Carolina State University
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
  auto params = ParticleQuantityResidualAccumulatorBase::validParams();
  return params;
}

NumberDensityAccumulator::NumberDensityAccumulator(const InputParameters & params)
  : ParticleQuantityResidualAccumulatorBase(params)
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
      accumulator->add(*p->currentElem(), p->currentPoint(), p->data(_weight_index));
    }

    accumulator->finalize();
  }
}
