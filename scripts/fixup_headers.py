#!/usr/bin/env python3

# This script checks and can optionally update SALAMANDER source files.
# You should always run this script without the "-u" option
# first to make sure there is a clean dry-run of the files that should
# be updated
# This is based on a script of the same name in the MOOSE Framework:
# https://github.com/idaholab/moose/blob/c36c4a18fba0ccf92769bbaef5e6b2d2ba7a43c1/framework/scripts/fixup_headers.py

import os, string, re, shutil
from optparse import OptionParser

global_dir_ignores = ['contrib', '.svn', '.git', 'moose']
global_file_ignores = ['moosedocs.py']

unified_header = """\
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
//*"""

python_header = """\
#* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic confinement for Numerical Design, Engineering & Research,
#* A multiphysics application for modeling plasma facing components
#* https://github.com/idaholab/salamander
#* https://mooseframework.inl.gov/salamander
#*
#* SALAMANDER is powered by the MOOSE Framework
#* https://www.mooseframework.inl.gov
#*
#* Licensed under LGPL 2.1, please see LICENSE for details
#* https://www.gnu.org/licenses/lgpl-2.1.html
#*
#* Copyright 2025, Battelle Energy Alliance, LLC
#* ALL RIGHTS RESERVED
#*"""

global_options = {}

def fixupHeader():
    for dirpath, dirnames, filenames in os.walk(os.getcwd() + ""):

        # Don't traverse into ignored directories
        for ignore in global_dir_ignores:
            if ignore in dirnames:
                dirnames.remove(ignore)

        # Don't check ignored files
        for ignore in global_file_ignores:
            if ignore in filenames:
                filenames.remove(ignore)

        for file in filenames:
            suffix = os.path.splitext(file)
            if (suffix[-1] == '.C' or suffix[-1] == '.h') and not global_options.python_only:
                checkAndUpdateCPlusPlus(os.path.abspath(dirpath + '/' + file))
            if suffix[-1] == '.py' and not global_options.cxx_only:
                checkAndUpdatePython(os.path.abspath(dirpath + '/' + file))

def checkAndUpdateCPlusPlus(filename):
    # Don't update soft links
    if os.path.islink(filename):
        return

    f = open(filename)
    text = f.read()
    f.close()

    header = unified_header

    # Check (exact match only)
    if (text.find(header) == -1 or global_options.force == True):
        # print the first 10 lines or so of the file
        if global_options.update == False: # Report only
            print(filename + ' does not contain an up to date header')
            if global_options.verbose == True:
                print('>'*40, '\n', '\n'.join((text.split('\n', 10))[:10]), '\n'*5)
        else:
            # Make sure any previous C-style header version is removed
            text = re.sub(r'^/\*+/$.*^/\*+/$', '', text, flags=re.S | re.M)

            # Make sure that any previous C++-style header (with extra character)
            # is also removed.
            text = re.sub(r'(?:^//\*.*\n)*', '', text, flags=re.M)

            # Now cleanup extra blank lines
            text = re.sub(r'\A(^\s*\n)', '', text)

            # Remove ifdefs in favor of pragmas
            suffix = os.path.splitext(filename)
            if suffix[-1] == '.h':
                text = re.sub(r'^#ifndef\s*\S+_H_?\s*\n#define.*\n', '', text, flags=re.M)
                text = re.sub(r'^#endif.*\n[\s]*\Z', '', text, flags=re.M)

            # Update
            f = open(filename + '~tmp', 'w')
            f.write(header + '\n\n')

            # Insert pragma once if not already present
            if suffix[-1] == '.h':
                if not re.search(r'#pragma once', text):
                    f.write("#pragma once\n")

            f.write(text)
            f.close()
            os.rename(filename + '~tmp', filename)

def checkAndUpdatePython(filename):
    f = open(filename)
    text = f.read()
    f.close()

    header = python_header

    # Check (exact match only)
    if (text.find(header) == -1):
        # print the first 10 lines or so of the file
        if global_options.update == False: # Report only
            print(filename + ' does not contain an up to date header')
            if global_options.verbose == True:
                print('>'*40, '\n', '\n'.join((text.split('\n', 10))[:10]), '\n'*5)
        else:
            # Save off the shebang line if it exists
            m = re.match(r'#!.*\n', text)
            shebang = ''
            if m:
                shebang = m.group(0)
                text = re.sub(r'^.*\n', '', text)

            # Save off any pytlint disable directives
            m = re.match(r'\A#pylint:\s+disable.*\n', text)
            pylint_disable = ''
            if m:
                pylint_disable = m.group(0)
                text = re.sub(r'^.*\n', '', text)

            pylint_enable = False
            if re.search(r'#pylint: enable=missing-docstring', text) != None:
                pylint_enable = True

            # Make sure any previous box-style header version is removed
            text = re.sub(r'\A(?:#.*#\n)*', '', text)

            # Make sure any previous version of the new header is removed
            text = re.sub(r'^#\*.*\n', '', text, flags=re.M)

            # Discard any pylint missing-docstring commands
            text = re.sub(r'\A#pylint:.*missing-docstring.*\n', '', text)

            # Now cleanup extra blank lines at the beginning of the file
            text = re.sub(r'\A(^\s*\n)', '', text)

            # Update
            f = open(filename + '~tmp', 'w')

            f.write(shebang)
            f.write(pylint_disable)
            f.write(header + '\n')
            if pylint_enable:
                f.write('#pylint: enable=missing-docstring\n')

            if len(text) != 0:
                f.write('\n' + text)

            f.close()

            shutil.copystat(filename, filename + '~tmp')
            os.rename(filename + '~tmp', filename)

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-u", "--update", action="store_true", dest="update", default=False)
    parser.add_option("-v", "--verbose", action="store_true", dest="verbose", default=False)
    parser.add_option("--python-only", action="store_true", dest="python_only", default=False)
    parser.add_option("--cxx-only", action="store_true", dest="cxx_only", default=False)
    parser.add_option("-f", "--force", action="store_true", dest="force", default=False)

    (global_options, args) = parser.parse_args()
    fixupHeader()
