# The stepper base file provides the basic objects that are required for both
# the LeapFrogStepper and the BorisSteper tests
!include ../stepper_base.i
# The rest of this file simply sets the type of stepper to be the LeapFrogStepper
# and tells the stepper which field variables to sample.

[UserObjects]
  [stepper]
    type = LeapFrogStepper
    field_components = 'Ex Ey Ez'
  []
[]
