//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
//* confinement for Numerical Design, Engineering & Research,
//* A multiphysics application for modeling plasma facing components *
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

#include "VelocityInitializerBase.h"

InputParameters
VelocityInitializerBase::validParams()
{
  auto params = GeneralUserObject::validParams();
  params.addClassDescription(
      "Base class for defining how particles are given an initial velocity distribution.");
  params.addParam<unsigned int>("seed",
                                0,
                                "An additional seed for the random number generators that may be "
                                "used when sampling initial particle velocities.");
  return params;
}

VelocityInitializerBase::VelocityInitializerBase(const InputParameters & parameters)
  : GeneralUserObject(parameters), _seed(getParam<unsigned int>("seed"))
{
}
