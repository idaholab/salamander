# Cardinal/OpenMC driver app for the FULLY COUPLED slab benchmark with FET heating.
#
# The neutronics half of the coupled problem: per-cell spatial Legendre tallies of the
# heating (and flux), reconstructed into continuous fields and transferred to the
# thermomechanics sub-app solid_fet.i, which sends temperature and displacement back.
#
# Generated per resolution by coupled_convergence.py, which rewrites the mesh file name,
# the block lists and the per-cell [Tallies]/[Filters]/[AuxKernels] for N cells. The N = 20
# content below is a working default so the file runs standalone.
#
#   cardinal-opt -i openmc_fet.i
#
# ---------------------------------------------------------------------------------------
# What was learned the hard way and is encoded here
# ---------------------------------------------------------------------------------------
#
# 1. ONE filter per cell, each restricted with 'block'. OpenMC's SpatialLegendreFilter
#    spans a single interval and every bin of the tally it is attached to shares that one
#    basis, so a single filter over the whole slab would give each cell a slice of a global
#    polynomial. Per-cell filters give a genuinely element-local basis.
#
# 2. 'track_mesh = true' on every filter. The slab expands by 6.5%, so filter limits
#    derived once from the initial mesh would leave the outermost cells partly outside
#    their own expansion domain. Cardinal re-derives the limits each time the tallies are
#    re-initialized. (SpatialLegendreAux reads the limits live for the same reason -- a
#    cached copy silently returned zero in the expanded elements.)
#
# 3. 'normalization_tally = norm' pointing at a DOMAIN-WIDE heating tally. Cardinal
#    normalizes a non-heating score as local_mean * power / norm_tally_mean; with one cell
#    per tally the "local mean" is that single cell's mean, so each cell would be scaled by
#    its own flux relative to the global flux -- a phi^2 dependence, giving a field low by
#    ~1/N in magnitude with its spatial contrast SQUARED. Measured at N = 20: contrast
#    1.265 where the analytic profile varies by 1.103 (phi^2 predicts 1.217). Heating
#    scores are immune because they take a different branch, which is why power
#    conservation can read exactly 1602.177 W while the flux field is badly wrong.
#
# 4. 'check_tally_sum = false' on the per-cell tallies: each covers one cell, so its bins
#    never sum to the whole-domain tally.
#
# 5. 'normalization = volumetric' in SpatialLegendreAux, i.e. moment l weighted by
#    (2l + 1) and NOT by (2l + 1)/(max - min). Cardinal's tally variables have already
#    been divided by the mapped bin volume, which carries the length of the expansion
#    domain. Applying the length factor twice gave 80%/28% shape errors.
#
# 6. The reconstructed fields are FIRST order MONOMIAL. CONSTANT MONOMIAL would collapse
#    the expansion straight back to a cell average and the FET would buy nothing.
#
# 7. 'initial_properties = moose' is NOT set here, unlike neutronics_only.i: this is a
#    genuine coupled solve, so the temperature comes from the sub-app, starting from the
#    uniform IC below rather than being imposed analytically.

P = ${units 1.0e22 eV/s}
eV_to_J = ${units 1.602176634e-19 J/eV}
initial_temperature = ${units 293 K}

[Mesh]
  [file]
    type = FileMeshGenerator
    file = slab20v.e
  []
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  use_displaced_mesh = true
[]

[Variables]
  [disp_x]
  []
  [disp_y]
    initial_condition = 0.0
  []
  [disp_z]
    initial_condition = 0.0
  []
[]

[AuxVariables]
  [bins]
    family = MONOMIAL
    order = CONSTANT
  []
  # The reconstructed heating. FIRST order MONOMIAL so the order-2 Legendre shape within
  # each cell is retained rather than being collapsed back to a cell average.
  [kappa_fission_fet]
    family = MONOMIAL
    order = FIRST
  []
  # The reconstructed flux. The per-cell flux tallies are named fl_c<i>, so the name
  # 'flux' is free for the reconstruction.
  [flux]
    family = MONOMIAL
    order = FIRST
  []

  # The analytic flux and the products the error norm integrates. These depend only on
  # fields, never on a postprocessor, so they are safe to fill at TIMESTEP_END.
  [analytic_flux]
    family = MONOMIAL
    order = FIRST
  []
  [flux_sq]
    family = MONOMIAL
    order = FIRST
  []
  [flux_times_analytic]
    family = MONOMIAL
    order = FIRST
  []
  [analytic_flux_sq]
    family = MONOMIAL
    order = FIRST
  []
