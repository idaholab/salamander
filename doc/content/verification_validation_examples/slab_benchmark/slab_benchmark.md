# 1D Slab Benchmark: Neutron Transport Coupled With Thermal Conduction and Material Expansion

This verification problem presents capabilities to couple neutron transport with thermal conduction and material expansion. The analytic benchmark slab problem [!cite](griesheimer2022analytical) describes a slab where S$_2$ neutron transport is coupled with thermal conduction, convective boundary conditions, Doppler-broadened cross sections, and nonlinear thermal expansion effects along the heated slab. The benchmark provides the analytic solutions for steady-state temperature, neutron flux, heating, multiplication factor, and the heated slab length.

While the restriction to S$_2$ neutron transport would be considered overly simplistic for most radiation transport  simulations, the objective here is to verify thermomechanical-OpenMC coupling using analytic solutions for three coupled solution fields (Displacements, temperature, and flux). Simplifications of each individual physics included in this model are not imposed by inherent limitations of the moving-mesh capabilities and only aim to allow the study on the interactions between multiphysics with an analytic solution.

This work was published in [!cite](eltawila2025) where more details can be found.

# Problem description

A 1D slab [!cite](griesheimer2022analytical) with initial length $L_0$ and density $\rho_0$ has neutrons traveling with directions $\mu = \pm 1$ and with zero incoming neutron flux boundary conditions on both sides. The slab is mechanically constrained and perfectly insulated in the transverse dimensions (i.e., $y$ and $z$ axes) but free to expand via frictionless sliding along the $x$ axis as the temperature of the slab changes. Both ends of the slab are exposed to a convective heat sink at a fixed temperature $T_0$.

The neutron heating in the slab drives the temperature distribution and causes thermal expansion. This slab elongation feeds back into neutronics and heat conduction by influencing the domain length and material density. A schematic of the problem domain and boundary conditions is shown in [fig:prbschematic].

!media figures/slab_benchmark_prbdesc.png
  id=fig:prbschematic
  caption=Schematic of the three coupled physics.
  style=display:block;margin-left:auto;margin-right:auto;width:80%;

The benchmark uses a one-group assumption for neutron cross sections. The neutron flux distribution in the slab is governed by quasi-static transport in 1D. The resulting transport equation is

\begin{equation}
  \frac{d}{dx}\left[\frac{1}{\Sigma_t(x)}\frac{d\phi(x)}{dx} \right] + (\lambda -1 ) \Sigma_t(x)\phi(x) = 0,
\end{equation}

where we consider the vacuum flux boundary conditions

\begin{equation}
  \pm \frac{d\phi}{dx}\biggr\rvert_{\pm L/2} + \Sigma_t\left(\pm \frac{L}{2}\right)\phi\left(\pm \frac{L}{2}\right) = 0,
\end{equation}

where $\phi$ is the neutron flux, $\Sigma_t$ is the macroscopic total cross section, and $\lambda$ is the combined in-scattering and (quasi-static) fission source term. $\lambda$ is defined as

\begin{equation}
  \lambda \equiv \frac{1}{k_\text{eff}}\frac{\nu\Sigma_f}{\Sigma_t}+\frac{\Sigma_s}{\Sigma_t},
\end{equation}

where $\nu$ is the average number of neutrons released per fission, $k_\text{eff}$ is the multiplication factor, and $\Sigma_f/\Sigma_t$ and $\Sigma_s/\Sigma_t$ are the constant fractional probabilities of fission and scattering, respectively, per collision. The magnitude of the neutron flux is normalized to the total power of the slab, $P$, by

\begin{equation}
  P = \int_{-L/2}^{L/2} q \Sigma_t(x)\phi(x)dx,
\end{equation}

where $q$ is the energy released per neutron interaction. The Doppler-broadened total microscopic cross section is defined with an inverse square root behavior on temperature as

\begin{equation}
  \sigma_t(x) \equiv \sigma_{t,0} \sqrt{\frac{T_0}{T(x)}},
\end{equation}

and the Doppler-broadened total macroscopic cross section is defined as

\begin{equation}
  \Sigma_t(x) = M\rho_0\sigma_{t,0} \frac{T_0}{T(x)} = \frac{\Sigma_{t,0}T_0}{T(x)},
\end{equation}

