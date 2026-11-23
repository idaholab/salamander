# FVFunctionalNormalDirichletBC

!syntax description /FVBCs/FVFunctionalNormalDirichletBC

## Overview

`FVFunctionalNormalDirichletBC` imposes the boundary value

\begin{equation}
u = -g(t, \vec{x}) \, \hat{n}_d,
\end{equation}

where $g$ is a (possibly) time- and space-dependent `Function` given by the
[!param](/FVBCs/FVFunctionalNormalDirichletBC/function) parameter,
$\hat{n}_d$ is the $d$-th Cartesian component of the face outward normal vector, and $d$ is
selected by the [!param](/FVBCs/FVFunctionalNormalDirichletBC/direction) parameter (`x`, `y`, or
`z`). This lets a single scalar function
prescribe one Cartesian component of a vector quantity's boundary value, projected onto the face
normal, which is useful for boundary conditions such as a specified inlet velocity or pressure on
a finite-volume porous-media flow model.

## Example Input File Syntax

The following applies `FVFunctionalNormalDirichletBC` to set a constant pressure on the `right`
boundary of a 1D finite-volume porous-media flow model:

!listing test/tests/fvbcs/FVFunctionNormalDirichlet/FVFunctionNormalDirichlet.i block=FVBCs

!syntax parameters /FVBCs/FVFunctionalNormalDirichletBC

!syntax inputs /FVBCs/FVFunctionalNormalDirichletBC

!syntax children /FVBCs/FVFunctionalNormalDirichletBC
