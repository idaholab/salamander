#!/usr/bin/env bash
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
#*

# This script builds Cardinal as a SALAMANDER dependency. Unlike Cardinal's
# documented build (cardinal/doc/content/with_conda.md), it builds only the
# Cardinal library and its third-party contrib libraries (OpenMC, MOAB, DagMC),
# NOT the 'cardinal-opt' executable. SALAMANDER links against these libraries,
# so the executable is unnecessary. This is achieved by overriding BUILD_EXEC=no,
# which MOOSE's app.mk uses to build the application library target instead of
# the executable target.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Parse command line args, collecting any unrecognized ones to pass on to make
for i in "$@"
do
  shift
  if [[ "$i" == "-h" || "$i" == "--help" ]]; then
    help=1;
  fi

  if [ "$i" == "--skip-submodule-update" ]; then
    skip_sub_update=1;
  elif [ "$i" == "--quiet-build" ]; then
    quiet_build=1;
    quiet_build_logfile="$SCRIPT_DIR/cardinal_build_$(date +%Y-%m-%d.%H:%M:%S).log"
  else # Remove everything else before passing to make
    set -- "$@" "$i"
  fi
done

SALAMANDER_DIR=${SCRIPT_DIR}/..

# CARDINAL_DIR can be set to build a Cardinal that is not the SALAMANDER submodule.
# In that case, we do not touch git submodules.
if [ -n "$CARDINAL_DIR" ]; then
  skip_sub_update=1
else
  CARDINAL_DIR=${SALAMANDER_DIR}/cardinal
fi

# Display help
if [[ -n "$help" ]]; then
  echo "Usage: $0 [-h | --help | --skip-submodule-update | --quiet-build | <make options> ]"
  echo
  echo "Builds the Cardinal library (and its OpenMC/MOAB/DagMC contrib libraries)"
  echo "for use as a SALAMANDER dependency. Does NOT build the cardinal-opt executable."
  echo
  echo "-h | --help              Display this message"
  echo "--skip-submodule-update  Do not fetch/update Cardinal and its contrib submodules,"
  echo "                         use whatever is currently checked out (fast rebuild)"
  echo "--quiet-build            Only output the build to screen on failure"
  echo
  echo "Any other arguments are passed directly to Cardinal's 'make'."
  echo "Influential environment variables (see cardinal/doc/content/with_conda.md):"
  echo "  ENABLE_NEK     Build the NekRS coupling (default: false; incompatible with conda)"
  echo "  ENABLE_OPENMC  Build the OpenMC coupling (default: yes)"
  echo "  ENABLE_DAGMC   Build OpenMC with DagMC support (default: yes, to match SALAMANDER)"
  echo "  MOOSE_DIR      MOOSE to build against (default: SALAMANDER's MOOSE submodule)"
  echo "  HDF5_ROOT      Root HDF5 directory (defaults to CONDA_PREFIX when in a conda env)"
  echo "  METHOD         Optimization method to build (opt, oprof, dbg)"
  echo "  MOOSE_JOBS     Number of parallel build jobs (default: 1)"
  echo "*************************************************************************************"
  exit 0
fi

# Environment variables required/recommended by Cardinal's conda build instructions.
# We default ENABLE_NEK to false because MOOSE's conda environment is incompatible
# with Cardinal's NekRS wrapping, and SALAMANDER does not use NekRS. We default
# ENABLE_DAGMC to yes to match SALAMANDER, which links against Cardinal's DagMC and
# MOAB libraries (see config/build_deps.mk).
export ENABLE_NEK=${ENABLE_NEK:-false}
export ENABLE_DAGMC=${ENABLE_DAGMC:-yes}

# Cardinal builds against the same MOOSE that SALAMANDER uses. Locate MOOSE the same way
# doc/moosedocs.py does: respect a developer-provided MOOSE_DIR, otherwise look for
# SALAMANDER's MOOSE submodule, then for a MOOSE checkout adjacent to SALAMANDER. Cardinal's
# Makefile picks this up via its 'MOOSE_DIR ?= $(CONTRIB_DIR)/moose' default, so its own
# contrib/moose submodule is neither needed nor fetched.
if [ -z "$MOOSE_DIR" ]; then
  MOOSE_DIR=${SALAMANDER_DIR}/moose
  if [ ! -f "$MOOSE_DIR/framework/Makefile" ]; then
    MOOSE_DIR=${SALAMANDER_DIR}/../moose
  fi