where $\Sigma_{t,0}\equiv M\sigma_{t,0}\rho_0$ is the unheated macroscopic total cross section of the slab material. $M$ is the conversion between mass density and number density, given by $M = N_A/A$, where $N_A$ is Avogadro’s constant and $A$ is the atomic mass of the constituent atoms/molecules in the slab material. $\rho_0$ is the mass density.

The steady-state temperature distribution in the slab due to neutron heating is governed by the heat equation

\begin{equation}
  \frac{d}{dx}\Big[ \kappa(T)\frac{dT(x)}{dx} \Big] + q\Sigma_t(x)\phi(x) = 0,
\end{equation}

where there are convective boundary conditions at both ends given by

\begin{equation}
  \pm \kappa\left(\pm \frac{L}{2}\right)\frac{dT}{dx}\biggr\rvert_{\pm L/2} + h \left[T\left(\pm \frac{L}{2}\right) - T_0 \right] = 0,
\end{equation}

where $\kappa(T)$ is the thermal conductivity. The thermal conductivity is described by a linear function of temperature as

\begin{equation}
  \kappa(T) = \kappa_0 T(x).
  \label{eqn:conductivity}
\end{equation}

The differential length at every point along the slab expands upon heating, where temperature is also varying, in proportion to the local thermal strain $\epsilon_x$, such as

\begin{equation}
  \ell(x) = \ell_0 (\epsilon_x +1),
  \label{eqn:ell_eqn}
\end{equation}

where $\ell(x)$ and $\ell_0$ are differential length elements in the heated and unheated slab, respectively. The thermal strain at any location $x$ is given by

\begin{equation}
  \epsilon_x(T)=\int_{T_0}^T \alpha(T) dT,
  \label{eqn:epsilon}
\end{equation}

where the linear expansion coefficient $\alpha(T)$ is given by an inverse square root dependence on temperature,

\begin{equation}
  \alpha(T)\equiv\frac{1}{2\sqrt{T_0T}}.
  \label{eqn:alpha}
\end{equation}

We use total mass preservation to get material density change from the initial to the final state, starting from:

\begin{equation}
  \rho(x)\ell(x) = \rho_0\ell_0. \label{eqn:mass_conservation}
\end{equation}

To get the relation

\begin{equation}
  \rho(x) = \rho_0\sqrt{\frac{T_0}{T(x)}}
\end{equation}

# Analytic solutions

the reader is referred to the original benchmark publication [!citep](griesheimer2022analytical) for full details on the derivation of these solution. Here we present the final formulas that we use later for comparison with our models.

The heating distribution is given by

\begin{equation}
  \Sigma_t(x) \phi(x)q = \frac{P}{L},
  \label{eqn:heating}
\end{equation}

the neutron flux distribution is given by

\begin{equation}
  \phi(x) = \phi_0 \sqrt{1-\frac{(\lambda-1)P^2x^2}{L^2q^2\phi^2_0}},
  \label{eqn:flux_solution}
\end{equation}

and the temperature distribution is given by

\begin{equation}
  T(x) = \frac{q\Sigma_{t,0}T_0L}{P} \phi(x) ;.
  \label{eqn:temperature}
\end{equation}

Note that [eqn:flux_solution] is identical to the formula for an ellipse rather than the cosine shape normally seen with constant cross sections in finite slab geometries, as a result of the benchmark physics coupling.

The solution for the eigenvalue, $\lambda$, is given by

\begin{equation}
  \lambda = \frac{1}{2} \left(1+\sqrt{1+\frac{16q^2\phi^2_0}{P^2}} \right).
  \label{eqn:eigenvalue}
\end{equation}

Using manufactured parameters for the benchmark specifications (e.g., $L_0$, $P$), the values for the microscopic total cross section $\sigma_{t,0}$ and convective heat transfer coefficient $h$ are determined such that the temperature distribution also satisfies the manufactured scenario where the flux and temperature distributions have the same shape as given by [eqn:temperature].

The final length of the heated slab was evaluated using the flux and temperature solutions [eqn:flux_solution],[eqn:temperature], which were substituted into the mass conservation equation, [eqn:mass_conservation]. Integrating both sides gives the total length of the heated slab implicitly by preserving the total mass from the initial to the final state resulting

\begin{equation}
  \rho_0\int_{-L/2}^{L/2}\sqrt{\frac{T_0}{T(x)}}dx=\rho_0L_0.
\end{equation}

The final length of the heated slab $L$ is then given by

