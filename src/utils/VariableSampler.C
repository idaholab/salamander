//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
// confinement for Numerical Design, Engineering & Research,
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

#include "VariableSampler.h"

namespace SALAMANDER
{
VariableSampler::VariableSampler(FEProblemBase & problem,
                                 const VariableName & name,
                                 const THREAD_ID tid)
  : _system(problem.getSystem(name)),
    _var_num(
        problem
            .getVariable(
                tid, name, Moose::VarKindType::VAR_ANY, Moose::VarFieldType::VAR_FIELD_STANDARD)
            .number())
{
}

Real
VariableSampler::sampleVariable(const Point & point, const Elem * element) const
{
  return _system.point_value(_var_num, point, element);
}
}
