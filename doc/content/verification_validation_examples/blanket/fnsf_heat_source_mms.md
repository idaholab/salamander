# Method of Manufactured Solutions Verification of FNSFHeatSource

This case verifies the grid-projection heat source implemented by [FNSFHeatSource.md] using the
method of manufactured solutions (MMS), reproducing the convergence study of
[!citep](Franklin2025).

## Problem description

The manufactured temperature solution is

\begin{equation}
T(x, y, z) = \sin(\pi x) \sin(\pi z) \cos(\pi y),
\end{equation}

imposed on all boundaries of a unit cube mesh via a `FunctionDirichletBC`. The steady-state heat
conduction equation solved is

\begin{equation}
-\nabla \cdot (k \nabla T) = q + f,
\end{equation}

where $k = 1$ is the (constant) thermal conductivity, $q$ is the volumetric heating contributed by
[FNSFHeatSource.md], and $f$ is an additional forcing function needed to make $T$ above an exact
solution. `FNSFHeatSource` is configured with a single-cell $(\xi, \text{depth})$ grid and a
uniform `heat` value of 1 everywhere on it, so it contributes a constant unit source, $q = 1$.
Substituting the manufactured solution into the governing equation and solving for the remaining
forcing term gives

\begin{equation}
f(x, y, z) = 3\pi^2 \sin(\pi x) \sin(\pi z) \cos(\pi y) - 1,
\end{equation}

which is applied as a `BodyForce` alongside `FNSFHeatSource`; together they reproduce the exact
right-hand side needed for $T$ to be an exact solution of the discretized problem.

!listing test/tests/kernels/FNSFHeatSource/mms.i

## Results

Following [!citep](Franklin2025), the discretization error is measured with an `ElementL2Error`
postprocessor against the manufactured solution, over a series of successively refined meshes, for
both first- and second-order elements. As reported in [!citep](Franklin2025), the resulting $L_2$
error converges at approximately the expected rates for each element order:

!table id=tab:fnsf_heat_source_mms_rates caption=Observed $L_2$ error convergence rates [!citep](Franklin2025).
| Element order | Expected rate | Observed rate |
| :- | :- | :- |
| First  | 2 | 1.954 |
| Second | 3 | 2.956 |

These rates confirm that `FNSFHeatSource`'s $(\xi, \text{depth})$ grid-projection lookup (see
[FNSFUtils.md]) does not degrade the underlying finite-element convergence behavior of the heat
conduction solve.
