#include "SalamanderApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
SalamanderApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

SalamanderApp::SalamanderApp(InputParameters parameters) : MooseApp(parameters)
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

  /* register custom execute flags, action syntax, etc. here */
}

void
SalamanderApp::registerApps()
{
  registerApp(SalamanderApp);
  ModulesApp::registerApps();
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
