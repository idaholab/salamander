thickness_monoblock = ${units 6e-3 m}
rings = '1 1 2 12' # '1 30 20 110' # Number of rings in each circle or in the enclosing square of the mesh
num_layer_mesh_thickness = 1

temperature_IC_neutronics = ${units 800 K} # Why 800 K ?

# Mesh
!include divertor_monoblock_mesh.i

[ICs]
  [temperature]
    type = ConstantIC
    variable = temperature
    value = ${temperature_IC_neutronics}
  []
[]

[Problem]
  type = OpenMCCellAverageProblem
  verbose = true
  scaling = 100.0
  temperature_blocks = '2 3 4'
  temperature_variables = 'temperature'

  cell_level = 0
  # max_batches = 100
  # batch_interval = 10
  particles = 100000
  source_strength = 2.3e16 # Particles/s.


  volume_calculation = volume

  check_tally_sum = false
  [Tallies]
    [heat_source]
      type = MeshTally
      mesh_template = 'divertor_monoblock_neutronics_in.e'
      score = 'heating_local flux'
      # tally_trigger = 'rel_err none'
      # tally_trigger_threshold = '0.05 1.0'
      output = unrelaxed_tally_std_dev
    []
  []
[]

[Materials]
  [flux_mat]
    type = ParsedMaterial
    property_name = flux_mat
    coupled_variables = 'flux'
    expression = 'flux'
  []
[]

[UserObjects]
  [volume]
    type = OpenMCVolumeCalculation
    n_samples = 50000
  []
  [flux_patch]
    type = NodalPatchRecoveryMaterialProperty
    patch_polynomial_order = FIRST
    property = 'flux_mat'
    execute_on = 'TIMESTEP_END'
  []
[]

[AuxVariables]
  [flux_recovered]
    block = 4
  []
  [fluence]
    block = 4
  []
[]

[AuxKernels]
  [flux_recovered] # convert from notal to elemental
    type = NodalPatchRecoveryAux
    variable = flux_recovered
    nodal_patch_recovery_uo = flux_patch
    execute_on = 'TIMESTEP_END'
  []
  [fluxTrapazoidalTimeIntegrator]
    type = VariableTimeIntegrationAux
    variable_to_integrate = flux_recovered
    variable = fluence
    order = 2
  []
[]

[Postprocessors]
  [heat_source]
    type = ElementIntegralVariablePostprocessor
    variable = heating_local
  []
  [heat_source_RelativeError]
    type = TallyRelativeError
    tally_score = heating_local
  []
[]

[Executioner]
  type = Transient
  dt = 1e50 # using a very large time so that that time limit of the main app is dictated by the other sub app.
[]

[Outputs]
  [exodus]
    type = Exodus
    sync_only = false
    # output at key moment in the first two cycles, and then at the end of the simulation
    sync_times = '110.0 480.0 590.0 1600.0 1710.0 2080.0 2190.0 3400.0 8.0e4'
    time_step_interval = 2
  []
  csv = true
[]
