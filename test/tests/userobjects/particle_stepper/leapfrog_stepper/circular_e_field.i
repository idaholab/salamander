# This includes the stepper_base.i file and the tells the simulation to use the leapfrog stepper
!include leapfrog_base.i

[Mesh/gmg]
  nx = 5
  ny = 5
  xmin = -2
  xmax = 2
  ymin = -2
  ymax = 2
[]

[AuxKernels]
  [E_x]
    type = FunctionAux
    variable = Ex
    function = E_x_ic
  []
  [E_y]
    type = FunctionAux
    variable = Ey
    function = E_y_ic
  []
  [E_z]
    type = FunctionAux
    variable = Ez
    function = E_z_ic
  []
[]

[Functions]
  [E_x_ic]
    expression = '-sin(t)'
  []
  [E_y_ic]
    expression = '-cos(t)'
  []
  [E_z_ic]
    expression = '0'
  []
[]

[UserObjects]
  [velocity_initializer]
    velocities = '1 0 0'
  []

  [particle_initializer]
    start_points = '0 1 0'
    mass = 1
    charge = 1
  []
[]


[Executioner]
  dt = 1e-1
[]
