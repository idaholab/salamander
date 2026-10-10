# FNSFHeatSource

!syntax description /Kernels/FNSFHeatSource

## Overview

`FNSFHeatSource` applies a volumetric nuclear heating source to a heat conduction model of the
outboard blanket of the Fusion Nuclear Science Facility (FNSF) [!citep](Franklin2025).
Neutronics-derived heating data are pre-computed on a grid of OpenMC statepoint cells and passed
in through the [!param](/Kernels/FNSFHeatSource/heat) parameter; this kernel maps each quadrature
point's physical location to a cell on that grid and applies the corresponding value as a
[Kernel.md] residual contribution:

\begin{equation}
R_i = -\int_{\Omega_e} q(\xi, d) \, \psi_i \, d\Omega,
\end{equation}

where $\psi_i$ is the test function and $q(\xi, d)$ is the heating rate for the grid cell located
at poloidal-angle parameter $\xi$ and depth $d$ from the last closed flux surface. The $(\xi, d)$
coordinates are computed from the quadrature point's cylindrical $(r, z)$ position using the
`find_xi_depth` method described on the [FNSFUtils.md] page. The resulting $(\xi, d)$ pair is
then located on the grids given by [!param](/Kernels/FNSFHeatSource/inner_xi),
[!param](/Kernels/FNSFHeatSource/outer_xi), and [!param](/Kernels/FNSFHeatSource/depth) (which
describe the inner first-wall edge, outer back-wall edge, and radial depth divisions of the
neutronics grid, respectively) to select the correct entry of
[!param](/Kernels/FNSFHeatSource/heat). This grid-projection approach is detailed in
[!citep](Franklin2025) and is analogous to the coupling strategy used between neutronics,
thermal-hydraulics, and heat transfer described in [!citep](Kong2022).

`FNSFHeatSource` derives from the internal `FNSFSource` base class, which is shared with
[FNSFTritiumSource.md] (tritium generation) since both simply differ in the physical quantity
being projected onto the mesh.

## Example Input File Syntax

The following example applies `FNSFHeatSource` to a `temp` variable on the FNSF blanket mesh:

!listing test/tests/kernels/FNSFHeatSource/FNSFHeatSource.i block=Kernels

This kernel's projection method is also verified against a manufactured solution; see
[fnsf_heat_source_mms.md] for the convergence study.

!syntax parameters /Kernels/FNSFHeatSource

!syntax inputs /Kernels/FNSFHeatSource

!syntax children /Kernels/FNSFHeatSource
