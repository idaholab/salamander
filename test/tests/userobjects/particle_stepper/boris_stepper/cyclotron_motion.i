# This includes the stepper_base.i file, adds the AuxVariables for the magnetic field, 
# and tells the simulation to use the BorisStepper
!include boris_base.i

[Mesh/gmg]
  nx = 5
  ny = 5
  xmin = -2
  xmax = 2
  ymin = -2
  ymax = 2
[]

[Functions]
  [E_x_ic]
    expression = '0'
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
