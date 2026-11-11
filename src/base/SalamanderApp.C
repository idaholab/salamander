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

#include "SalamanderApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

// contribs
#ifdef ENABLE_TMAP8
#include "TMAP8App.h"
#endif

#ifdef ENABLE_CARDINAL
#include "CardinalApp.h"
#endif

InputParameters
SalamanderApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

SalamanderApp::SalamanderApp(const InputParameters & parameters) : MooseApp(parameters)
{
  SalamanderApp::registerAll(_factory, _action_factory, _syntax);
}

SalamanderApp::~SalamanderApp() {}

void
SalamanderApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<SalamanderApp>(f, af, s);
  Registry::registerObjectsTo(f, {"SalamanderApp"});
  Registry::registerActionsTo(af, {"SalamanderApp"});

#ifdef ENABLE_TMAP8
  TMAP8App::registerAll(f, af, s);
#endif

#ifdef ENABLE_CARDINAL
  CardinalApp::registerAll(f, af, s);
#endif

  /* register custom execute flags, action syntax, etc. here */

  // THM binds THMCreateMeshAction to [Components] for BOTH setup_mesh and uniform_refine_mesh
  // inside the ModulesApp registration above. We take over both bindings so no stock THMProblem
  // is ever built and there is no execution-order race.
  //
  // NOTE: replaceActionSyntax() clears ALL actions on the syntax, then adds the one named. So it
  // must be called EXACTLY ONCE — a second replace would wipe the first. We use it to clear THM
  // and claim setup_mesh, then use plain registerActionSyntax() (which appends without clearing)
  // to also bind uniform_refine_mesh. Order matters: replace first, then register.
  //
  // Route B (upstream fix) would make all of this unnecessary; see BlanketCreateMeshAction.C.
  s.replaceActionSyntax("BlanketCreateMeshAction", "Components", "setup_mesh", __FILE__, __LINE__);
  s.registerActionSyntax(
      "BlanketCreateMeshAction", "Components", "uniform_refine_mesh", __FILE__, __LINE__);
}

void
SalamanderApp::registerApps()
{
  registerApp(SalamanderApp);
  ModulesApp::registerApps();

#ifdef ENABLE_TMAP8
  TMAP8App::registerApps();
#endif

#ifdef ENABLE_CARDINAL
  CardinalApp::registerApps();
#endif
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
SalamanderApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  SalamanderApp::registerAll(f, af, s);
}
extern "C" void
SalamanderApp__registerApps()
{
  SalamanderApp::registerApps();
}
