# This is the base input file for the divertor monoblock with heat transfer capabilities.

# Initial condition
temperature_IC = ${units 300 K}

# Mesh
!include divertor_monoblock_mesh.params
!include divertor_monoblock_mesh.i

[Problem]
  type = ReferenceResidualProblem
  extra_tag_vectors = 'ref'
  reference_vector = 'ref'
[]

[Variables]
  [temperature]
    order = FIRST
    family = LAGRANGE
    initial_condition = ${temperature_IC}
  []
[]

[Kernels]
  ############################## Kernels for W (block = 4)
  [heat_conduction_W]
    type = HeatConduction
    variable = temperature
    diffusion_coefficient = thermal_conductivity_W
    block = 4
    extra_vector_tags = ref
  []
  [time_heat_conduction_W]
    type = SpecificHeatConductionTimeDerivative
    variable = temperature
    specific_heat = specific_heat_W
    density = density_W
    block = 4
    extra_vector_tags = ref
  []
  ############################## Kernels for Cu (block = 3)
  [heat_conduction_Cu]
    type = HeatConduction
    variable = temperature
    diffusion_coefficient = thermal_conductivity_Cu
    block = 3
    extra_vector_tags = ref
  []
  [time_heat_conduction_Cu]
    type = SpecificHeatConductionTimeDerivative
    variable = temperature
    specific_heat = specific_heat_Cu
    density = density_Cu
    block = 3
    extra_vector_tags = ref
  []
  ############################## Kernels for CuCrZr (block = 2)
  [heat_conduction_CuCrZr]
    type = HeatConduction
    variable = temperature
    diffusion_coefficient = thermal_conductivity_CuCrZr
    block = 2
    extra_vector_tags = ref
  []
  [time_heat_conduction_CuCrZr]
    type = SpecificHeatConductionTimeDerivative
    variable = temperature
    specific_heat = specific_heat_CuCrZr
    density = density_CuCrZr
    block = 2
    extra_vector_tags = ref
  []
[]

[BCs]
  [temperature_tube]
    type = FunctionDirichletBC
    variable = temperature
    boundary = '2to1'
    function = temperature_inner_func
  []
[]

[Functions]
  ### Maximum coolant temperature of 552K at steady state
  [temperature_inner_func]
    type = ParsedFunction
    expression =   'if((t % 1600) < 100.0, 300.0 + (552-300)*(t % 1600)/100,
                    if((t % 1600) < 500.0, 552,
                    if((t % 1600) < 600.0, 552.0 - (552-300)*((t % 1600)-500)/100, 300)))'
  []
  [timestep_function]
    type = ParsedFunction
    expression = 'if((t % 1600) <   10.0,  20,
                  if((t % 1600) <   90.0,  40,
                  if((t % 1600) <  110.0,  20,
                  if((t % 1600) <  480.0,  40,
                  if((t % 1600) <  500.0,  20,
                  if((t % 1600) <  590.0,   4,
                  if((t % 1600) <  610.0,  20,
                  if((t % 1600) < 1500.0, 200,
                  if((t % 1600) < 1600.0,  40,  2)))))))))'
  []
[]

