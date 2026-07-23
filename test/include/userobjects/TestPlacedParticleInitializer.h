//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
//* confinement for Numerical Design, Engineering & Research,
//* A multiphysics application for modeling plasma facing components
//* https://github.com/idaholab/salamander
//*
//* SALAMANDER is powered by the MOOSE Framework
//* https://www.mooseframework.inl.gov
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ParticleInitializerBase.h"

class TestPlacedParticleInitializer : public ParticleInitializerBase
{
public:
  TestPlacedParticleInitializer(const InputParameters & parameters);

  static InputParameters validParams();

  virtual std::vector<InitialParticleData> getParticleData() const override;

protected:
  /// The starting points
  const std::vector<Point> & _start_points;
  /// The weight of the particles being placed
  const Real _weight;
};
