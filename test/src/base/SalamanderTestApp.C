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

#include "SalamanderTestApp.h"
#include "SalamanderApp.h"
#include "SalamanderHeader.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

InputParameters
SalamanderTestApp::validParams()
{
  InputParameters params = SalamanderApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

SalamanderTestApp::SalamanderTestApp(InputParameters parameters) : MooseApp(parameters)
{
  SalamanderTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

SalamanderTestApp::~SalamanderTestApp() {}

std::string
SalamanderTestApp::header() const
{
  return SalamanderHeader::header();
}

void
SalamanderTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  SalamanderApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"SalamanderTestApp"});
    Registry::registerActionsTo(af, {"SalamanderTestApp"});
  }
}

void
SalamanderTestApp::registerApps()
{
  registerApp(SalamanderTestApp);
  SalamanderApp::registerApps();
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
SalamanderTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  SalamanderTestApp::registerAll(f, af, s);
}
extern "C" void
SalamanderTestApp__registerApps()
{
  SalamanderTestApp::registerApps();
}
