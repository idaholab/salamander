[Problem]
 solve = false
 kernel_coverage_check = false
[]

[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 1
    nx = 1
    xmax = 1
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

  [initializer_1]
    type = TestPlacedParticleInitializer
    velocity_initializer = 'velocity_initializer'
    start_points = '0 0 0'
    mass = 1
    charge = 1
    species = 'A'
  []

  [initializer_2]
    type = TestPlacedParticleInitializer
    velocity_initializer = 'velocity_initializer'
    start_points = '0 0 0'
    mass = 1
    charge = 1
    species = 'A'
  []

  [study]
    type = TestInitializedPICStudy
    particle_initializers = 'initializer_1 initializer_2'
    stepper = stepper
    use_custom_rayids = false
    always_cache_traces = true
    data_on_cache_traces = true
    execute_on = TIMESTEP_BEGIN
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

