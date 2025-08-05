[Problem]
  solve = false
  kernel_coverage_check=false
[]

[Mesh/gmg]
  type = GeneratedMeshGenerator
  dim = 2
  nx = 20
  ny = 20
  xmin = -2
  xmax = 30
  ymin = -20
  ymax = 20
[]

[Variables]
  [Ex]
  []
  [Ey]
  []
  [Ez]
  []
  [Bx]
  []
  [By]
  []
  [Bz]
  []
[]

[Functions]
  [E_x_ic]
    type = ParsedFunction
    expression = '0.05'
  []
  [E_y_ic]
    type = ParsedFunction
    expression = '0'
  []
  [E_z_ic]
    type = ParsedFunction
    expression = '0'
  []
  [B_x_ic]
    type = ParsedFunction
    expression = '0'
  []
  [B_y_ic]
    type = ParsedFunction
    expression = '0'
  []
  [B_z_ic]
    type = ParsedFunction
    expression = '1'
  []
[]

[ICs]
  [Ex_ic]
    type = FunctionIC
    variable = Ex
    function = E_x_ic
  []
  [Ey_ic]
    type = FunctionIC
    variable = Ey
    function = E_y_ic
  []
  [Ez_ic]
    type = FunctionIC
    variable = Ez
    function = E_z_ic
  []
  [Bx_ic]
    type = FunctionIC
    variable = Bx
    function = B_x_ic
  []
  [By_ic]
    type = FunctionIC
    variable = By
    function = B_y_ic
  []
  [Bz_ic]
    type = FunctionIC
    variable = Bz
    function = B_z_ic
  []
[]

[UserObjects]
  [stepper]
    type = BorisStepper
    efield_components = 'Ex Ey Ez'
    bfield_components = 'Bx By Bz'
  []

  [velocity_initializer]
    type = ConstantVelocityInitializer
    velocities = '1 0 0'
  []
  [particle_initializer]
    type = TestPlacedParticleInitializer
    start_points = '0 1 0'
    velocity_initializer = 'velocity_initializer'
    mass = 1
    weight = 1
    charge = 1
  []

  [study]
    type = TestInitializedPICStudy
    stepper = stepper
    particle_initializer = particle_initializer
    use_custom_rayids = false
    always_cache_traces = true
    data_on_cache_traces = true
    execute_on = 'TIMESTEP_BEGIN'
    ray_kernel_coverage_check = false
  []
[]

[Executioner]
  type = Transient
  dt = 1e-1
  num_steps = 10
[]

[VectorPostprocessors/particle_data]
  type = TestSingleParticleDataVectorPostprocessor
  study = study
  additional_ray_data_outputs = 'charge mass'
  execute_on = 'TIMESTEP_END'
[]

[Outputs]
  exodus = true
  csv = true
  execute_on = 'FINAL'
[]
