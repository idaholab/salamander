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

#include "PICStudyBase.h"
#include "TestInitializedPICStudy.h"

#include "ClaimRays.h"
#include "ParticleInitializerBase.h"
#include "ParticleStepperBase.h"
#include <memory>

registerMooseObject("SalamanderTestApp", TestInitializedPICStudy);

InputParameters
TestInitializedPICStudy::validParams()
{
  auto params = PICStudyBase::validParams();
  params.addParam<unsigned int>(
      "particles_per_element", 0, "The number of particles that will be placed in each element");

  params.addParam<bool>(
      "use_custom_rayids",
      true,
      "Wether or not to use the implemented ray id generation scheme or the default one");
  params.addParam<bool>(
      "single_particle", false, "Wether or not this is a single particle motion test");
  return params;
}

TestInitializedPICStudy::TestInitializedPICStudy(const InputParameters & parameters)
  : PICStudyBase(parameters),
    _single_particle(getParam<bool>("single_particle")),
    _use_custom_id_scheme(getParam<bool>("use_custom_rayids")),
    _particles_per_element(getParam<unsigned int>("particles_per_element")),
    _curr_elem_id(0),
    _curr_elem_ray_count(0)
{
  if (!_single_particle && (_use_custom_id_scheme && _particles_per_element == 0))
    paramError(
        "particles_per_element",
        "particles per element cannot be zero when using the custom ray id generation scheme");
}

std::shared_ptr<Ray>
TestInitializedPICStudy::createParticle(const AssignedParticleData & assigned_data,
                                        const InitialParticleData & data)
{
  // this assumes that particles will be placed on an element by element basis
  // in order without repeating elements. This is fine for all of the tests we have
  // now but we may get id collisions if we were to test multi specieds initializations
  // and want to use custom ray ids.
  if (data.elem->id() != _curr_elem_id)
  {
    _curr_elem_id = data.elem->id();
    _curr_elem_ray_count = 0;
  }

  return PICStudyBase::createParticle(assigned_data, data);
}
RayID
TestInitializedPICStudy::generateUniqueRayID(const THREAD_ID tid)
{
  if (_single_particle)
    return 0;

  if (_use_custom_id_scheme)
    return _curr_elem_id * _particles_per_element + _curr_elem_ray_count++;

  return RayTracingStudy::generateUniqueRayID(tid);
}
