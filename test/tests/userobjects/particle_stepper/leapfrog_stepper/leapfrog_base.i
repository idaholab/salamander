# The stepper base file provides the basic objects that are required for both 
# the LeapFrogStepper and the BorisSteper tests
# this includes the AuxVariabels for the electric fields and UserObjects
!include ../stepper_base.i

[UserObjects]
  [stepper]
    type = LeapFrogStepper
    field_components = 'Ex Ey Ez'
  []
[]
