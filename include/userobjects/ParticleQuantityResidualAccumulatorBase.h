//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
//confinement for Numerical Design, Engineering & Research,
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
//* Copyright 2025, Battelle Energy Alliance, LLC and North Carolina State University
//* ALL RIGHTS RESERVED
//*

#pragma once
#include "GeneralUserObject.h"
// including ray for RayDataIndex
#include "Ray.h"
class PICStudyBase;

class ParticleQuantityResidualAccumulatorBase : public GeneralUserObject
{
public:
  static InputParameters validParams();

  ParticleQuantityResidualAccumulatorBase(const InputParameters & params);

  /**
   * Unused methods
   */
  ///@{
  virtual void initialize() override {}
  virtual void finalize() override {}
  ///@}

protected:
  /// the name of the variable which we are contributing to the residual of
  const NonlinearVariableName _var_name;
  /// the PIC study that is tracking all of our particles
  const PICStudyBase & _study;
  /// the ray data index where each of the velocity components are stored
  ///@{
  const RayDataIndex _v_x_index;
  const RayDataIndex _v_y_index;
  const RayDataIndex _v_z_index;
  ///@}
  /// the ray data index where the weight of the particle is stored
  const RayDataIndex _weight_index;
  /// the ray data index where the charge of the particle is stored
  const RayDataIndex _charge_index;
  /// the ray data index where the mass of the particle is stored
  const RayDataIndex _mass_index;
  /// the ray data index where the species of the particle is stored
  const RayDataIndex _species_index;
};
