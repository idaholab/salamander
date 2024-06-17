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

#include "ParticlesPerElementInitializer.h"

class BoundingBoxInitializer : public ParticlesPerElementInitializer
{
public:
  BoundingBoxInitializer(const InputParameters & parameters);

  static InputParameters validParams();
  /**
   * Initialization that applies a bounding box to
   * ParticlesPerElementInitializer
   * if the bounding box encompasses the whole domain then these are the same
   */
  virtual std::vector<InitialParticleData> getParticleData() const override;

protected:
  ///@{
  /// The individual components of the bottom left point of the axis aligned bounding box
  const Real _x1;
  const Real _y1;
  const Real _z1;
  ///@}

  ///@{
  /// The individual components of the upper right point of the axis aligned bounding box
  const Real _x2;
  const Real _y2;
  const Real _z2;
  ///@}

  /// The Point object constructed from the x1, y1, z1 components for the bottom left BB corner
  const Point _bottom_left;

  /// The Point object constructed from the x2, y2, z2 components for the bottom left BB corner
  const Point _top_right;

  const std::vector<std::vector<Real>> _planes;
};
