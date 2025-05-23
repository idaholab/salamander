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

#include "SalamanderHeader.h"
#include <sstream>

namespace SalamanderHeader
{
std::string
header()
{
  std::stringstream header;
  header << "\n\n"
         << "   ____    _    _        _    __  __    _    _   _ ____  _____ ____   \n"
         << "  / ___|  / \\  | |      / \\  |  \\/  |  / \\  | \\ | |  _ \\| ____|  _ \\  \n"
         << "  \\___ \\ / _ \\ | |     / _ \\ | |\\/| | / _ \\ |  \\| | | | |  _| | |_) | \n"
         << "   ___) / ___ \\| |___ / ___ \\| |  | |/ ___ \\| |\\  | |_| | |___|  _ <  \n"
         << "  |____/_/   \\_\\_____/_/   \\_\\_|  |_/_/   \\_\\_| \\_|____/|_____|_| \\_\\ \n"
         << "\n\n"
         << "SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic confinement for Numerical Design, Engineering & Research \n"
         << "\n\n"
         << "Copyright 2025, Battelle Energy Alliance, LLC \n"
         << "ALL RIGHTS RESERVED \n"
         << "\n\n"
         << "NOTICE: These data were produced by BATTELLE ENERGY ALLIANCE, LLC under Contract \n"
         << "No. DE-AC07-05ID14517 with the Department of Energy. For ten(10) years from \n"
         << "June 13, 2024, the Government is granted for itself and others acting on its behalf \n"
         << "a nonexclusive, paid-up, irrevocable worldwide license in this data to reproduce, \n"
         << "prepare derivative works, and perform publicly and display publicly, by or on \n"
         << "behalf of the Government. There is provision for the possible extension of the \n"
         << "term of this license. Subsequent to that period or any extension granted, the \n"
         << "Government is granted for itself and others acting on its behalf a nonexclusive, \n"
         << "paid-up, irrevocable worldwide license in this data to reproduce, prepare \n"
         << "derivative works, distribute copies to the public, perform publicly and display \n"
         << "publicly, and to permit others to do so. The specific term of the license can be \n"
         << "identified by inquiry made to Contractor or DOE. NEITHER THE UNITED STATES NOR \n"
         << "THE UNITED STATES DEPARTMENT OF ENERGY, NOR ANY OF THEIR EMPLOYEES, MAKES ANY \n"
         << "WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY LEGAL LIABILITY OR RESPONSIBILITY \n"
         << "FOR THE ACCURACY, COMPLETENESS, OR USEFULNESS OF ANY DATA, APPARATUS, PRODUCT, \n"
         << "OR PROCESS DISCLOSED, OR REPRESENTS THAT ITS USE WOULD NOT INFRINGE PRIVATELY \n"
         << "OWNED RIGHTS. \n"
         << "\n\n";
  return header.str();
}
} // namespace SalamanderHeader
