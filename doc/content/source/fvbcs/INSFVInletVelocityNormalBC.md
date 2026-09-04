# INSFVInletVelocityNormalBC

!syntax description /FVBCs/INSFVInletVelocityNormalBC

## Overview

`INSFVInletVelocityNormalBC` derives from both [FVFunctionalNormalDirichletBC.md] and
`INSFVFlowBC`, and additionally requires that [!param](/FVBCs/INSFVInletVelocityNormalBC/variable)
be of type [INSFVVelocityVariable.md] (an error is raised otherwise). It inherits
[FVFunctionalNormalDirichletBC.md]'s boundary value $-g(t, \vec{x}) \, \hat{n}_d$, where $g$ is the
[!param](/FVBCs/FVFunctionalNormalDirichletBC/function) parameter and $\hat{n}_d$ is the
[!param](/FVBCs/FVFunctionalNormalDirichletBC/direction) component of the face outward normal,
unchanged; combining this with the [INSFVVelocityVariable.md] restriction makes it suitable for
use as an inlet boundary condition for one Cartesian component of the velocity in an
incompressible/weakly-compressible finite-volume Navier-Stokes (INSFV) simulation.

## Example Input File Syntax

The following prescribes a uniform inlet superficial velocity on the `right` and `left`
boundaries of a 1D finite-volume porous-media flow model, alongside
[FVFunctionalNormalDirichletBC.md] for the corresponding pressure boundary conditions:

!listing test/tests/fvbcs/INSFVinletVelocityNormalBC/INFVInletVelocityNormalBC.i block=FVBCs

!syntax parameters /FVBCs/INSFVInletVelocityNormalBC

!syntax inputs /FVBCs/INSFVInletVelocityNormalBC

!syntax children /FVBCs/INSFVInletVelocityNormalBC
