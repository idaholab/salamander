# Thermomechanics sub-app for the FULLY COUPLED slab benchmark with FET heating.
#
# This is solid.i (its physics, discretization and solver settings) plus the heating
# representation needed to receive a Legendre reconstruction, plus the in-input error
# metric developed in mechanics_only.i. Driven by openmc_fet.i as a TransientMultiApp.
#
#   cardinal-opt -i openmc_fet.i N=8          # coupled_convergence.py drives the sweep
#
# ---------------------------------------------------------------------------------------
# What was learned the hard way and is encoded here
# ---------------------------------------------------------------------------------------
#
# 1. 'kappa_fission' is FIRST order MONOMIAL, not CONSTANT. The incoming heating is a
#    Legendre reconstruction with sub-element shape; a CONSTANT MONOMIAL variable would
#    average that shape away on arrival and the FET would buy nothing.
#
# 2. The error metric is computed HERE, in the input, with ElementL2Error against the
#    analytic solution at the real FE quadrature points. A nodal-sampling metric only
#    checks the points where a FE solution is most accurate and flattered this problem by
#    ~70x (2.2e-6 against 1.74e-4 at N = 20).
#
# 3. Do NOT measure the error on a ProjectionAux copy. 'temperature_praux' is CONSTANT
#    MONOMIAL; projecting the solution through it discards everything above a cell average
#    and caps the measured order at 1 no matter how accurate the solve is. The praux
#    copies are kept because the transfers to OpenMC need elemental fields, but the metric
#    reads the solution variable directly.
#
# 4. 'automatic_scaling', 'nl_forced_its = 1' and 'scheme = bdf2' are required: without
#    them the N >= 20 cases diverge. These came from solid.i and must stay in sync with it.
#
# 5. 'use_closest_node' on the pin nodeset: an odd N puts no node at x = 0, and the pin is
#    a symmetry constraint, so the nearest node is the right choice. Harmless at even N.

N = 20

T0 = ${units 293 K}
L0 = ${units 100 cm}
L = ${units 106.47 cm}
P = ${units 1.0e22 eV/s}
q = ${units 1e8 eV}
k0 = ${units 1.25e19 eV/s/cm/K^2} # k(T) = k0 T(x)
phi0 = ${units 2.5e14 1/s/cm^2} # (flux at the origin)
eV_to_J = ${units 1.602176634e-19 J/eV}
lam = '${fparse 0.5*(1+sqrt(1+(16*q*q*phi0*phi0)/(P*P)))}' # eigenvalue solution
h = '${fparse 1/(sqrt(L*(lam-1)/(k0*P)) - (2*T0)/(P))*eV_to_J }' # W/cm^2-K

E = ${units 1e6 N/m^2}
nu = 0.0
rho = ${units 20 g/cm^3}
c_p = ${units 0.3 J/g/K}

[Mesh]
  [generated]
    type = GeneratedMeshGenerator
    dim = 1
    nx = ${N}
    xmin = -50
    xmax = 50
  []
  [pin]
    type = ExtraNodesetGenerator
    input = generated
    new_boundary = pin
    coord = '0 0 0'
    # An odd N puts no node at x = 0; the pin is a symmetry constraint, so the
    # nearest node is the right choice at those resolutions.
    use_closest_node = true
  []
[]

[Problem]
  type = ReferenceResidualProblem
  extra_tag_vectors = 'ref'
  reference_vector = 'ref'
[]

[GlobalParams]
  displacements = 'disp_x'
  use_displaced_mesh = true
[]

[Variables]
  [temperature]
  []
  [disp_x]
  []
[]

[Physics]
  [SolidMechanics]
    [QuasiStatic]
      [block1]
        strain = FINITE
        add_variables = true
        eigenstrain_names = eigenstrain
        generate_output = 'strain_xx'
        temperature = temperature
      []
    []
  []
[]

[ICs]
  [temperature]
    type = FunctionIC
    variable = temperature
    function = ${T0}
  []
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = temperature
  []
  [kappa_fission]
    type = CoupledForce
    variable = temperature
    v = kappa_fission
  []
  [dt]
    type = HeatConductionTimeDerivative
    variable = temperature
  []
