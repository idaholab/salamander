# SimpleStepper

!syntax description /UserObjects/SimpleStepper

The SimpleStepper is intended to be used when simulating flows where the particles in the system are not subject to any external forces. One example of this is neutral particle simulations.
This object sets the particles to trace along its current direction with the maximum distance set by the current velocity and time step.

# Example Input Syntax

!listing test/tests/userobjects/particle_stepper/simple_stepping/simple_stepping.i block=UserObjects

!syntax parameters /UserObjects/SimpleStepper

!syntax inputs /UserObjects/SimpleStepper

!syntax children /UserObjects/SimpleStepper

