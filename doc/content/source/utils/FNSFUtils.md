# FNSFUtils

The `FNSF` namespace (declared in `include/utils/FNSFUtils.h` and defined in
[!file language=C++ title=FNSFUtils.C](src/utils/FNSFUtils.C)) provides shared geometric utility
functions used by every SALAMANDER object that projects gridded neutronics data onto a mesh
of the outboard blanket of the Fusion Nuclear Science Facility (FNSF). The underlying blanket
geometry and a nuclear heating profile projected onto it were described and demonstrated in
[!citep](Kong2022); [!citep](Franklin2025) generalized this into the grid-based $(\xi,
\text{depth})$ projection object documented here and extended it to also project tritium
generation rates.

The outboard blanket's plasma-facing boundary is described by a Miller-equilibrium torus shape
with major radius $R_0$, minor radius $a$, triangularity $\tau$, and elongation $k$. `FNSF::torus`
and `FNSF::orthogonal` parametrize this boundary and its outward normal direction, respectively,
as a function of the poloidal-angle parameter $\xi$.

`FNSF::find_xi_depth(r, z)` converts a point's cylindrical $(r, z)$ mesh coordinates into
$(\xi, \text{depth})$ coordinates, where $\xi$ locates the point along the poloidal angle of the
plasma boundary and `depth` is the perpendicular distance from the last closed flux surface. This
is the coordinate transform used by objects such as [FNSFHeatSource.md], [FNSFTritiumSource.md],
[FNSFSourceAux.md], [FNSFHeatIC.md], [FNSFOBExpHeatIC.md], and [FNSFOBExpHeatSource.md] to look
up the correct entry of a gridded or analytic neutronics data set for a given mesh location.
