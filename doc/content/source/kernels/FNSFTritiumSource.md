# FNSFTritiumSource

!syntax description /Kernels/FNSFTritiumSource

## Overview

`FNSFTritiumSource` applies a volumetric tritium generation source to a tritium transport model
of the outboard blanket of the Fusion Nuclear Science Facility (FNSF) [!citep](Franklin2025).
Neutronics-derived tritium generation rates are pre-computed on a grid of OpenMC statepoint cells
and passed in through the [!param](/Kernels/FNSFTritiumSource/tritium) parameter; this kernel maps
each quadrature point's physical location to a cell on that grid and applies the corresponding
value as a [Kernel.md] residual contribution, using the same $(\xi, d)$ projection (via
`find_xi_depth`, see [FNSFUtils.md]) and grid parameters
([!param](/Kernels/FNSFTritiumSource/inner_xi), [!param](/Kernels/FNSFTritiumSource/outer_xi),
[!param](/Kernels/FNSFTritiumSource/depth)) as [FNSFHeatSource.md].

In a SALAMANDER-TMAP8 coupled simulation, `FNSFTritiumSource` is added to the scalar transport
equation solved by a TMAP8 sub-application, providing the neutron-generated tritium source term
that TMAP8 then transports and permeates through the blanket structure
[!citep](Simon2022) [!citep](Simon2025).

`FNSFTritiumSource` derives from the same internal `FNSFSource` base class as
[FNSFHeatSource.md]; the two kernels differ only in the physical quantity
([!param](/Kernels/FNSFTritiumSource/tritium) vs.
[!param](/Kernels/FNSFHeatSource/heat)) being projected onto the mesh.

## Example Input File Syntax

!listing test/tests/kernels/FNSFTritiumSource/FNSFTritiumSource.i block=Kernels

!syntax parameters /Kernels/FNSFTritiumSource

!syntax inputs /Kernels/FNSFTritiumSource

!syntax children /Kernels/FNSFTritiumSource