\begin{equation}
  L = \sqrt[3]{\Bigg(\frac{L_0}{_2F_1(1/4,1/2,3/2,1/\lambda)}\Bigg)^4\Bigg(\frac{\frac{q^2\phi^2_0}{P(\lambda-1)}-\frac{P}{4}}{\kappa_0T_0^2(1-1/\lambda)}\Bigg)}
  \label{eqn:length},
\end{equation}

where $_2F_1$ is the Gauss hypergeometric function.

To ensure a physically meaningful solution (i.e., the heat flux leaving the slab is consistent with the $T(\pm L/2)-T_0$), there is an additional constraint on the manufactured temperature distribution

\begin{equation}
  T\left(\pm\frac{L}{2}\right)\geq T_0.
  \label{eqn:constraint}
\end{equation}

Substituting [eqn:flux_solution] and [eqn:temperature] into [eqn:constraint] gives a minimum condition for power in terms of the other slab parameters, as

\begin{equation}
  P \geq \frac{4\kappa_0T_0^2}{L(\lambda-1)}.
  \label{eqn:power_condition}
\end{equation}

The example set of model parameter values shown in [tab:params] are the suggested benchmark parameters [!citep](griesheimer2022analytical), resulting in $k_\text{eff} = 0.29557$ and a heated slab length of $L = 106.47$ cm with $P = 1.0\times10^{22}$ eV/s.

!table id=tab:params caption=Example set of model parameters with two different power scenarios [!citep](griesheimer2022analytical).
| **Parameter**                  | **Value**                   | **Unit**                              |
| :- | :- | :- |
| **$\rho_0$**                   | 1.2                         | [g.cm$^{-3}]                          |
| **$L_0$**                      | 100                         | [cm]                                  |
| **$A$**                        | 180                         | [g.mol$^{-1}$]                        |
| **$T_0$**                      | 293                         | [K]                                   |
| **$q$**                        | 1.0E8                       | [eV].                                 |
| **$\kappa_0$**                 | 1.25E19.                    | [eV.s$^{-1}$.cm$^{-1}$.K$^{-2}$]      |
| **$\phi_0$**                   | 2.5E14                      | [cm$^{-2}$.s$^{-1}$]                  |
| **$\nu\Sigma_f/\Sigma_t$**     | 1.5                         | [-]                                   |
| **$\Sigma_s/\Sigma_t$**        | 0.45                        | [-]                                   |
| **$P$**                        | 1.0E22                      | [eV.s$^{-1}$]                         |

# Problem model

