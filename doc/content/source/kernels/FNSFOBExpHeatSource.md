# FNSFOBExpHeatSource

!syntax description /Kernels/FNSFOBExpHeatSource

## Overview

`FNSFOBExpHeatSource` applies a volumetric heat source using the same analytic exponential-decay
approximation to the nuclear heating profile of the outboard blanket of the Fusion Nuclear
Science Facility (FNSF) as [FNSFOBExpHeatIC.md]:

\begin{equation}
R_i = -\int_{\Omega_e} \left( A \, e^{-k d} \right) \psi_i \, d\Omega,
\end{equation}

where $\psi_i$ is the test function, $d$ is the depth measured from the last closed flux surface
in meters (computed via `find_xi_depth`, see [FNSFUtils.md]), and $A$ and $k$ are the scaling
term and decay rate, defaulting to $A = 2.6464\times10^7$ and $k = 8.8698$.

Unlike [FNSFOBExpHeatIC.md], which uses this exponential form only to set an initial value,
`FNSFOBExpHeatSource` contributes it as a `Kernel` residual on every solve, analogous to how
[FNSFHeatSource.md] contributes the full gridded neutronics heating profile. This closed-form
approximation is only intended to be used for the outboard blanket of the FNSF model.

## Example Input File Syntax

!listing test/tests/kernels/FNSFOBExpHeatSource/FNSFOBExpHeatSource.i block=Kernels

!syntax parameters /Kernels/FNSFOBExpHeatSource

!syntax inputs /Kernels/FNSFOBExpHeatSource

!syntax children /Kernels/FNSFOBExpHeatSource
