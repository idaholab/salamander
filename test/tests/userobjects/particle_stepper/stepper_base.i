# This file serves as the common base case for all of the particle stepping test cases.
# It provides the bare minimum required to test a particles motion.
# It also provides the required output capabilities to test a single particles motion.
# The output method has been designed to properly output all particle data on time steps
# when a single particle is being used and the mesh is divided across several processors.
# Files that build off of this one will need to provide the following
# - The actual expression for the field initial conditions.
# - The type of stepper that will be tested
# - The initial conditions for the particle that will be utilized.
# Since this is only testing the particle stepper we do not actually need to solve any
# field equations and the we are not going to be using any kernels.
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