!alert construction title=To run this model you need to build your application with the S$_2$ OpenMC patch
This model is using S$_2$ neutron transport to compare with the 1D Analytic benchmark. To replicate
the results, you have build your application with [this](https://github.com/meltawila/openmc_S2transport) patch of OpenMC.

Cardinal is used to couple OpenMC with MOOSE via Picard iteration. OpenMC tallies neutron flux, heating, and the multiplication factor. A conceptual depiction of the meshes used as well as the data transfers that occur on each Picard iteration is shown in [fig:schematic]. Three different meshes/geometries are involved. The thermomechanics mesh is a simple 1D mesh of $N$ EDGE2 elements; the thermomechanical physics do not require higher dimensional (e.g. 2D or 3D) meshes for this problem. The OpenMC geometry is represented using DAGMC, where cells are bounded by a triangulated surface (TRI3 elements). To facilitate data transfers between OpenMC and MOOSE thermomechanics, there is also an intermediate volumetric data transfer mesh composed of TET4 elements; no physics solves happen on this intermediate mesh. [fig:schematic] highlights one element (for MOOSE and the Cardinal intermediate data transfer mesh) and one OpenMC cell each in blue, with adjacent portions of the geometry shown in gray for context.

!media figures/slab_benchmark_prbschematic.png
  id=fig:schematic
  caption=Data transfers between OpenMC and MOOSE and conceptual depiction of the different meshes used.
  style=display:block;margin-left:auto;margin-right:auto;width:80%;

We show the input files for a coarse mesh here with more details on results convergence shown in the next section.

The OpenMC input files is as follows:

!listing /doc/content/verification_validation_examples/slab_benchmark/model/make_openmc_model_dagmc.py language=python

The neutronics input file is as follows:

!listing /doc/content/verification_validation_examples/slab_benchmark/model/openmc.i

The thermomechanics input file is as follows:

!listing /doc/content/verification_validation_examples/slab_benchmark/model/solid.i

It is important to note that incremental (hypoelastic) formulations of finite strain behavior inherently introduce inaccuracies arising from the time integration error. This limitation is inherent to this formulation and therefore exists in the MOOSE implementation and the implementations of other major commercial codes. The magnitude of these errors grows with increasing strain, so this typically becomes a practical issue only for very large strains, for which hyperelastic models are more appropriate [!citep](belytschko2003).

The main sources of error in this coupled model are: (i) the statistical error from use of finite particles in OpenMC; (ii) the user-input cross-section data, which is defined with 1 K $\Delta$T spacings used in all cases while taking the nearest temperature point cross section; and (iii) discretization error from a finite spatial mesh in both OpenMC (temperature feedback resolution) and MOOSE thermomechanics. Additional sources of error are present, but anticipated to be negligible due to the use of fine settings for these simulation parameters: (i) finite Picard iterations, and (ii) nonzero nonlinear tolerances in the MOOSE thermomechanics model.

# Results

We see the heating result in [fig:heatingsol] compared against the analytic solution, as well as flux and temperature solutions in [fig:fluxsol] and [fig:tempsol]. Figures are only included for P=1.0E22 [eV.s$^{-1}$] and on a fine mesh where the number of OpenMC and mesh elements is $N = 100$, since all results have a similar shape. Both the heating and flux tally everywhere agrees with the analytic solution within 3σ.

!media figures/slab_benchmark_heatingsol.png
  id=fig:heatingsol
  caption=Heating result from OpenMC for N = 100 mesh elements compared against the analytic solution.
  style=display:block;margin-left:auto;margin-right:auto;width:80%;

!media figures/slab_benchmark_fluxsol.png
  id=fig:fluxsol
  caption=Flux result from OpenMC for N = 100 mesh elements compared against the analytic solution.
  style=display:block;margin-left:auto;margin-right:auto;width:80%;

!media figures/slab_benchmark_tempsol.png
  id=fig:tempsol
  caption=Temperature result from MOOSE for N = 100 mesh elements compared against the analytic solution.
  style=display:block;margin-left:auto;margin-right:auto;width:80%;


!table id=tab:results caption=k$_{eff}$ results for each mesh size and corresponding errors for P=1.0E22 [eV.s$^{-1}$] [!citep](eltawila2025).
| **Resolution**        | **Heated length [cm]** | **Error [μm]** | **$k_{\text{eff}}$** | **Error [pcm]** |
|-----------------------|------------------------|----------------|----------------------|-----------------|
| **Analytic solution** | 106.47                 | --             | 0.29557              | --              |
|-----------------------|------------------------|----------------|----------------------|-----------------|
| **5**                 | 106.3298               | -1402          | 0.29608 ± 0.00001    | 51 ± 1          |
| **10**                | 106.4382               | -318           | 0.29619 ± 0.00001    | 62 ± 1          |
| **20**                | 106.4671               | -29            | 0.29557 ± 0.00001    | 0 ± 1           |
| **50**                | 106.4730               | 30             | 0.29536 ± 0.00001    | -21 ± 1         |
| **100**               | 106.4745               | 45             | 0.29549 ± 0.00001    | -8 ± 1          |
| **200**               | 106.4748               | 48             | 0.29556 ± 0.00001    | -1 ± 1          |

In [fig:fluxconv] and [fig:tempconv] convergence of flux and temperature relative L$^2$ norms, defined as

\begin{equation}
  \varepsilon_\phi=\frac{||\phi_a-\phi_{sln.}||_2}{||\phi_a||_2}
\end{equation}

and

\begin{equation}
  \varepsilon_T=\frac{||T_a-T_{sln.}||_2}{||T_a||_2}
\end{equation}

where $\phi_a$ is the analytic flux solution, $\phi_{sln.}$ is the Cardinal flux solution, $T_a$ is the analytic temperature solution, and $T_{sln.}$ is the Cardinal temperature solution.

!media figures/slab_benchmark_fluxconv.png
  id=fig:fluxconv
  caption=Convergence of flux relative L$^2$ norm.
  style=display:block;margin-left:auto;margin-right:auto;width:80%;

!media figures/slab_benchmark_tempconv.png
  id=fig:tempconv
  caption=Convergence of temperature relative L$^2$ norm.
  style=display:block;margin-left:auto;margin-right:auto;width:80%;

More details and discussion can be found in [!citep](eltawila2025).