[]

[AuxKernels]
  [bins]
    type = SkinnedBins
    variable = bins
    skinner = moab
  []

  # Sum each cell's Legendre moments back into continuous fields. Each kernel is
  # restricted to its own cell, matching the element-local basis of its filter.
  # coupled_convergence.py regenerates this list for N cells.
  [fet_c1]
    type = SpatialLegendreAux
    variable = kappa_fission_fet
    block = '1'
    score = 'kappa_fission'
    tally = 'heating_c1'
    normalization = volumetric
    execute_on = 'timestep_end'
  []
  [fetflux_c1]
    type = SpatialLegendreAux
    variable = flux
    block = '1'
    score = 'flux'
    tally = 'fluxt_c1'
    normalization = volumetric
    execute_on = 'timestep_end'
  []

  # The analytic flux, evaluated on the DEFORMED configuration. 'use_displaced_mesh' is
  # reliable here because this runs at TIMESTEP_END, after the displaced mesh has been
  # updated from the incoming displacement. (In neutronics_only.i the equivalent aux ran
  # at TIMESTEP_BEGIN, before the update, and silently received REFERENCE coordinates --
  # which assigned every cell the temperature of its undeformed position, biased Sigma_t by
  # 1.29% at the slab edges, and produced an N-independent 4.3e-4 error floor that neither
  # mesh refinement nor extra Legendre moments could remove.)
  [analytic_flux]
    type = FunctionAux
    variable = analytic_flux
    function = analytic_flux_function
    execute_on = 'INITIAL TIMESTEP_END'
    use_displaced_mesh = true
  []
  [flux_sq]
    type = ParsedAux
    variable = flux_sq
    coupled_variables = 'flux'
    expression = 'flux * flux'
    execute_on = 'TIMESTEP_END'
  []
  [flux_times_analytic]
    type = ParsedAux
    variable = flux_times_analytic
    coupled_variables = 'flux analytic_flux'
    expression = 'flux * analytic_flux'
    execute_on = 'TIMESTEP_END'
  []
  [analytic_flux_sq]
    type = ParsedAux
    variable = analytic_flux_sq
    coupled_variables = 'analytic_flux'
    expression = 'analytic_flux * analytic_flux'
    execute_on = 'TIMESTEP_END'
  []
[]

[Functions]
  # phi(x) = phi0 sqrt(1 - c2 x^2), slab_benchmark.md eqn:flux_solution -- the same shape
  # as the temperature, which is what makes the heating uniform. Constants to full
  # precision so the reference is not itself a source of error.
  [analytic_flux_function]
    type = ParsedFunction
    expression = 'phi0 * sqrt(max(0, 1 - c2 * x * x))'
    symbol_names = 'phi0 c2'
    symbol_values = '2.5e14 6.386812485337e-05'
  []
[]

[ICs]
  [temperature]
    type = FunctionIC
    variable = temperature
    function = ${initial_temperature}
  []
[]

