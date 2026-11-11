///* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
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


#include "BlanketCreateMeshAction.h"
#include "BlanketProblem.h"
#include "THMMesh.h"
#include "CreateProblemAction.h"
#include "FEProblemBase.h"
#include "MooseApp.h"
#include "Factory.h"

registerMooseAction("SalamanderApp", BlanketCreateMeshAction, "setup_mesh");
registerMooseAction("SalamanderApp", BlanketCreateMeshAction, "uniform_refine_mesh");

// ---------------------------------------------------------------------------------------------
// WHY THIS ACTION EXISTS, AND HOW TO REMOVE IT ("Route B" — the upstream fix)
// ---------------------------------------------------------------------------------------------
//
// PROBLEM. THMCreateMeshAction::act() hardcodes the problem class:
//
//     const std::string class_name = "THMProblem";
//     ...
//     _problem = _factory.create<FEProblemBase>(class_name, "THM:problem", params);
//
// It DOES harvest the [Problem] input block (via getActionByTask<CreateProblemAction> +
// applyParameters), but the destination param set is getValidParams("THMProblem"). Since
// applyParameters only copies keys present in the destination, any parameter unique to a
// THMProblem subclass (e.g. BlanketProblem::master_bdry_name) is silently dropped, and the
// object built is always a THMProblem regardless of [Problem]/type.
//
// Setting [Problem] type = BlanketProblem cannot fix this, and is in fact fatal. THM must
// build a problem early (components attach during THM:add_component, before create_problem),
// so THMCreateMeshAction sets _problem at setup_mesh. Later, at create_problem, the framework
// CreateProblemAction::act() runs:
//
//     if (_mesh.get() != NULL && _pars.isParamSetByUser("type"))
//     {
//       if (_problem)
//         mooseError("Trying to build a problem but problem has already existed");
//       ...
//     }
//
// The isParamSetByUser("type") gate means this action is dormant UNLESS the user names a type;
// once named, it asserts sole ownership of problem creation and errors on the pre-existing THM
// problem. So [Problem]/type is structurally incompatible with THM's early problem build.
//
// ROUTE B (upstream fix; two small, coordinated edits). When applied, THM would honor
// [Problem] type = <THMProblem subclass>, this SALAMANDER action could be deleted, and inputs
// could use the natural [Problem] block again:
//
//   (1) In THMCreateMeshAction::act(), stop hardcoding the class. Read the requested type from
//       the CreateProblemAction and default to THMProblem:
//
//         std::string class_name = "THMProblem";
//         auto p = _awh.getActionByTask<CreateProblemAction>("create_problem");
//         if (p && p->userSetType())          // see (1a)
//           class_name = p->getMooseObjectType();
//         InputParameters params = _factory.getValidParams(class_name);
//
//       Optionally assert the chosen class derives from THMProblem (dynamic check after build,
//       or a registry/type check) to give a clear error if a non-THM problem is requested.
//
//       (1a) CreateProblemAction currently exposes getMooseObjectType()/getObjectParams() but
//            NOT whether the user actually set "type". Comparing getMooseObjectType() against
//            "THMProblem" is unreliable, because a bare [Problem] block (e.g. only solve=false)
//            still yields a non-empty default type. Add a trivial, robust accessor:
//
//              // CreateProblemAction (public)
//              bool userSetType() const { return _pars.isParamSetByUser("type"); }
//
//            This is the exact predicate CreateProblemAction::act() already uses to decide
//            whether to fire, so THM's override and the framework's create step trigger on
//            identical logic.
//
//   (2) In CreateProblemAction::act(), make the existing-problem case DEFER when the already
//       built problem is exactly the type this action would have built, instead of erroring
//       unconditionally. This preserves the "I named a type, I must build it" contract while
//       allowing a custom action to have legitimately pre-built that same type:
//
//         if (_problem)
//         {
//           if (_problem->type() == _type)
//             return;                 // custom/THM action already built exactly this type
//           mooseError("Trying to build a problem but problem has already existed");
//         }
//
//       This mirrors the type-aware else-branch that CreateProblemDefaultAction already uses
//       for its EigenProblem sanity check, so the three problem-creation actions become
//       consistent (all guard on _problem; all reason about type rather than mere existence).
//
// With (1) and (2) in place: THM builds BlanketProblem at setup_mesh, applyParameters carries
// master_bdry_name (destination is now BlanketProblem's param set), and CreateProblemAction
// sees the matching type and steps aside. This override becomes unnecessary.
// ---------------------------------------------------------------------------------------------

InputParameters
BlanketCreateMeshAction::validParams()
{
  InputParameters params = THMCreateMeshAction::validParams();
  params.addClassDescription(
      "SALAMANDER override of THMCreateMeshAction that constructs a BlanketProblem "
      "(a THMProblem subclass) instead of a stock THMProblem.");
  return params;
}

BlanketCreateMeshAction::BlanketCreateMeshAction(const InputParameters & parameters)
  : THMCreateMeshAction(parameters)
{
}

void
BlanketCreateMeshAction::act()
{
  if (_current_task == "setup_mesh")
  {
    if (!_mesh)
    {
      const std::string mesh_class = "THMMesh";
      InputParameters mesh_params = _factory.getValidParams(mesh_class);
      mesh_params.set<MooseEnum>("dim") = "3";
      mesh_params.set<unsigned int>("patch_size") = 1;
      _mesh = _factory.create<THMMesh>(mesh_class, "THM:mesh", mesh_params);
    }
    if (!_mesh->hasMeshBase())
      _mesh->setMeshBase(_mesh->buildMeshBaseObject());

    if (!_problem)
    {
      const std::string problem_class = "BlanketProblem";
      InputParameters params = _factory.getValidParams(problem_class);
      _app.builder().extractParams("", params);              // GlobalParams incl. master_bdry_name
      if (auto p = _awh.getActionByTask<CreateProblemAction>("create_problem"))
        params.applyParameters(p->getObjectParams());
      params.set<MooseMesh *>("mesh") = _mesh.get();
      params.set<bool>("use_nonlinear") = _app.useNonlinear();
      _problem = _factory.create<FEProblemBase>(problem_class, "THM:problem", params);
    }
  }
  else if (_current_task == "uniform_refine_mesh")
  {
    if (_app.isParamSetByUser("refinements"))
    {
      auto level = _app.getParam<unsigned int>("refinements");
      _mesh->setUniformRefineLevel(level, false);
    }
  }
}
