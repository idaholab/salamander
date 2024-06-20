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

#include "FEProblemBase.h"
#include "libmesh/system.h"

namespace SALAMANDER
{
/**
 * Utility that samples the value of a MooseVariable at a given point
 */
class VariableSampler
{
public:
  VariableSampler(FEProblemBase & problem, const VariableName & name, const THREAD_ID tid);

  /**
   *  Method for getting the value of a variable at a given point
   * @param point the point at which you want to know the value of a variable
   * @param element the element in which the point you want to sample resides
   * @returns the value of the variable of interest at the point of interest
   */
  Real sampleVariable(const Point & point, const Elem * element) const;

private:
  /// A reference to the system containing the variable
  const System & _system;
  /// The variable number for the vector field in the system
  const unsigned int _var_num;
};
}
