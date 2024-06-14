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

#include "Constant.h"

registerMooseObject("SalamanderTestApp", Constant);

InputParameters
Constant::validParams()
{
  InputParameters params = Distribution::validParams();
  params.addClassDescription("Distribution that returns a constant for all random numbers sampled, "
                             "pdf and cdf are not intended to be used");
  params.addRequiredParam<Real>(
      "value", "the constant that will be returned when the quantile method is called");
  return params;
}

Constant::Constant(const InputParameters & parameters)
  : Distribution(parameters), _value(getParam<Real>("value"))
{
}

Real
Constant::pdf(const Real & /*x*/) const
{
  return 0.0;
}

Real
Constant::cdf(const Real & /*x*/) const
{
  return 0.0;
}

Real
Constant::quantile(const Real & /*y*/) const
{
  return _value;
}
