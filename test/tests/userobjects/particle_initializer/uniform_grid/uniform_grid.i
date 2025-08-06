[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 1
    nx = 4
  []
  allow_renumbering = false
[]

[Problem]
  solve = false
  kernel_coverage_check = false
[]

[UserObjects]
  [velocity_initializer]
    type = ConstantVelocityInitializer
    velocities = '0 0 0'
  []
  [stepper]
    type = TestSimpleStepper
  []

  [particle_initializer]
    type = UniformGridParticleInitializer
    mass = 1
    charge = 1
    total_particles = 4
    number_density = 1
    velocity_initializer = 'velocity_initializer'
  []

  [study]
    type = TestInitializedPICStudy
    stepper = stepper
    particle_initializer = particle_initializer
    particles_per_element = 1
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
  num_steps = 1
[]

[Outputs]
  [rays]
    type = RayTracingExodus
    study = study
    output_data_names = 'weight'
    execute_on = 'TIMESTEP_END'
  []
[]
