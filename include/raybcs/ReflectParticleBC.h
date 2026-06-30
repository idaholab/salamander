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
//* Copyright 2025, Battelle Energy Alliance, LLC and North Carolina State University
//* ALL RIGHTS RESERVED
//*

#pragma once

#include "ReflectRayBC.h"

class PICStudyBase;

class ReflectParticleBC : public ReflectRayBC
{
public:
  ReflectParticleBC(const InputParameters & params);

  static InputParameters validParams();

  virtual void onBoundary(const unsigned int num_applying) override;

protected:
  /// the instance of the pic study to get access the particle data accessor methods
  const PICStudyBase & _pic_study;
  /// the dimension of the actual mesh
  const unsigned int _mesh_dimension;
  /// point used to store the components of the velocity which are needed during reflection
  Point _temporary_velocity;
};
