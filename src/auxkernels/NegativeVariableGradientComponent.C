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
#include "NegativeVariableGradientComponent.h"

registerMooseObject("SalamanderApp", NegativeVariableGradientComponent);

InputParameters
NegativeVariableGradientComponent::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription(
      "Returns the component of the gradient of a variable and applies a constant factor of -1.");
  params.addRequiredCoupledVar("gradient_variable", "The variable from which to take the gradient");
  params.addRequiredRangeCheckedParam<unsigned int>(
      "component", "component < 3", "The component of the gradient to access");
  return params;
}

NegativeVariableGradientComponent::NegativeVariableGradientComponent(
    const InputParameters & parameters)
  : AuxKernel(parameters),
    _grad_var(coupledGradient("gradient_variable")),
    _component(getParam<unsigned int>("component"))
{
}

Real
NegativeVariableGradientComponent::computeValue()
{
  return -_grad_var[_qp](_component);
}
