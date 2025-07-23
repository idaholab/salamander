[Problem]
  solve = false
[]

[UserObjects]
  [stepper]
    type = TestSimpleStepper
  []

  [initializer]
    type = TestPlacedParticleInitializer
    charge = 1
    weight = 1
  []

  [study]
    type = TestInitializedPICStudy
    stepper = stepper
    initializer = initializer
    use_custom_rayids = false
    always_cache_traces = true
    data_on_cache_traces = true
    execute_on = 'TIMESTEP_BEGIN'
    ray_kernel_coverage_check = false
  []
[]

[VectorPostprocessors]
  [particle_data]
    type = TestParticleDataVectorPostprocessor
    study = study
    execute_on = TIMESTEP_END
  []
[]

[RayBCs/reflect]
  type = ReflectParticleBC
[]

[Executioner]
  type = Transient
  num_steps = 2
[]

[Outputs]
  csv = true
  execute_on = 'TIMESTEP_END'
[]
