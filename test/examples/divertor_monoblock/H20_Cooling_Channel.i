#Operating Conditions
T_in = 423 # K  "Thermal-hydraulic modelling and analysis of ITER tungsten divertor monoblock"
p_out = 5e6 # Pa "Thermal-hydraulic modelling and analysis of ITER tungsten divertor monoblock"
v_in = 16 #m/s "Thermal-hydraulic modelling and analysis of ITER tungsten divertor monoblock"

#Channel Geometry
radius = ${units 6 mm -> m}
wetted_perimeter = ${fparse 2 * 3.14159 * radius} # perimeter
area = ${fparse 3.14159 * radius * radius} # area
D_h = ${fparse (4*area)/wetted_perimeter}

#Fluid Properties (Water at 5Mpa and 423K https://www.peacesoftware.de/einigewerte/wasser_dampf_e.html)
rho = 919.69
mu =  0.00018379
k = 0.6851
cp = 4.29547e3

num_axial_elements = 20

[Mesh]
  [circle]
    type = AnnularMeshGenerator
    nt = 20
    nr = 20
    rmax = 0.006
    rmin = 0
    dmin = 90
    dmax = 270
    growth_r = 0.9
  []
  [extrude]
    type = AdvancedExtruderGenerator
    input = circle
    heights = '0.006'
    direction = '0 0 1'
    num_layers = '${num_axial_elements}'
    bottom_boundary = 'inlet'
    top_boundary = 'outlet'
  []
  construct_side_list_from_node_list=true
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = vel_x
    v = vel_y
    w = vel_z
    pressure = pressure
  []
[]

[Variables]
  [vel_x]
    type = INSFVVelocityVariable
  []
  [vel_y]
    type = INSFVVelocityVariable
  []
  [vel_z]
    type = INSFVVelocityVariable
    initial_condition = ${v_in}
  []
  [pressure]
    type = INSFVPressureVariable
  []
  [T_fluid]
    type = INSFVEnergyVariable
    initial_condition = ${T_in}
  []
[]

[AuxVariables]
  [power_density]
    type = MooseVariableFVReal
    initial_condition = 1e4
  []
  [Hw_ak]
    type = MooseVariableFVReal
    initial_condition = 100
  []
  [T_wall]
    type = MooseVariableFVReal
    initial_condition = ${T_in}
  []
  [speed_ak]
    type = MooseVariableFVReal
  []
[]

[AuxKernels]
  [Hw_ak]
    type = FunctorAux
    variable = Hw_ak
    functor = 'Hw'
  []
  [speed_ak]
    type = FunctorAux
    variable = speed_ak
    functor = speed
  []
[]

[FluidProperties]
  [simple]
    type = SimpleFluidProperties
    viscosity = ${mu}
    density0 = ${rho}
    cp = ${cp}
    thermal_conductivity = ${k}
  []
[]

[FunctorMaterials]
  [ad_converter]
    type = FunctorADConverter
    ad_props_in = 'pressure'
    reg_props_out = 'nonad_pressure'
  []
  [fluid_props_avgd]
    type = NonADGeneralFunctorFluidProps
    T_fluid = T_uo
    characteristic_length = ${radius}
    fp = simple
    porosity = 1
    pressure = nonad_pressure
    speed = speed_uo
  []
  [Hw_avgd]
    Hw = Hw
    type = DittusBoelterFunctorMaterial
    D_h = ${D_h}
    k = ${k}
    T_fluid = T_uo
    T_wall = T_wall
    Pr = Pr
    Re = Re
  []
  [q]
    type = ParsedFunctorMaterial
    expression = 'Hw * (T_wall - T_uo)'
    property_name = 'q'
    functor_names = 'Hw T_uo T_wall'
  []
[]

[UserObjects]
  [T_uo]
    type = LayeredAverage
    direction = z
    variable = T_fluid
    num_layers = ${num_axial_elements}
  []
  [speed_uo]
    type = LayeredAverage
    direction = z
    variable = speed_ak
    num_layers = ${num_axial_elements}
  []
  [Hw_uo]
    type = LayeredAverage
    direction = z
    variable = Hw_ak
    num_layers = ${num_axial_elements}
  []
[]

[Physics]
  [NavierStokes]
    [Flow]
      [flow]
        compressibility = 'incompressible'

        velocity_variable = 'vel_x vel_y vel_z'

        density = 'rho'
        dynamic_viscosity = '${mu}'

        initial_velocity = '0 0 ${v_in}'
        initial_pressure = '${p_out}'

        inlet_boundaries = 'inlet'
        momentum_inlet_types = 'fixed-velocity'
        momentum_inlet_functors = '0 0 ${v_in}'

        wall_boundaries = '1 2 3'
        momentum_wall_types = 'noslip symmetry symmetry'

        outlet_boundaries = 'outlet'
        momentum_outlet_types = 'fixed-pressure'
        pressure_functors = '${p_out}'

        mass_advection_interpolation = 'upwind'
        momentum_advection_interpolation = 'upwind'
      []
    []
    [FluidHeatTransfer]
      [energy]
        coupled_flow_physics = flow

        fluid_temperature_variable = 'T_fluid'

        thermal_conductivity = ${k}
        specific_heat = 'cp'

        initial_temperature = '${T_in}'

        energy_inlet_types = 'fixed-temperature'
        energy_inlet_functors = '${T_in}'
        energy_wall_types = 'heatflux heatflux heatflux'
        energy_wall_functors = 'q q q'
      []
    []
    [Turbulence]
      [turbulence]
        coupled_flow_physics = flow
        fluid_heat_transfer_physics = energy
      []
    []
  []
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  petsc_options = '-snes_converged_reason -ksp_converged_reason'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  line_search = 'none'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-6
  nl_max_its = 10
  end_time = 15
  dtmax = 2e-2
  dtmin = 1e-5
  scheme = 'bdf2'
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-3
    optimal_iterations = 6
    growth_factor = 1.5
  []
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
[]
