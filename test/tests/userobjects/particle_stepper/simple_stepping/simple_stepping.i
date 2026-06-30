[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 5
    ny = 5
    nz = 5
    xmax = 10
    ymax = 10
    zmax = 10
  []
  allow_renumbering = false
[]

[UserObjects]
  [stepper]
    type = TestSimpleStepper
  []

  [velocity_initializer]
    type = ConstantVelocityInitializer
    velocities = '0.5 0.1 4.1
                 -1.34 -1.63  6.3
                  0.5 0.9 10.8'
  []

  [particle_initializer]
    type = TestPlacedParticleInitializer
    start_points = '1.0 1.0 0.0
                    9.0 8.0 0.0
                    4.5 3.3 0.0'
    velocity_initializer = 'velocity_initializer'
  []

  [study]
    type = TestInitializedPICStudy
    stepper = stepper
    particle_initializers = particle_initializer
    use_custom_rayids = true
    particles_per_element = 1
    always_cache_traces = true
    data_on_cache_traces = true
    execute_on = 'TIMESTEP_BEGIN'
  []
[]

[RayBCs]
  [reflect]
    type = ReflectRayBC
    boundary = 'top bottom right left back front'
    study = study
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
  additional_ray_data_outputs = 'charge mass'
[]

[Executioner]
  type = Transient
  num_steps = 10
[]

[Problem]
  solve = false
[]

[Outputs]
  exodus = false
  [csv]
    type = CSV
    start_step = 1
    execute_on = 'TIMESTEP_END'
  []
[]
