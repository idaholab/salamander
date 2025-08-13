# This test runs a coupled OpenMC and heat conduction model using a CAD-based geometry. The model
# uses an exodus (tmesh_1.e to use in MOOSE) and DAGMC (tmesh_1.h5m to use in OpenMC) meshes.
# openmc.i runs OpenMC to tally heating and tritium production taking cells temperature from MOOSE.

[Mesh]
  [file]
    type = FileMeshGenerator
    file = tmesh_1.e
  []
  allow_renumbering = false
[]

[AuxVariables]
  [cell_temperature]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [cell_temperature]
    type = CellTemperatureAux
    variable = cell_temperature
  []
[]

[Problem]
  type = OpenMCCellAverageProblem
  cell_level = 0
  temperature_blocks = '1 2 3'
  temperature_variables = 'temperature'

  source_strength = 1e18 # Particles/s.
  volume_calculation = volume

  verbose = true
  particles = 500
  batches = 5

  skinner = moab
  [Tallies]
    [heating_tritium]
      type = MeshTally
      score = 'heating_local H3_production'
      name = 'heating_local tritium_production'
      output = unrelaxed_tally_std_dev
    []
  []
[]

[UserObjects]
  [volume]
    type = OpenMCVolumeCalculation
    n_samples = 5000
  []
  [moab]
    type = MoabSkinner
    temperature_min = 800
    temperature_max = 1500
    n_temperature_bins = 10
    temperature = temperature
    build_graveyard = true
  []
[]

[Postprocessors]
  [heat_source]
    type = ElementIntegralVariablePostprocessor
    variable = heating_local
  []
  [tritium_production]
    type = ElementIntegralVariablePostprocessor
    variable = tritium_production
  []
  [tritium_RelativeError]
    type = TallyRelativeError
    tally_score = H3_production
  []
  [heat_source_RelativeError]
    type = TallyRelativeError
    tally_score = heating_local
  []
[]

[Executioner]
  type = Transient
[]

[Outputs]
  exodus = true
  csv = true
[]
