# the number of computational particles to be put in each element
particles_per_element = 1
# the analytic solution for the charge density
# set by cli args for each case since it is needed by all
# tests but changes based on the dimension of the problem
charge_density = 1

[GlobalParams]
  particles_per_element = ${particles_per_element}
[]

[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 1
    nx = 1
    xmax = 1
    elem_type = EDGE2
  []
  allow_renumbering = false
[]

[Problem]
  solve = false
[]

[UserObjects]
  [velocity_initializer]
    type = ConstantVelocityInitializer
    velocities = '0 0 0'
  []
  [particle_initializer_1]
    type = PerElementParticleInitializer
    mass = 1
    charge = 1
    species = 'A'
    number_density = ${charge_density}
    velocity_initializer = 'velocity_initializer'
  []
  [particle_initializer_2]
    type = PerElementParticleInitializer
    mass = 2
    charge = 2
    species = 'B'
    number_density = ${charge_density}
    velocity_initializer = 'velocity_initializer'
  []
  [particle_initializer_3]
    type = PerElementParticleInitializer
    mass = 3
    charge = 3
    species = 'C'
    number_density = ${charge_density}
    velocity_initializer = 'velocity_initializer'
  []
  [particle_initializer_4]
    type = PerElementParticleInitializer
    mass = 4
    charge = 4
    species = 'D'
    number_density = ${charge_density}
    velocity_initializer = 'velocity_initializer'
  []
  [stepper]
    type = TestSimpleStepper
  []

  [study]
    type = TestInitializedPICStudy
    particle_initializers = 'particle_initializer_1 particle_initializer_2 particle_initializer_3 particle_initializer_4'
    stepper = stepper
    always_cache_traces = true
    data_on_cache_traces = true
    use_custom_rayids = true
    execute_on = TIMESTEP_BEGIN
  []
[]


[RayKernels]
  [null]
    type = NullRayKernel
  []
[]

[VectorPostprocessors/particle_data]
  type = TestParticleDataVectorPostprocessor
  study = study
  execute_on = 'TIMESTEP_END'
  additional_ray_data_outputs = 'charge mass species'
[]

[Executioner]
  type = Transient
  dt = 1
  num_steps = 1
[]

[Outputs]
  exodus = false
  [csv]
    type = CSV
    execute_on = TIMESTEP_END
  []
[]
