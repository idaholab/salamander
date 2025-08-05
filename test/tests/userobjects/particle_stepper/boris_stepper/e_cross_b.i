!include boris_stepper_base.i

[Mesh/gmg]
  nx = 20
  ny = 20
  xmin = -2
  xmax = 30
  ymin = -20
  ymax = 20
[]

[Functions]
  [E_x_ic]
    expression = '0.05'
  []
  [E_y_ic]
    expression = '0'
  []
  [E_z_ic]
    expression = '0'
  []
  [B_x_ic]
    expression = '0'
  []
  [B_y_ic]
    expression = '0'
  []
  [B_z_ic]
    expression = '1'
  []
[]

[UserObjects]
  [velocity_initializer]
    velocities = '1 0 0'
  []

  [particle_initializer]
    start_points = '0 1 0'
    mass = 1
    weight = 1
    charge = 1
  []
[]

[Executioner]
  dt = 1e-1
[]
