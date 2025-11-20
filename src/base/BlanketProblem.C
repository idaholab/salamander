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

#include "BlanketProblem.h"

registerMooseObject("SalamanderApp", BlanketProblem);

InputParameters
BlanketProblem::validParams()
{
  InputParameters params = FEProblem::validParams();
  params.addParam<BoundaryName>("master_bdry_name",
                                "Boundary name in master subapp wants to transfer data from/to. ");

  params.addClassDescription("A Problem object with a customized setup for fusion blanket simulations");

  return params;
}

BlanketProblem::BlanketProblem(const InputParameters & parameters)
  : FEProblem(parameters),
    _master_bdry_name(isParamValid("master_bdry_name") ? getParam<BoundaryName>("master_bdry_name")
                                                         : "")
{
}
