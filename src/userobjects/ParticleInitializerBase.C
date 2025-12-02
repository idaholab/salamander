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

#include "MooseTypes.h"
#include "ParticleInitializerBase.h"

InputParameters
ParticleInitializerBase::validParams()
{
  auto params = GeneralUserObject::validParams();
  params.addClassDescription("Base class for ParticleStepper. Provides the basic implementation"
                             "for dimensional dependent velocity updating."
                             "And the ability to sample vector fields for use in a particle step");
  params.addParam<unsigned int>("seed", 0, "An additional seed for the random number generators");
  params.addRangeCheckedParam<Real>(
      "mass", 1.0, "mass > 0.0", "The mass of the particles being placed in the mesh");
  params.addParam<Real>("charge", 1, "The charge of the particles being placed in the mesh");
  params.addParam<std::string>("species", "", "The type of particle that is being initialized");
  params.addRequiredParam<UserObjectName>(
      "velocity_initializer",
      "The user object that will generate the initial velocities for all of the particles.");
  return params;
}

ParticleInitializerBase::ParticleInitializerBase(const InputParameters & parameters)
  : GeneralUserObject(parameters),
    _mass(getParam<Real>("mass")),
    _charge(getParam<Real>("charge")),
    _species(getParam<std::string>("species")),
    _seed(getParam<unsigned int>("seed")),
    _mesh_dimension(_fe_problem.mesh().dimension()),
    _velocity_initializer(getUserObject<VelocityInitializerBase>("velocity_initializer"))
{
}
