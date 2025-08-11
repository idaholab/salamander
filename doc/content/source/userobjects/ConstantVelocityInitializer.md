# ConstantVelocityInitializer

!syntax description /UserObjects/ConstantVelocityInitializer

## Overview

This velocity initializer provides particles with velocities from the provided list.
When more velocities are requested from this initializer than are provided as input, the list of velocities will be repeated until the total number of velocities requested have been provided.

## Example Input File Syntax

!listing test/tests/userobjects/particle_initializer/per_element/elements/initializer_base.i block=UserObjects/velocity_initializer

!syntax parameters /UserObjects/ConstantVelocityInitializer

!syntax inputs /UserObjects/ConstantVelocityInitializer

!syntax children /UserObjects/ConstantVelocityInitializer
