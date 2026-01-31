# The stepper base file provides the basic objects that are required for both
# the LeapFrogStepper and the BorisSteper tests
# this includes the AuxVariabels for the electric fields and UserObjects
!include ../stepper_base.i

[AuxVariables]
  [Bx]
  []
  [By]
  []
  [Bz]
  []
[]

[Functions]
  [B_x_ic]
    type = ParsedFunction
  []
  [B_y_ic]
    type = ParsedFunction
  []
  [B_z_ic]
    type = ParsedFunction
  []
[]

[ICs]
  [Bx_ic]
    type = FunctionIC
    variable = Bx
    function = B_x_ic
  []
  [By_ic]
    type = FunctionIC
    variable = By
    function = B_y_ic
  []
  [Bz_ic]
    type = FunctionIC
    variable = Bz
    function = B_z_ic
  []
[]

[UserObjects]
  [stepper]
    type = BorisStepper
    efield_components = 'Ex Ey Ez'
    bfield_components = 'Bx By Bz'
  []
[]
