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

class Distribution;

#include "InitializerBase.h"

class ParticlesPerElementInitializer : public InitializerBase
{
public:
  ParticlesPerElementInitializer(const InputParameters & parameters);

  static InputParameters validParams();
  /**
   * Particle initializer for uniform densities
   * the particle weight will be based on a constant charge density and
   * the specified number of particles per element
   */
  virtual std::vector<InitialParticleData> getParticleData() const override;
  /**
   * overridden to be able to pull the distribution objects into this class
   */
  virtual void initialSetup() override;

protected:
  /// The uniform charge density that the particle weights will be based off
  const Real _number_density;
  /// the number of particles that will be placed in each element
  const unsigned int _particles_per_element;
  /// the distributions that will be used for set the initial particle velocities
  std::vector<Distribution const *> _velocity_distributions;
  /// Velocity distribution names
  const std::vector<DistributionName> & _distribution_names;
};