[]

[AuxVariables]
  # The incoming heating is a Legendre reconstruction, not a cell average, so this is
  # FIRST order MONOMIAL to carry the sub-element shape through to the heat equation.
  # With CONSTANT MONOMIAL the expansion would be averaged away on arrival and the FET
  # would buy nothing.
  [kappa_fission]
    family = MONOMIAL
    order = FIRST
    initial_condition = '${fparse P*eV_to_J/L0 }'
  []

  # Elemental copies of the solution, needed only because the transfers back to OpenMC
  # operate on elemental fields. NOT used for the error metric; see note 3 in the header.
  [temperature_praux]
    family = MONOMIAL
    order = CONSTANT
  []
  [disp_praux]
  []

  # The analytic temperature, so ElementL2Norm has a variable to integrate for the
  # denominator of the relative error.
  [analytic_temperature_aux]
    family = LAGRANGE
    order = FIRST
  []
[]

[AuxKernels]
  [temperature_projection]
    type = ProjectionAux
    variable = temperature_praux
    v = temperature
  []
  [disp_projection]
    type = ProjectionAux
    variable = disp_praux
    v = disp_x
  []
  [analytic_temperature_aux]
    type = FunctionAux
    variable = analytic_temperature_aux
    function = analytic_temperature
    use_displaced_mesh = true
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Materials]
  [thermal_parameters]
    type = HeatConductionMaterial
    temperature = temperature
    thermal_conductivity_temperature_function = conductivity
    specific_heat = ${c_p}
  []
  [density]
    type = ParsedMaterial
    property_name = density
    expression = ${rho}
  []
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = ${E}
    poissons_ratio = ${nu}
  []
  [stress]
    type = ComputeFiniteStrainElasticStress
  []
  [thermal_expansion_strain]
    type = ComputeMeanThermalExpansionFunctionEigenstrain
    stress_free_temperature = ${T0}
    thermal_expansion_function_reference_temperature = ${T0}
    thermal_expansion_function = cte_func_mean
    temperature = temperature
    eigenstrain_name = eigenstrain
  []
[]

[BCs]
  [sides_convective_BC]
    type = ConvectiveFluxFunction
    T_infinity = ${T0}
    variable = temperature
    boundary = 'left right'
    coefficient = ${h}
  []
  [pin_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'pin'
    value = 0.0
  []
[]

[Functions]
  [conductivity]
    type = ParsedFunction
    expression = '${fparse k0*eV_to_J} * t'
  []
  [cte_func_mean]
    type = ParsedFunction
    expression = '1 / (2*sqrt(${T0}*t))'
  []

  # Analytic temperature, slab_benchmark.md eqn:temperature combined with
  # eqn:flux_solution:
  #
  #   T(x) = T_peak * sqrt(1 - (lam - 1) P^2 x^2 / (L^2 q^2 phi0^2))
  #
  # evaluated on the DEFORMED configuration, which is the coordinate system the analytic
  # solution is posed in. Constants are written out to full precision so the reference is
  # not itself a source of error.
  #
  # Here 'use_displaced_mesh = true' on the consuming objects IS correct, unlike in
  # neutronics_only.i: these run at TIMESTEP_END, after the displaced mesh has been
  # updated from the solution. The failure mode documented in neutronics_only.i was an
  # aux running at TIMESTEP_BEGIN, before the update.
  [analytic_temperature]
    type = ParsedFunction
    expression = 'Tpeak * sqrt(max(0, 1 - c2 * x * x))'
    symbol_names = 'Tpeak c2'
    symbol_values = '342.9973800481 6.386812485337e-05'
  []
[]

[Executioner]
  type = Transient
  solve_type = 'Newton'
  verbose = true
  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-10
  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
  snesmf_reuse_base = false
  line_search = 'none'

  # Required: without automatic scaling and a forced iteration the N >= 20 cases diverge.
  automatic_scaling = true

  nl_max_its = 100
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-1
    optimal_iterations = 10
    growth_factor = 1.25
    cutback_factor = 0.8
  []

  nl_forced_its = 1
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Outputs]
  exodus = false
  csv = true
