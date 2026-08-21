# FNSFSourceAux

!syntax description /AuxKernels/FNSFSourceAux

## Overview

`FNSFSourceAux` writes a projected neutronics field (e.g. heating rate or tritium generation
rate) to an [AuxVariable.md], for visualization and post-processing of a fusion blanket simulation
of the Fusion Nuclear Science Facility (FNSF) [!citep](Franklin2025). It uses the same
$(\xi, d)$ grid-projection method as [FNSFHeatSource.md] and [FNSFTritiumSource.md] (via
`find_xi_depth`, see [FNSFUtils.md]), but simply reports the looked-up value rather than
contributing a residual to a [Kernel.md]-driven physics solve. The required
[!param](/AuxKernels/FNSFSourceAux/source) parameter supplies the gridded data (analogous to
[!param](/Kernels/FNSFHeatSource/heat)/[!param](/Kernels/FNSFTritiumSource/tritium) in the
corresponding [Kernel.md] objects), alongside the shared
[!param](/AuxKernels/FNSFSourceAux/inner_xi), [!param](/AuxKernels/FNSFSourceAux/outer_xi), and
[!param](/AuxKernels/FNSFSourceAux/depth) grid parameters.

This is commonly used to couple a projected field into another object via [CoupledForce.md] or to
export the raw projected neutronics data for inspection, without needing a separate [Kernel.md].

## Example Input File Syntax

!listing test/tests/auxkernels/FNSFSourceAux.i block=AuxKernels

!syntax parameters /AuxKernels/FNSFSourceAux

!syntax inputs /AuxKernels/FNSFSourceAux

!syntax children /AuxKernels/FNSFSourceAux
