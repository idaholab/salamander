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

#pragma once

#include "FEProblem.h"

/*
 * Need to create this special problem in order to handle customized transfer MultiAppConservativeTransfer
 * This transfer tries to create map between a 3D channel boundary and a 1D THM application
 * In a long term, we need to generalize MultiAppConservativeTransfer and move that to the MOOSE framework
*/
class BlanketProblem : public FEProblem
{
public:
  static InputParameters validParams();

  BlanketProblem(const InputParameters & parameters);

  BoundaryName & getMasterBoundaryName() { return _master_bdry_name; }
protected:
  BoundaryName _master_bdry_name;
};
