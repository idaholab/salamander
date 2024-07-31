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
#include "NegativeGradientComponent.h"

registerMooseObject("SalamanderApp", NegativeGradientComponent);

InputParameters
NegativeGradientComponent::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription(
      "Returns the negative gradient component of field variable");
  params.addRequiredCoupledVar("var", "The variable of which to take the gradient");
  params.addRequiredRangeCheckedParam<unsigned int>("component",
                              "component < 3",
                               "The component of the component of the gradients to access");
  return params;
}

NegativeGradientComponent::NegativeGradientComponent(const InputParameters & parameters)
  : AuxKernel(parameters),
    _grad_var(coupledGradient("var")),
    _component(getParam<unsigned int>("component"))
{
}

Real
NegativeGradientComponent::computeValue()
{
  return -_grad_var[_qp](_component);
}
