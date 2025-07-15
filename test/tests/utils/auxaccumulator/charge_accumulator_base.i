
[Problem]
  solve = false
[]

[AuxVariables]
  [F]
  []
[]

[UserObjects]
  [stepper]
    type = TestSimpleStepper
  []

  [velocity_initializer]
    type = ConstantVelocityInitializer
    velocities = '0 0 0'
  []

  [initializer]
    type = TestPlacedParticleInitializer
    start_velocities = '0 0 0'
    velocity_initializer = 'velocity_initializer'
  []

  [study]
    type = TestChargeAccumulator
    variable = F
    stepper = stepper
    initializer = initializer
    use_custom_rayids = false
    always_cache_traces = true
    data_on_cache_traces = true
    execute_on = 'TIMESTEP_BEGIN'
  []
[]

[RayKernels]
  [null]
    type = NullRayKernel
  []
[]

[Executioner]
  type = Transient
  num_steps = 2
[]

[Outputs]
  exodus = true
[]
