# FNSFHeatIC

!syntax description /ICs/FNSFHeatIC

## Overview

`FNSFHeatIC` initializes a field directly from a gridded neutronics heating data set for the
outboard blanket of the Fusion Nuclear Science Facility (FNSF) [!citep](Franklin2025), using the
same $(\xi, d)$ grid-projection method as [FNSFHeatSource.md] (via `find_xi_depth`, see
[FNSFUtils.md]) and the same grid parameters (`inner_xi`, `outer_xi`, `depth`, `heat`). Unlike
`FNSFHeatSource`, which contributes this data as a `Kernel` residual on every solve, `FNSFHeatIC`
simply sets the initial value of a field to the projected heating rate, which is useful for
starting a transient simulation from a physically-motivated initial temperature distribution
before other physics (e.g. conduction, convection) evolve the field.

## Example Input File Syntax

!listing test/tests/ics/FNSFHeatIC/FNSFHeatIC.i block=ICs

!syntax parameters /ICs/FNSFHeatIC

!syntax inputs /ICs/FNSFHeatIC

!syntax children /ICs/FNSFHeatIC
