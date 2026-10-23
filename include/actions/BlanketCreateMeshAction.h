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

#pragma once

#include "THMCreateMeshAction.h"

/**
 * SALAMANDER override of THMCreateMeshAction that builds a BlanketProblem
 * (a THMProblem subclass) in place of the stock THMProblem, without modifying
 * MOOSE or the Thermal Hydraulics module.
 */
class BlanketCreateMeshAction : public THMCreateMeshAction
{
public:
  static InputParameters validParams();

  BlanketCreateMeshAction(const InputParameters & parameters);

  virtual void act() override;
};
