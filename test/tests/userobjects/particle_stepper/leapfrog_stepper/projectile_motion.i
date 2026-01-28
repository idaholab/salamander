# This includes the stepper_base.i file and tells the simulation to use the Leapfrog stepper.
!include leapfrog_base.i

[Mesh/gmg]
  nx = 25
  ny = 7
  xmax = 22
  ymax = 7
[]

[Functions]
  [E_x_ic]
    expression = '0'
  []
  [E_y_ic]
    expression = '-9.81'
  []
  [E_z_ic]
    expression = '0'
  []
[]

[UserObjects]
  [velocity_initializer]
    velocities = '10 10 0'
  []

  [particle_initializer]
    start_points = '0 0 0'
    charge = 1
    weight = 1
  []
[]

[RayKernels]
  [null]
    type = NullRayKernel
  []
[]

[Executioner]
  dt = 1e-2
[]
