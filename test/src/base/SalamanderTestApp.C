//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "SalamanderTestApp.h"
#include "SalamanderApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
SalamanderTestApp::validParams()
{
  InputParameters params = SalamanderApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

SalamanderTestApp::SalamanderTestApp(InputParameters parameters) : MooseApp(parameters)
{
  SalamanderTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

SalamanderTestApp::~SalamanderTestApp() {}

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
