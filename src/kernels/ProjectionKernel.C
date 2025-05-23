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

#include "ProjectionKernel.h"

registerMooseObject("SalamanderApp", ProjectionKernel);

InputParameters
ProjectionKernel::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addClassDescription(
      "Kernel for projecting discrete particle quantities onto the finite element mesh");
  return params;
}

ProjectionKernel::ProjectionKernel(const InputParameters & parameters) : ADKernelValue(parameters)
{
}

ADReal
ProjectionKernel::precomputeQpResidual()
{
  return _u[_qp];
}
