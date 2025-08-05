[Problem]
  solve = false
  kernel_coverage_check=false
[]

[Mesh/gmg]
  type = GeneratedMeshGenerator
  dim = 2
[]

[AuxVariables]
  [Ex]
  []
  [Ey]
  []
  [Ez]
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
[]

[UserObjects]
  [velocity_initializer]
    type = ConstantVelocityInitializer
  []

  [stepper]
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
  [csv]
    type = CSV
    execute_on = 'FINAL'
  []
[]
