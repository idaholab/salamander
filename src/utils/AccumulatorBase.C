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

#include "AccumulatorBase.h"

namespace SALAMANDER
{
AccumulatorBase::AccumulatorBase(FEProblemBase & problem)
  : _problem(problem), _current_elem(nullptr), _finalized(false)
{
}

AccumulatorBase::~AccumulatorBase()
{
  if (!_finalized)
    mooseError("AccumulatorBase was not finalized");
}

void
AccumulatorBase::finalize()
{
  mooseAssert(!_finalized, "Already finalized");

  if (_current_elem)
    addCachedValues();
  _current_elem = nullptr;

  _finalized = true;
}

const Elem &
AccumulatorBase::currentElem() const
{
  mooseAssert(_current_elem, "Not set");
  return *_current_elem;
}

void
AccumulatorBase::prepare(const Elem & elem)
{
  mooseAssert(!_finalized, "Already finalized");

  if (_current_elem != &elem)
  {
    if (_current_elem)
      addCachedValues();
    _current_elem = &elem;
    initCachedValues();
  }
}

}
