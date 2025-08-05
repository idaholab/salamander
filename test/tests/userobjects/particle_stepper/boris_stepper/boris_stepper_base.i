[Problem]
  solve = false
  kernel_coverage_check=false
[]

[Mesh/gmg]
  type = GeneratedMeshGenerator
  dim = 2
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
  []
  [E_y_ic]
    type = ParsedFunction
  []
  [E_z_ic]
    type = ParsedFunction
  []
  [B_x_ic]
    type = ParsedFunction
  []
  [B_y_ic]
    type = ParsedFunction
  []
  [B_z_ic]
    type = ParsedFunction
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
  [velocity_initializer]
    type = ConstantVelocityInitializer
  []

  [stepper]
    type = BorisStepper
    efield_components = 'Ex Ey Ez'
    bfield_components = 'Bx By Bz'
  []

  [particle_initializer]
    type = TestPlacedParticleInitializer
    velocity_initializer = 'velocity_initializer'
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


[VectorPostprocessors/particle_data]
  type = TestSingleParticleDataVectorPostprocessor
  study = study
  execute_on = 'TIMESTEP_END'
  additional_ray_data_outputs = 'charge mass'
[]


[Executioner]
  type = Transient
  num_steps = 10
[]

[Outputs]
  exodus = true
  csv = true
  execute_on = 'FINAL'
[]