fi
# Fail if MOOSE cannot be found in any of these locations.
if [ ! -f "$MOOSE_DIR/framework/Makefile" ]; then
  echo "Error: Failed to locate MOOSE at $MOOSE_DIR."
  echo "Specify the MOOSE_DIR environment variable, check out the MOOSE submodule, or"
  echo "place a MOOSE checkout adjacent to the SALAMANDER directory."
  exit 1
fi
export MOOSE_DIR
echo "INFO: Cardinal will build against MOOSE_DIR=$MOOSE_DIR"

# When building inside MOOSE's conda environment, OpenMC needs to find HDF5 and
# some libraries need an explicit search path. These are conda-specific, so only
# set them when a conda environment is active.
if [ -n "$CONDA_PREFIX" ]; then
  export HDF5_ROOT=${HDF5_ROOT:-$CONDA_PREFIX}
  export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
fi

# Fetch the Cardinal contrib dependencies that SALAMANDER builds. We first make sure
# the Cardinal submodule itself is present.
if [ -z "$skip_sub_update" ]; then
  cd ${SALAMANDER_DIR}
  git_dir=`git rev-parse --show-cdup 2>/dev/null`
  if [[ $? == 0 && "x$git_dir" == "x" ]]; then
    git submodule update --init cardinal
    if [[ $? != 0 ]]; then
      echo "git submodule command failed, are your proxy settings correct?"
      exit 1
    fi
  fi

  # Fetch only the contrib submodules SALAMANDER builds, rather than calling Cardinal's
  # get-dependencies.sh (which also pulls MOOSE, NekRS, Double-Down, Embree, and the
  # nek_ci test data that SALAMANDER does not use here). OpenMC must be fetched
  # recursively for its vendored submodules (pugixml, fmt, Catch2); the rest are
  # non-recursive. Cardinal's own contrib/moose is intentionally skipped - we build
  # against SALAMANDER's MOOSE_DIR instead.
  cd ${CARDINAL_DIR}
  git submodule update --init contrib/nuclear_data contrib/DAGMC contrib/moab && \
    git submodule update --init --recursive contrib/openmc || exit 1
fi

cd ${CARDINAL_DIR}

if [[ -n "$quiet_build" ]]; then
  echo ""
  echo "Quiet build enabled (--quiet-build)"
  echo "Build output will be redirected to" $quiet_build_logfile "and will only be shown on failure"
  echo ""
  echo "Building quietly... this will take some time"
  echo ""
fi

# let CARDINAL_JOBS be either MOOSE_JOBS, or 1 if MOOSE_JOBS is not set. Make will
# then build with either JOBS if set, or CARDINAL_JOBS.
CARDINAL_JOBS=${MOOSE_JOBS:-1}
BUILD_JOBS=${JOBS:-$CARDINAL_JOBS}

# Helper for running build commands that allows us to redirect
# output to $quiet_build_logfile if --quiet-build is set
function run_build_cmd()
{
  echo "Running" $@"..."
  if [[ -n "$quiet_build" ]]; then
    $@ &> "$quiet_build_logfile"
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
      echo ""
      echo "Quiet build failed, printing output of "$quiet_build_logfile":"
      echo ""
      cat "$quiet_build_logfile"
      exit 1;
    fi
  else
    $@ || exit 1
  fi
}

# BUILD_EXEC=no builds only the Cardinal library (and its contrib libraries), not the
# executable. The MAKEFLAGS=-j part tells the CMake-based contrib builds (OpenMC, DagMC)
# to also build in parallel; otherwise they build serially.
run_build_cmd make BUILD_EXEC=no -j ${BUILD_JOBS} MAKEFLAGS=-j${BUILD_JOBS} $*

if [[ -n "$quiet_build" ]]; then
  echo "Quiet build succeeded!"
fi

# Local Variables:
# sh-basic-offset: 2
# sh-indentation: 2
# End:
