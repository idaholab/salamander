!include leapfrog_base.i

[Mesh/gmg]
  nx = 120
  ny = 20
  xmax = 120
  ymax = 20
[]

[Functions]
  [E_x_ic]
    expression = '5e-7'
  []
  [E_y_ic]
    expression = '0'
  []
  [E_z_ic]
    expression = '0'
  []
[]

[UserObjects]
  [velocity_initializer]
    velocities = '0 0 0'
  []
  [particle_initializer]
    start_points = '0 10.5 0'
    mass = 9.1093837015e-31
    charge = 1.602176634e-19
  []
[]

[RayKernels]
  [null]
    type = NullRayKernel
  []
[]

[Executioner]
  dt = 1e-4
[]
