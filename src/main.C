//* This file is part of SALAMANDER: Fusion Energy Integrated Multiphys-X,
//* A multiphysics application for modeling plasma facing components
//* https://github.com/idaholab/salamander
//*
//* SALAMANDER is powered by the MOOSE Framework
//* https://www.mooseframework.inl.gov
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "SalamanderTestApp.h"
#include "MooseMain.h"

int
main(int argc, char * argv[])
{
  Moose::main<SalamanderTestApp>(argc, argv);

  return 0;
}