[Materials]
  [heat_transfer_W]
    type = GenericConstantMaterial
    prop_names = 'density_W'
    prop_values = '19300'        # [g/m^3]
    block = 4
  []
  [specific_heat_W]
    type = ParsedMaterial
    property_name = specific_heat_W
    coupled_variables = 'temperature'
    block = 4
    expression = '1.16e2 + 7.11e-2 * temperature - 6.58e-5 * temperature^2 + 3.24e-8 * temperature^3 -5.45e-12 * temperature^4'  # ~ 132[J/kg-K]
    outputs = all
  []
  [thermal_conductivity_W]
    type = ParsedMaterial
    property_name = thermal_conductivity_W
    coupled_variables = 'temperature'
    block = 4
    # expression = '-7.8e-9 * temperature^3 + 5.0e-5 * temperature^2 - 1.1e-1 * temperature + 1.8e2'  # ~ 173.0 [ W/m-K]   from R. Delaporte-Mathurin et al 2021 Nucl. Fusion 61 036038,
    expression = '2.41e2 - 2.90e-1 * temperature + 2.54e-4 * temperature^2 - 1.03e-7 * temperature^3 + 1.52e-11 * temperature^4'  # ~ 173.0 [ W/m-K]
    outputs = all
  []
  ############################## Materials for Cu (block = 3)
  [heat_transfer_Cu]
    type = GenericConstantMaterial
    prop_names = 'density_Cu'
    prop_values = '8960.0'        # [g/m^3]
    block = 3
  []
  [specific_heat_Cu]
    type = ParsedMaterial
    property_name = specific_heat_Cu
    coupled_variables = 'temperature'
    block = 3
    expression = '3.16e2 + 3.18e-1 * temperature - 3.49e-4 * temperature^2 + 1.66e-7 * temperature^3'  # ~ 384 [J/kg-K]
    outputs = all
  []
  [thermal_conductivity_Cu]
    type = ParsedMaterial
    property_name = thermal_conductivity_Cu
    coupled_variables = 'temperature'
    block = 3
    # expression = '-3.9e-8 * temperature^3 + 3.8e-5 * temperature^2 - 7.9e-2 * temperature + 4.0e2'  # ~ 401.0  [ W/m-K] from R. Delaporte-Mathurin et al 2021 Nucl. Fusion 61 036038,
    expression = '4.21e2 - 6.85e-2 * temperature'  # ~ 400.0 [ W/m-K]
    outputs = all
  []
  ############################## Materials for CuCrZr (block = 2)
  [heat_transfer_CuCrZr]
    type = GenericConstantMaterial
    prop_names = 'density_CuCrZr specific_heat_CuCrZr'
    prop_values = '8900.0 390.0'      # [g/m^3], [J/kg-K]
    block = 2
  []
  [thermal_conductivity_CuCrZr]
    type = ParsedMaterial
    property_name = thermal_conductivity_CuCrZr
    coupled_variables = 'temperature'
    block = 2
    # expression = '5.3e-7 * temperature^3 - 6.5e-4 * temperature^2 + 2.6e-1 * temperature + 3.1e2'  # ~ 320.0  [ W/m-K] from R. Delaporte-Mathurin et al 2021 Nucl. Fusion 61 036038,
    expression = '3.87e2 - 1.28e-1 * temperature'  # ~ 349 [ W/m-K]
    outputs = all
  []
[]

[Postprocessors]
  ############################################################ Postprocessors for others
  [dt]
    type = TimestepSize
  []
  [temperature_top]
    type = PointValue
    variable = temperature
    point = '0 14.0e-3 0'
  []
  [temperature_tube]
    type = PointValue
    variable = temperature
    point = '0 6.0e-3 0'
  []
  # limit timestep
  [timestep_max_pp] # s
  type = FunctionValuePostprocessor
  function = timestep_function
  []
[]

[VectorPostprocessors]
  [line_temperature]
    type = LineValueSampler
    start_point = '0 14.0e-3 0'
    end_point = '0 6.0e-3 0'
    num_points = 100
    sort_by = 'y'
    variable = 'temperature'
    execute_on = timestep_end
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -mat_mffd_err -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'lu  superlu_dist   1e-5      NONZERO         1e-15'
  nl_rel_tol  = 1e-6 # 1e-8 works for 1 cycle
  nl_abs_tol  = 1e-7 # 1e-11 works for 1 cycle
  end_time = 8.0e4   # 50 ITER shots (3.0e4 s plasma, 2.0e4 SSP)
  automatic_scaling = true
  line_search = 'none'
  dtmin = 1e-5
  nl_max_its = 18
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 20
    optimal_iterations = 15
    iteration_window = 1
    growth_factor = 1.2
    cutback_factor = 0.8
    timestep_limiting_postprocessor = timestep_max_pp
  []
[]

[Outputs]
  file_base = ${outputs_name}
  [exodus]
    type = Exodus
    sync_only = false
    # output at key moment in the first two cycles, and then at the end of the simulation
    sync_times = '110.0 480.0 590.0 1600.0 1710.0 2080.0 2190.0 3400.0 8.0e4'
    time_step_interval = 2
  []
  csv = true
  perf_graph = true
[]
