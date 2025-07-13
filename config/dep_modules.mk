# TMAP8
ifeq ($(ENABLE_TMAP8),yes)
  CHEMICAL_REACTIONS          := yes
  FLUID_PROPERTIES            := yes
  HEAT_TRANSFER               := yes
  MISC                        := yes
  NAVIER_STOKES               := yes
  PHASE_FIELD                 := yes
  RAY_TRACING                 := yes
  RDG                         := yes
  SCALAR_TRANSPORT            := yes
  SOLID_PROPERTIES            := yes
  SOLID_MECHANICS             := yes
  THERMAL_HYDRAULICS          := yes
endif

# Cardinal
ifeq ($(ENABLE_CARDINAL),yes)
  FLUID_PROPERTIES    := yes
  HEAT_TRANSFER       := yes
  NAVIER_STOKES       := yes
  RAY_TRACING         := yes
  REACTOR             := yes
  SOLID_MECHANICS     := yes
  SOLID_PROPERTIES    := yes
  STOCHASTIC_TOOLS    := yes
  SUBCHANNEL          := yes
  THERMAL_HYDRAULICS  := yes
endif