[Problem]
  type = OpenMCCellAverageProblem
  verbose = true
  source_rate_normalization = 'kappa_fission'
  # A domain-wide tally for the source-rate normalization; see note 3 in the header.
  normalization_tally = 'norm'
  inactive_batches = 150
  batches = 300
  particles = 100000
  power = '${fparse P*eV_to_J}'
  cell_level = 0
  temperature_variables = 'temperature'
  temperature_blocks = '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20'
  volume_calculation = vol
  skinner = moab

  [Tallies]
    # Whole-domain heating tally, used ONLY for source-rate normalization. It adds no
    # filter and is not reconstructed; it exists so 'normalization_tally' has a correct,
    # domain-wide target rather than a single cell.
    [norm]
      type = CellTally
      estimator = collision
      block = '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20'
      score = 'kappa_fission'
      name = 'kf_norm'
    []
    [heating_c1]
      type = CellTally
      estimator = collision
      block = '1'
      score = 'kappa_fission'
      name = 'kf_c1'
      filters = 'Legendre_1'
      # One cell per tally, so its bins never sum to the whole-domain tally.
      check_tally_sum = false
    []
    [fluxt_c1]
      type = CellTally
      estimator = collision
      block = '1'
      score = 'flux'
      name = 'fl_c1'
      filters = 'Legendre_1'
      # Per-cell flux tallies MUST opt out of the global-tally normalization.
      #
      # Cardinal normalizes a non-heating score as local_mean * power / norm_tally_mean,
      # and CellTally::storeResultsInner ALSO divides by the global tally sum. With one
      # cell per tally the "local mean" is that single cell's mean, so each cell ends up
      # scaled by its own flux relative to the global flux -- a phi^2 dependence. Measured
      # in this very sweep at N = 4: magnitude ratio 0.2498 (exactly 1/N) and envelope
      # contrast 1.1776 against the analytic 1.0906, matching analytic^2 = 1.1894. The
      # heating score is immune (it takes the *_power branch), which is why power
      # conservation read exactly 1602.177 W while the flux field was badly wrong and
      # eps_flux ROSE 26x from N=2 to N=4.
      normalize_by_global_tally = false
      check_tally_sum = false
    []
  []

  [Filters]
    [Legendre_1]
      type = SpatialLegendreFilter
      order = 2
      axis = x
      track_mesh = true
      block = '1'
    []
  []
[]

[Executioner]
  type = Transient
  start_time = 0.0
  end_time = 1e5
  dt = 500
[]

[MultiApps]
  [solid]
    type = TransientMultiApp
    input_files = 'solid_fet.i'
    execute_on = timestep_end
  []
[]

[Transfers]
  # Send the Legendre-reconstructed heating to the thermomechanics app. Conservation is
  # enforced against the heat_source integral of the reconstructed field, so the total
  # power delivered to the solid is preserved as the slab expands.
  [kappa_fission_to_solid]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = solid
    variable = kappa_fission
    source_variable = kappa_fission_fet
    from_postprocessors_to_be_preserved = heat_source
    to_postprocessors_to_be_preserved = source_integral
    execute_on = timestep_end
    displaced_source_mesh = true
    displaced_target_mesh = true
  []
  [temperature_from_solid]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = solid
    variable = temperature
    source_variable = temperature_praux
    execute_on = timestep_end
    displaced_source_mesh = true
    displaced_target_mesh = true
  []
  [dispx]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = disp_praux
    variable = disp_x
    from_multi_app = solid
    displaced_source_mesh = true
    displaced_target_mesh = true
  []
[]

[Outputs]
  exodus = false
  csv = true
[]

