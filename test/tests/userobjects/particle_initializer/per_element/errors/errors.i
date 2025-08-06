[Problem]
  solve = false
[]

[GlobalParams]
  particles_per_element = 10
[]

[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 1
  []
[]

[UserObjects]
  [velocity_initializer]
    type = ConstantVelocityInitializer
    velocities = '0 0 0'
  []

  [particle_initializer]
    type = PerElementParticleInitializer
    mass = 1
    charge = 1
    number_density = 2
    velocity_initializer = 'velocity_initializer'
  []

  [stepper]
    type = TestSimpleStepper
  []

  [study]
    type = TestInitializedPICStudy
    particle_initializer = particle_initializer
    stepper = stepper
    always_cache_traces = true
    data_on_cache_traces = true
    execute_on=TIMESTEP_BEGIN
  []

  [potential_accumulator]
    type = ChargeDensityAccumulator
    study = study
    variable = phi
    extra_vector_tags = dump_value
  []

  [density_accumulator]
    type = ChargeDensityAccumulator
    study = study
    variable = n
  []
[]


[RayKernels]
  [null]
    type = NullRayKernel
  []
[]

[Executioner]
  type = Steady
[]