[]

[Postprocessors]
  [source_integral]
    type = ElementIntegralVariablePostprocessor
    variable = kappa_fission
    execute_on = 'transfer initial timestep_end'
  []
  [strain_xx]
    type = ElementAverageValue
    variable = strain_xx
  []
  [total_length]
    type = FunctionElementIntegral
    function = 1
    execute_on = 'TIMESTEP_BEGIN LINEAR TIMESTEP_END'
  []

  # --------------------------------------------------------------------------------
  # Error metric, computed in the input against the real solution field.
  #
  #   eps_T = || T - T_exact ||_L2 / || T_exact ||_L2
  #
  # ElementL2Error integrates at the FE quadrature points, so it sees the error BETWEEN
  # nodes where a linear element cannot follow a curved profile. 'temperature' is the
  # solution variable, deliberately not the CONSTANT MONOMIAL 'temperature_praux'.
  # --------------------------------------------------------------------------------
  [l2_error_temperature]
    type = ElementL2Error
    variable = temperature
    function = analytic_temperature
    use_displaced_mesh = true
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [l2_norm_analytic]
    type = ElementL2Norm
    variable = analytic_temperature_aux
    use_displaced_mesh = true
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [eps_T]
    type = ParsedPostprocessor
    pp_names = 'l2_error_temperature l2_norm_analytic'
    expression = 'l2_error_temperature / l2_norm_analytic'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  # Peak temperature, against the analytic 342.997 K.
  [temperature_max]
    type = NodalExtremeValue
    variable = temperature
    value_type = max
  []
[]

[VectorPostprocessors]
  # The temperature profile, sampled on a FIXED grid independent of N.
  #
  # An ElementValueSampler returns one point per element, so the quadrature used to
  # integrate any error changes with the mesh and flatters coarse meshes. A LineValueSampler
  # with a fixed 'num_points' evaluates the field at the SAME coordinates at every N.
  #
  # The line stops slightly inside the deformed ends: the analytic profile vanishes at
  # +/- L/2 where a relative norm is ill-posed, and sampling outside the deformed domain
  # returns nothing.
  # The line is bounded by the UNDEFORMED half-length, not the deformed one.
  #
  # Unlike neutronics_only.i (where the deformation is imposed from t = 0 and the slab is
  # always 106.47 cm long), the coupled problem STARTS at the cold 100 cm length and grows
  # into its deformed state. A line reaching +/- 53.1 therefore falls outside the domain on
  # the first timesteps and LineValueSampler aborts the run with "sample point not found".
  # +/- 49.5 is inside the slab at every point of the transient, so the measurement grid is
  # identical at every N AND at every time -- which is the property the metric needs.
  [temperature_line]
    type = LineValueSampler
    variable = 'temperature'
    start_point = '-49.5 0 0'
    end_point = '49.5 0 0'
    num_points = 801
    sort_by = x
    execute_on = 'TIMESTEP_END'
    use_displaced_mesh = true
  []

  # The analytic reference, evaluated as a FUNCTION on the same line so it is
  # bit-identical at every resolution. It must NOT be read from a CONSTANT MONOMIAL
  # auxvariable: that is a piecewise-constant projection whose staircase changes with the
  # mesh, so the "fixed" reference would converge along with the solution (measured
  # deviation from the true formula was 1.2e-3 at N = 2 falling to 2.2e-5 at N = 15).
  [analytic_temperature_line]
    type = LineFunctionSampler
    functions = 'analytic_temperature'
    start_point = '-49.5 0 0'
    end_point = '49.5 0 0'
    num_points = 801
    sort_by = x
    execute_on = 'TIMESTEP_END'
  []

  # Element-wise profile, retained for plotting the per-cell structure that a line
  # sample smooths over.
  [convergence_temperature]
    type = ElementValueSampler
    variable = 'temperature_praux kappa_fission'
    sort_by = x
    execute_on = 'TIMESTEP_END'
    use_displaced_mesh = true
  []
[]
