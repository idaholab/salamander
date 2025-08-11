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

#include "GeneralUserObject.h"

class VelocityInitializerBase : public GeneralUserObject
{
public:
  VelocityInitializerBase(const InputParameters & parameters);

  static InputParameters validParams();

  /**
   * Creates a vector of initial particle velocities for as many samples as were requested.
   * @returns a Point object containing the particle velocity
   */
  virtual const std::vector<Point> getParticleVelocities(const size_t num_samples) const = 0;

  /**
   * Unused methods
   */
  ///@{
  virtual void initialize() override final {}
  virtual void finalize() override final {}
  virtual void execute() override final {}
  ///@}

protected:
  /// a user specified seed for changing random number generator seeds
  const unsigned int _seed;
};