[Postprocessors]
  [heat_source]
    type = ElementIntegralVariablePostprocessor
    variable = kappa_fission_fet
    execute_on = 'transfer initial timestep_end'
  []
  [k]
    type = KEigenvalue
  []
  [k_std_dev]
    type = KEigenvalue
    output = 'std_dev'
  []
  [total_length]
    type = FunctionElementIntegral
    function = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [temperature_max]
    type = ElementExtremeValue
    variable = temperature
    value_type = max
    execute_on = 'INITIAL TIMESTEP_END'
  []

  # --------------------------------------------------------------------------------
  # Flux error metric, computed in the input so it uses the real reconstructed field.
  #
  #   eps_phi = || phi/<phi> - phi_a/<phi_a> ||_L2 / || phi_a/<phi_a> ||_L2
  #
  # Each field is divided by its own mean, so this measures the SHAPE of the profile and
  # Cardinal's per-source-particle flux normalization cancels exactly. Expanding the
  # square turns it into a combination of integrals,
  #
  #   eps_phi^2 = [ I_ff/fbar^2 - 2 I_fa/(fbar abar) + I_aa/abar^2 ] / [ I_aa/abar^2 ]
  #
  # It is built from integral postprocessors rather than by norming a residual
  # auxvariable, because of two ordering traps: postprocessors in the same 'execute_on'
  # are evaluated BEFORE the aux kernels that would fill such a residual (so the norm
  # integrates a stale zero field, giving eps_phi = 1 exactly), and ParsedAux cannot read
  # a postprocessor at all -- 'functor_names' takes functors, not postprocessors, and
  # silently yields zero. Composing integrals of field-only products avoids both.
  # --------------------------------------------------------------------------------
  [flux_mean]
    type = ElementAverageValue
    variable = flux
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [analytic_flux_mean]
    type = ElementAverageValue
    variable = analytic_flux
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [int_ff]
    type = ElementIntegralVariablePostprocessor
    variable = flux_sq
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [int_fa]
    type = ElementIntegralVariablePostprocessor
    variable = flux_times_analytic
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [int_aa]
    type = ElementIntegralVariablePostprocessor
    variable = analytic_flux_sq
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [eps_flux]
    type = ParsedPostprocessor
    pp_names = 'int_ff int_fa int_aa flux_mean analytic_flux_mean'
    expression = 'if(flux_mean > 0 & int_aa > 0,
                     sqrt(max(0, int_ff/(flux_mean*flux_mean)
                                 - 2*int_fa/(flux_mean*analytic_flux_mean)
                                 + int_aa/(analytic_flux_mean*analytic_flux_mean)))
                     / sqrt(int_aa/(analytic_flux_mean*analytic_flux_mean)),
                     0)'
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[VectorPostprocessors]
  # Error measurement on a FIXED grid, independent of N.
  #
  # An ElementValueSampler returns one point per element, so the quadrature used to
  # integrate the error changes with the mesh: at N = 2 the error integral would be
  # evaluated from 2 samples. That conflates the discretization being measured with the
  # resolution of the measurement itself and flatters coarse meshes. 801 points over the
  # heated slab gives ~0.13 cm spacing, so the integral is resolved at every resolution.
  # The line is bounded by the UNDEFORMED half-length, not the deformed one.
  #
  # Unlike neutronics_only.i (where the deformation is imposed from t = 0 and the slab is
  # always 106.47 cm long), the coupled problem STARTS at the cold 100 cm length and grows
  # into its deformed state. A line reaching +/- 53.1 therefore falls outside the domain on
  # the first timesteps and LineValueSampler aborts the run with "sample point not found".
  # +/- 49.5 is inside the slab at every point of the transient, so the measurement grid is
  # identical at every N AND at every time -- which is the property the metric needs.
  [flux_line]
    type = LineValueSampler
    variable = 'flux'
    start_point = '-49.5 0 0'
    end_point = '49.5 0 0'
    num_points = 801
    sort_by = x
    execute_on = 'TIMESTEP_END'
    use_displaced_mesh = true
  []

  # The analytic reference, evaluated as a FUNCTION on the same line, so it is
  # bit-identical at every resolution. It must NOT be taken from the 'analytic_flux'
  # auxvariable: sampling a projected variable returns a piecewise representation whose
  # staircase changes with the mesh, so the reference would converge along with the
  # solution (measured deviation from the true formula was 1.2e-3 at N = 2 falling to
  # 2.2e-5 at N = 15, i.e. the "fixed" reference was not fixed at all).
  [analytic_line]
    type = LineFunctionSampler
    functions = 'analytic_flux_function'
    start_point = '-49.5 0 0'
    end_point = '49.5 0 0'
    num_points = 801
    sort_by = x
    execute_on = 'TIMESTEP_END'
  []

  # Element-wise profiles, retained for plotting the per-cell structure of the
  # reconstruction that a line sample smooths over.
  [convergence_flux]
    type = ElementValueSampler
    variable = 'flux analytic_flux kappa_fission_fet'
    sort_by = x
    execute_on = 'TIMESTEP_END'
    use_displaced_mesh = true
  []
[]

[UserObjects]
  [vol]
    type = OpenMCVolumeCalculation
    n_samples = 200000
  []
  [moab]
    type = MoabSkinner
    execute_on = 'timestep_begin'
    verbose = true
    temperature = temperature
    n_temperature_bins = 1.0
    temperature_min = 0.0
    temperature_max = 1000
    build_graveyard = true
    graveyard_scale_inner = 1.5
    graveyard_scale_outer = 1.6
  []
[]
