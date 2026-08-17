# FNSFOBExpHeatIC

!syntax description /ICs/FNSFOBExpHeatIC

## Overview

`FNSFOBExpHeatIC` initializes a field using an analytic exponential-decay approximation to the
nuclear heating profile of the outboard blanket of the Fusion Nuclear Science Facility (FNSF):

\begin{equation}
q(d) = A \, e^{-k d},
\end{equation}

where $d$ is the depth measured from the last closed flux surface in meters, and $A$ and $k$ are
the scaling term and decay rate, defaulting to $A = 2.6464\times10^7$ and $k = 8.8698$. The depth
$d$ is computed from the quadrature point's cylindrical $(r, z)$ position using the
`find_xi_depth` method described on the [FNSFUtils.md] page (the poloidal-angle coordinate $\xi$
is unused by this exponential fit).

This closed-form approximation is a simplified alternative to the full gridded, OpenMC-derived
heating profile used by [FNSFHeatIC.md] and [FNSFHeatSource.md] [!citep](Franklin2025); it is
convenient for quick parameter studies that do not require the fidelity of the full gridded
neutronics data set, but is only intended to be used for the outboard blanket of the FNSF model.

## Example Input File Syntax

!listing test/tests/ics/FNSFOBExpHeatIC/FNSFOBExpHeatIC.i block=ICs

!syntax parameters /ICs/FNSFOBExpHeatIC

!syntax inputs /ICs/FNSFOBExpHeatIC

!syntax children /ICs/FNSFOBExpHeatIC
