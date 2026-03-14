//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
//* confinement for Numerical Design, Engineering & Research,
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

#include "Moose.h"
#include "PICStudyBase.h"
#include "TestSingleParticleDataVectorPostprocessor.h"

registerMooseObject("SalamanderTestApp", TestSingleParticleDataVectorPostprocessor);

InputParameters
TestSingleParticleDataVectorPostprocessor::validParams()
{
  InputParameters params = TestParticleDataVectorPostprocessor::validParams();
  params.set<bool>("contains_complete_history") = true;
  return params;
}

TestSingleParticleDataVectorPostprocessor::TestSingleParticleDataVectorPostprocessor(
    const InputParameters & parameters)
  : TestParticleDataVectorPostprocessor(parameters)
{
}

void
TestSingleParticleDataVectorPostprocessor::finalize()
{
  std::vector<double> rank_data = {};

  if (!_study.getBankedRays().empty())
    for (const auto & data : _data_values)
      rank_data.push_back(data->back());

  comm().gather(0, rank_data);

  // if the rank is not 0 then it there is no work to be done
  // if the rank is 0 and there is data on this rank then the most recent particle data
  // was already added to the VPP data during the execute function
  if (comm().rank() != 0 || !_study.getBankedRays().empty())
    return;

  for (const auto i : make_range(_data_values.size()))
    _data_values[i]->push_back(rank_data[i]);
}
