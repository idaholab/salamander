inch_to_m = 0.0254
thermal_blocks = 'vol5 vol6 vol7 vol8 vol9 vol15 vol16 vol17'
tungsten = 'vol17'
copper = 'vol16 vol9'
SS = 'vol5 vol6 vol7 vol8'
molybdenum = 'vol15'

stainless_steel_thermal_conductivity = 16.0 # W/(m·K)
stainless_steel_density = 8000.0 # kg/m3
stainless_steel_specific_heat = 500.0 # J/(kg·K)

copper_thermal_conductivity = 400.0 # W/(m·K)
copper_density = 8960.0 # kg/m3
copper_specific_heat = 385.0 # J/(kg·K)

molybdenum_thermal_conductivity = 138.0 # W/(m·K)
molybdenum_density = 10220.0 # kg/m3
molybdenum_specific_heat = 250.0 # J/(kg·K)

cooling_boundaries = 'cooling_channel_vol7 cooling_channel_vol5_outer'

T_initial = 300.0 # K
T_coolant = 300.0 # K

q_target_peak = 5.0e6 # W/m2
t_ramp_up_end = 0.25 # s
t_flat_end = 5.0 # s
t_ramp_down_end = 5.25 # s
t_end = 20.0 # s
thermal_dt = 0.05 # s

cooling_htc = 2.0e4 # W/(m2.K)

[Mesh]
  [solid]
    type = FileMeshGenerator
    file = tpe_mesh_in.e
  []
  [to_si_units]
    type = TransformGenerator
    input = solid
    transform = SCALE
    vector_value = '${inch_to_m} ${inch_to_m} ${inch_to_m}'
    show_info = true
  []
[]

[Variables]
  [T]
    block = '${thermal_blocks}'
    family = LAGRANGE
    order = FIRST
    initial_condition = ${T_initial}
  []
[]

[Kernels]
  [heat_conduction]
    type = ADHeatConduction
    variable = T
    block = '${thermal_blocks}'
    thermal_conductivity = thermal_conductivity
  []
  [dt]
    type = ADHeatConductionTimeDerivative
    variable = T
    block = '${thermal_blocks}'
    density_name = density
    specific_heat = specific_heat
  []
[]

[Functions]
  [target_heat_flux_pulse]
    type = PiecewiseLinear
    x = '0 ${t_ramp_up_end} ${t_flat_end} ${t_ramp_down_end} ${t_end}'
    y = '0 ${q_target_peak} ${q_target_peak} 0 0'
  []
[]

[Materials]
  [tungsten_thermal_properties]
    type = ADTungstenThermalPropertiesMaterial
    block = '${tungsten}'
    temperature = T
    specific_heat = specific_heat_J_per_gK
    outputs = 'all'
  []
  [specific_heat_to_SI]
    type = ADParsedMaterial
    block = '${tungsten}'
    property_name = specific_heat
    material_property_names = specific_heat_J_per_gK
    expression = '1000.0 * specific_heat_J_per_gK'
  []
  [stainless_steel_thermal_properties]
    type = ADGenericConstantMaterial
    block = '${SS}'
    prop_names = 'thermal_conductivity density specific_heat'
    prop_values = '${stainless_steel_thermal_conductivity} ${stainless_steel_density} ${stainless_steel_specific_heat}'
  []
  [copper_thermal_properties]
    type = ADGenericConstantMaterial
    block = '${copper}'
    prop_names = 'thermal_conductivity density specific_heat'
    prop_values = '${copper_thermal_conductivity} ${copper_density} ${copper_specific_heat}'
  []
  [molybdenum_thermal_properties]
    type = ADGenericConstantMaterial
    block = '${molybdenum}'
    prop_names = 'thermal_conductivity density specific_heat'
    prop_values = '${molybdenum_thermal_conductivity} ${molybdenum_density} ${molybdenum_specific_heat}'
  []
[]

[BCs]
  [plasma_target_heat_flux]
    type = FunctorNeumannBC
    variable = T
    boundary = target_heat_flux
    functor = target_heat_flux_pulse
    flux_is_inward = true
  []
  [cooling_channel_convection]
    type = ADConvectiveHeatFluxBC
    variable = T
    boundary = '${cooling_boundaries}'
    T_infinity = ${T_coolant}
    heat_transfer_coefficient = ${cooling_htc}
  []
[]

[Postprocessors]
  [T_max]
    type = NodalExtremeValue
    variable = T
    value_type = max
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [T_min]
    type = NodalExtremeValue
    variable = T
    value_type = min
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [T_target_max]
    type = NodalExtremeValue
    variable = T
    boundary = target_heat_flux
    value_type = max
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [T_target_average]
    type = SideAverageValue
    variable = T
    boundary = target_heat_flux
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [T_cooling_average]
    type = SideAverageValue
    variable = T
    boundary = '${cooling_boundaries}'
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [applied_target_heat_flux]
    type = FunctionValuePostprocessor
    function = target_heat_flux_pulse
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [target_area]
    type = AreaPostprocessor
    boundary = target_heat_flux
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [applied_target_power]
    type = FunctionSideIntegral
    boundary = target_heat_flux
    function = target_heat_flux_pulse
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Executioner]
  type = Transient
  scheme = bdf2
  start_time = 0.0
  end_time = ${t_end}
  dt = ${thermal_dt}

  solve_type = NEWTON
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  nl_max_its = 20
  l_tol = 1e-6
  l_max_its = 200
[]

[Outputs]
  file_base = tpe_transient_heat_conduction
  exodus = true
  csv = true
  console = true
  time_step_interval = 5
  sync_times = '${t_ramp_up_end} ${t_flat_end} ${t_ramp_down_end} ${t_end}'
  print_linear_residuals = false
[]
