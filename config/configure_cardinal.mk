# Cardinal contrib variables
CARDINAL_CONTRIB_DIR           := $(CARDINAL_DIR)/contrib
CARDINAL_CONTRIB_INSTALL_DIR   ?= $(CARDINAL_DIR)/install
OPENMC_INSTALL_DIR             := $(CARDINAL_CONTRIB_INSTALL_DIR)
OPENMC_LIBDIR                  := $(OPENMC_INSTALL_DIR)/lib
OPENMC_BUILDDIR                := $(CARDINAL_DIR)/build/openmc
OPENMC_INSTALL_DIR             := $(CARDINAL_CONTRIB_INSTALL_DIR)
OPENMC_INCLUDES                := -I$(OPENMC_INSTALL_DIR)/include
OPENMC_LIBDIR                  := $(OPENMC_INSTALL_DIR)/lib
OPENMC_LIB                     := $(OPENMC_LIBDIR)/libopenmc.so

PETSC_DIR           ?= $(MOOSE_DIR)/petsc
PETSC_ARCH          ?= arch-moose
LIBMESH_DIR         ?= $(MOOSE_DIR)/libmesh/installed/

# This is the Eigen3 location on CIVET. If you are using MOOSE's conda environment,
# you don't need to set these variables, because conda sets them for you. The only
# scenario where you might need to manually set these is if you're not using the
# conda environment. You will get a compile error about FindEigen3.cmake if you
# do indeed need to set these.
EIGEN3_DIR          ?= $(LIBMESH_DIR)/include
Eigen3_DIR          ?= $(EIGEN3_DIR)

# If HDF5_DIR is set, use those settings to link HDF5 to OpenMC.
# Otherwise, use the PETSc location, as the self-built HDF5 libraries will be housed within.
ifeq ($(HDF5_DIR),)
  HDF5_DIR          := $(PETSC_DIR)
  export HDF5_DIR
endif

# HDF5_ROOT is used in makefiles for the Cardinal third-party dependencies.
# Set it using HDF5_DIR
HDF5_ROOT          := $(HDF5_DIR)
export HDF5_ROOT

HDF5_INCLUDE_DIR    ?= $(HDF5_DIR)/include
HDF5_LIBDIR         ?= $(HDF5_DIR)/lib
# This is used in $(FRAMEWORK_DIR)/build.mk
HDF5_INCLUDES       := -I$(HDF5_INCLUDE_DIR) -I$(HDF5_DIR)/include

# BUILD_TYPE will be passed to CMake via CMAKE_BUILD_TYPE
ifeq ($(METHOD),dbg)
  BUILD_TYPE := Debug
else
  BUILD_TYPE := Release
endif

DAGMC_BUILDDIR := $(CARDINAL_DIR)/build/DAGMC
DAGMC_INSTALL_DIR := $(CARDINAL_CONTRIB_INSTALL_DIR)

DOUBLEDOWN_BUILDDIR := $(CARDINAL_DIR)/build/double-down
DOUBLEDOWN_INSTALL_DIR := $(CARDINAL_CONTRIB_INSTALL_DIR)

EMBREE_BUILDDIR := $(CARDINAL_DIR)/build/embree
EMBREE_INSTALL_DIR := $(CARDINAL_CONTRIB_INSTALL_DIR)

MOAB_BUILDDIR := $(CARDINAL_DIR)/build/moab
MOAB_INSTALL_DIR := $(CARDINAL_CONTRIB_INSTALL_DIR)

# Set default values for all third party dependencies
OPENMC_DIR          ?= $(CARDINAL_CONTRIB_DIR)/openmc
NUCLEARDATA_DIR     ?= $(CARDINAL_CONTRIB_DIR)/nuclear_data
DAGMC_DIR           ?= $(CARDINAL_CONTRIB_DIR)/DAGMC
EMBREE_DIR          ?= $(CARDINAL_CONTRIB_DIR)/embree
DOUBLEDOWN_DIR      ?= $(CARDINAL_CONTRIB_DIR)/double-down
MOAB_DIR            ?= $(CARDINAL_CONTRIB_DIR)/moab

# NekRS (optional coupling, enabled with ENABLE_NEK=yes)
# NekRS itself is not built by SALAMANDER: build it first with
# "make build_nekrs" in CARDINAL_DIR.
ENABLE_NEK          ?= no
NEKRS_DIR           ?= $(CARDINAL_CONTRIB_DIR)/nekRS
NEKRS_INSTALL_DIR   := $(CARDINAL_CONTRIB_INSTALL_DIR)
NEKRS_LIBDIR        := $(NEKRS_INSTALL_DIR)/lib
NEKRS_LIB           := $(NEKRS_LIBDIR)/libnekrs.so
NEKRS_INCLUDES      := \
  -I$(NEKRS_DIR)/src \
  -I$(NEKRS_DIR)/src/bdry \
  -I$(NEKRS_DIR)/src/bench/advsub \
  -I$(NEKRS_DIR)/src/bench/axHelm \
  -I$(NEKRS_DIR)/src/bench/core \
  -I$(NEKRS_DIR)/src/bench/fdm \
  -I$(NEKRS_DIR)/src/cds \
  -I$(NEKRS_DIR)/src/core \
  -I$(NEKRS_DIR)/src/findpts \
  -I$(NEKRS_DIR)/src/io \
  -I$(NEKRS_DIR)/src/lib \
  -I$(NEKRS_DIR)/src/linAlg \
  -I$(NEKRS_DIR)/src/mesh \
  -I$(NEKRS_DIR)/src/navierStokes \
  -I$(NEKRS_DIR)/src/nekInterface \
  -I$(NEKRS_DIR)/src/neknek \
  -I$(NEKRS_DIR)/src/plugins \
  -I$(NEKRS_DIR)/src/pointInterpolation \
  -I$(NEKRS_DIR)/src/pointInterpolation/findpts \
  -I$(NEKRS_DIR)/src/postProcessing \
  -I$(NEKRS_DIR)/src/regularization \
  -I$(NEKRS_DIR)/src/setup \
  -I$(NEKRS_DIR)/src/solvers/cvode \
  -I$(NEKRS_DIR)/src/solvers/elliptic \
  -I$(NEKRS_DIR)/src/solvers/elliptic/amgSolver \
  -I$(NEKRS_DIR)/src/solvers/elliptic/linearSolver \
  -I$(NEKRS_DIR)/src/solvers/elliptic/MG \
  -I$(NEKRS_DIR)/src/udf \
  -I$(NEKRS_DIR)/src/utils \
  -I$(NEKRS_INSTALL_DIR)/gatherScatter \
  -I$(NEKRS_INSTALL_DIR)/include \
  -I$(NEKRS_INSTALL_DIR)/libparanumal/include \
  -I$(NEKRS_INSTALL_DIR)/include/libP/parAlmond \
  -I$(NEKRS_INSTALL_DIR)/include/linAlg

# Make sure nuclear data header is findable by SALAMANDER
ADDITIONAL_INCLUDES += -I$(NUCLEARDATA_DIR)

# Use compiler info discovered by PETSC
ifeq ($(PETSC_ARCH),)
  include $(PETSC_DIR)/$(PETSC_ARCH)/lib/petsc/conf/petscvariables
else
  include $(PETSC_DIR)/lib/petsc/conf/petscvariables
endif
