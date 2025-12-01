# This is the input file adding Tritium transport capability via TMAP8
# It is meant to be used with divertor_monoblock_base.i

### Nomenclatures
### C_mobile_j    mobile H concentration in "j" material, where j = CuCrZr, Cu, W
### C_trapped_j   trapped H concentration in "j" material, where j = CuCrZr, Cu, W
### C_total_j     total H concentration in "j" material, where j = CuCrZr, Cu, W
###
### S_empty_j     empty site concentration in "j" material, where j = CuCrZr, Cu, W
### S_trapped_j   trapped site concentration in "j" material, where j = CuCrZr, Cu, W
### S_total_j     total site H concentration in "j" material, where j = CuCrZr, Cu, W
###
### F_permeation  permeation flux
### F_recombination recombination flux
###
### Sc_       Scaled
### Int_      Integrated
### ScInt_      Scaled and integrated

# Material properties
tungsten_atomic_density = ${units 6.338e28 m^-3}
# Ct0_W = ${units 1.0e-4 m^-3}   # E.A. Hodille et al 2021 Nucl. Fusion 61 126003, trap 1
Ct0_W = ${units 1.0e-4 m^-3}  # E.A. Hodille et al 2021 Nucl. Fusion 61 1260033, trap 2
Ct0_Cu = ${units 5.0e-5 m^-3}  # R. Delaporte-Mathurin et al 2021 Nucl. Fusion 61 036038, trap 3
Ct0_CuCrZr = ${units 5.0e-5 m^-3}  # R. Delaporte-Mathurin et al 2021 Nucl. Fusion 61 036038, trap 4
# Ct0_CuCrZr = ${units 4.0e-2 m^-3} # R. Delaporte-Mathurin et al 2021 Nucl. Fusion 61 036038, trap 5


[Variables]
  ######################### Variables for W (block = 4)
  [C_mobile_W]
    order = FIRST
    family = LAGRANGE
    initial_condition = ${units 1.0e-20 m^-3}
    block = 4
  []
  [C_trapped_W]
    order = FIRST
    family = LAGRANGE
    initial_condition = ${units 1.0e-15 m^-3}
    block = 4
  []
  ######################### Variables for Cu (block = 3)
  [C_mobile_Cu]
    order = FIRST
    family = LAGRANGE
    initial_condition = ${units 5.0e-17 m^-3}
    block = 3
  []
  [C_trapped_Cu]
    order = FIRST
    family = LAGRANGE
    initial_condition = ${units 1.0e-15 m^-3}
    block = 3
  []
  ######################### Variables for CuCrZr (block = 2)
  [C_mobile_CuCrZr]
    order = FIRST
    family = LAGRANGE
    initial_condition = ${units 1.0e-15 m^-3}
    block = 2
  []
  [C_trapped_CuCrZr]
    order = FIRST
    family = LAGRANGE
    initial_condition = ${units 1.0e-15 m^-3}
    block = 2
  []
[]

[AuxVariables]
  [flux_y]
    order = FIRST
    family = MONOMIAL
  []
  ############################## AuxVariables for W (block = 4)
  [Sc_C_mobile_W]
    block = 4
  []
  [Sc_C_trapped_W]
    block = 4
  []
  [C_total_W]
    block = 4
  []
  [Sc_C_total_W]
    block = 4
  []
  [S_empty_W]
    block = 4
  []
  [Sc_S_empty_W]
    block = 4
  []
  [S_trapped_W]
    block = 4
  []
  [Sc_S_trapped_W]
    block = 4
  []
  [S_total_W]
    block = 4
  []
  [Sc_S_total_W]
    block = 4
  []
  ############################## AuxVariables for Cu (block = 3)
  [Sc_C_mobile_Cu]
    block = 3
  []
  [Sc_C_trapped_Cu]
    block = 3
  []
  [C_total_Cu]
    block = 3
  []
  [Sc_C_total_Cu]
    block = 3
  []
  [S_empty_Cu]
    block = 3
  []
  [Sc_S_empty_Cu]
    block = 3
  []
  [S_trapped_Cu]
    block = 3
  []
  [Sc_S_trapped_Cu]
    block = 3
  []
  [S_total_Cu]
    block = 3
  []
  [Sc_S_total_Cu]
    block = 3
  []
  ############################## AuxVariables for CuCrZr (block = 2)
  [Sc_C_mobile_CuCrZr]
    block = 2
  []
  [Sc_C_trapped_CuCrZr]
    block = 2
  []
  [C_total_CuCrZr]
    block = 2
  []
  [Sc_C_total_CuCrZr]
    block = 2
  []
  [S_empty_CuCrZr]
    block = 2
  []
  [Sc_S_empty_CuCrZr]
    block = 2
  []
  [S_trapped_CuCrZr]
    block = 2
  []
  [Sc_S_trapped_CuCrZr]
    block = 2
  []
  [S_total_CuCrZr]
    block = 2
  []
  [Sc_S_total_CuCrZr]
    block = 2
  []
[]

[Kernels]
  ############################## Kernels for W (block = 4)
  [diff_W]
    type = ADMatDiffusion
    variable = C_mobile_W
    diffusivity = diffusivity_W
    block = 4
    extra_vector_tags = ref
  []
  [time_diff_W]
    type = ADTimeDerivative
    variable = C_mobile_W
    block = 4
    extra_vector_tags = ref
  []
  [coupled_time_W]
    type = CoupledTimeDerivative
    variable = C_mobile_W
    v = C_trapped_W
    block = 4
    extra_vector_tags = ref
  []
  ############################## Kernels for Cu (block = 3)
  [diff_Cu]
    type = ADMatDiffusion
    variable = C_mobile_Cu
    diffusivity = diffusivity_Cu
    block = 3
    extra_vector_tags = ref
  []
  [time_diff_Cu]
    type = ADTimeDerivative
    variable = C_mobile_Cu
    block = 3
    extra_vector_tags = ref
  []
  [coupled_time_Cu]
    type = CoupledTimeDerivative
    variable = C_mobile_Cu
    v = C_trapped_Cu
    block = 3
    extra_vector_tags = ref
  []
  ############################## Kernels for CuCrZr (block = 2)
  [diff_CuCrZr]
    type = ADMatDiffusion
    variable = C_mobile_CuCrZr
    diffusivity = diffusivity_CuCrZr
    block = 2
    extra_vector_tags = ref
  []
  [time_diff_CuCrZr]
    type = ADTimeDerivative
    variable = C_mobile_CuCrZr
    block = 2
    extra_vector_tags = ref
  []
  [coupled_time_CuCrZr]
    type = CoupledTimeDerivative
    variable = C_mobile_CuCrZr
    v = C_trapped_CuCrZr
    block = 2
    extra_vector_tags = ref
  []
[]

[AuxKernels]
  ############################## AuxKernels for W (block = 4)
  [Scaled_mobile_W]
    variable = Sc_C_mobile_W
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = C_mobile_W
  []
  [Scaled_trapped_W]
    variable = Sc_C_trapped_W
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = C_trapped_W
  []
  [total_W]
    variable = C_total_W
    type = ParsedAux
    expression = 'C_mobile_W + C_trapped_W'
    coupled_variables = 'C_mobile_W C_trapped_W'
  []
  [Scaled_total_W]
    variable = Sc_C_total_W
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = C_total_W
  []
  [empty_sites_W]
    variable = S_empty_W
    type = EmptySitesAux
    N = ${units 1.0e0 m^-3}     # = ${tungsten_atomic_density} #/m^3 (W lattice density)
    Ct0 = ${Ct0_W}
    trap_per_free = 1.0e0     # 1.0e1
    trapped_concentration_variables = C_trapped_W
  []
  [scaled_empty_W]
    variable = Sc_S_empty_W
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = S_empty_W
  []
  [trapped_sites_W]
    variable = S_trapped_W
    type = NormalizationAux
    normal_factor = 1e0
    source_variable = C_trapped_W
  []
  [scaled_trapped_W]
    variable = Sc_S_trapped_W
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = S_trapped_W
  []
  [total_sites_W]
    variable = S_total_W
    type = ParsedAux
    expression = 'S_trapped_W + S_empty_W'
    coupled_variables = 'S_trapped_W S_empty_W'
  []
  [scaled_total_W]
    variable = Sc_S_total_W
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = S_total_W
  []
  ############################## AuxKernels for Cu (block = 3)
  [Scaled_mobile_Cu]
    variable = Sc_C_mobile_Cu
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = C_mobile_Cu
  []
  [Scaled_trapped_Cu]
    variable = Sc_C_trapped_Cu
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = C_trapped_Cu
  []
  [total_Cu]
    variable = C_total_Cu
    type = ParsedAux
    expression = 'C_mobile_Cu + C_trapped_Cu'
    coupled_variables = 'C_mobile_Cu C_trapped_Cu'
  []
  [Scaled_total_Cu]
    variable = Sc_C_total_Cu
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = C_total_Cu
  []
  [empty_sites_Cu]
    variable = S_empty_Cu
    type = EmptySitesAux
    N = ${units 1.0e0 m^-3}   # = ${tungsten_atomic_density} #/m^3 (W lattice density)
    Ct0 = ${Ct0_Cu}
    trap_per_free = 1.0e0     # 1.0e1
    trapped_concentration_variables = C_trapped_Cu
  []
  [scaled_empty_Cu]
    variable = Sc_S_empty_Cu
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = S_empty_Cu
  []
  [trapped_sites_Cu]
    variable = S_trapped_Cu
    type = NormalizationAux
    normal_factor = 1e0
    source_variable = C_trapped_Cu
  []
  [scaled_trapped_Cu]
    variable = Sc_S_trapped_Cu
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = S_trapped_Cu
  []
  [total_sites_Cu]
    variable = S_total_Cu
    type = ParsedAux
    expression = 'S_trapped_Cu + S_empty_Cu'
    coupled_variables = 'S_trapped_Cu S_empty_Cu'
  []
  [scaled_total_Cu]
    variable = Sc_S_total_Cu
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = S_total_Cu
  []
  ############################## AuxKernels for CuCrZr (block = 2)
  [Scaled_mobile_CuCrZr]
    variable = Sc_C_mobile_CuCrZr
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = C_mobile_CuCrZr
  []
  [Scaled_trapped_CuCrZr]
    variable = Sc_C_trapped_CuCrZr
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = C_trapped_CuCrZr
  []
  [total_CuCrZr]
    variable = C_total_CuCrZr
    type = ParsedAux
    expression = 'C_mobile_CuCrZr + C_trapped_CuCrZr'
    coupled_variables = 'C_mobile_CuCrZr C_trapped_CuCrZr'
  []
  [Scaled_total_CuCrZr]
    variable = Sc_C_total_CuCrZr
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = C_total_CuCrZr
  []
  [empty_sites_CuCrZr]
    variable = S_empty_CuCrZr
    type = EmptySitesAux
    N = ${units 1.0e0 m^-3}   # = ${tungsten_atomic_density} #/m^3 (W lattice density)
    Ct0 = ${Ct0_CuCrZr}
    trap_per_free = 1.0e0     # 1.0e1
    trapped_concentration_variables = C_trapped_CuCrZr
  []
  [scaled_empty_CuCrZr]
    variable = Sc_S_empty_CuCrZr
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = S_empty_CuCrZr
  []
  [trapped_sites_CuCrZr]
    variable = S_trapped_CuCrZr
    type = NormalizationAux
    normal_factor = 1e0
    source_variable = C_trapped_CuCrZr
  []
  [scaled_trapped_CuCrZr]
    variable = Sc_S_trapped_CuCrZr
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = S_trapped_CuCrZr
  []
  [total_sites_CuCrZr]
    variable = S_total_CuCrZr
    type = ParsedAux
    expression = 'S_trapped_CuCrZr + S_empty_CuCrZr'
    coupled_variables = 'S_trapped_CuCrZr S_empty_CuCrZr'
  []
  [scaled_total_CuCrZr]
    variable = Sc_S_total_CuCrZr
    type = NormalizationAux
    normal_factor = ${tungsten_atomic_density}
    source_variable = S_total_CuCrZr
  []
  [flux_y_W]
    type = DiffusionFluxAux
    diffusivity = diffusivity_W
    variable = flux_y
    diffusion_variable = C_mobile_W
    component = y
    block = 4
  []
  [flux_y_Cu]
    type = DiffusionFluxAux
    diffusivity = diffusivity_Cu
    variable = flux_y
    diffusion_variable = C_mobile_Cu
    component = y
    block = 3
  []
  [flux_y_CuCrZr]
    type = DiffusionFluxAux
    diffusivity = diffusivity_CuCrZr
    variable = flux_y
    diffusion_variable = C_mobile_CuCrZr
    component = y
    block = 2
  []
[]

[InterfaceKernels]
  [tied_4to3]
    type = ADPenaltyInterfaceDiffusion
    variable = C_mobile_W
    neighbor_var = C_mobile_Cu
    penalty = 0.05      #  it will not converge with > 0.1, but it creates negative C_mobile _Cu with << 0.1
    # jump_prop_name = solubility_ratio_4to3
    jump_prop_name = solubility_ratio
    boundary = '4to3'
  []
  [tied_3to2]
    type = ADPenaltyInterfaceDiffusion
    variable = C_mobile_Cu
    neighbor_var = C_mobile_CuCrZr
    penalty = 0.05      #  it will not converge with > 0.1, but it creates negative C_mobile _Cu with << 0.1
    # jump_prop_name = solubility_ratio_3to2
    jump_prop_name = solubility_ratio
    boundary = '3to2'
  []
[]

[NodalKernels]
  ############################## NodalKernels for W (block = 4)
  [time_W]
    type = TimeDerivativeNodalKernel
    variable = C_trapped_W
  []
  [trapping_W]
    type = TrappingNodalKernel
    variable = C_trapped_W
    temperature = temperature
    alpha_t = 2.75e11    # 1e15
    N = 1.0e0  # = (1e0) x (${tungsten_atomic_density} #/m^3)
    Ct0 = ${Ct0_W}
    trap_per_free = 1.0e0     # 1.0e1
    mobile_concentration = 'C_mobile_W'
    extra_vector_tags = ref
  []
  [release_W]
    type = ReleasingNodalKernel
    alpha_r = 8.4e12  # 1.0e13
    temperature = temperature
    # detrapping_energy = 9863.9  # = 0.85 eV  E.A. Hodille et al 2021 Nucl. Fusion 61 126003, trap 1
    detrapping_energy = 11604.6   # = 1.00 eV  E.A. Hodille et al 2021 Nucl. Fusion 61 126003, trap 2
    variable = C_trapped_W
  []
  ############################## NodalKernels for Cu (block = 3)
  [time_Cu]
    type = TimeDerivativeNodalKernel
    variable = C_trapped_Cu
  []
  [trapping_Cu]
    type = TrappingNodalKernel
    variable = C_trapped_Cu
    temperature = temperature
    alpha_t = 2.75e11    # 1e15
    N = 1.0e0  # = ${tungsten_atomic_density} #/m^3 (W lattice density)
    Ct0 = ${Ct0_Cu}
    trap_per_free = 1.0e0     # 1.0e1
    mobile_concentration = 'C_mobile_Cu'
    extra_vector_tags = ref
  []
  [release_Cu]
    type = ReleasingNodalKernel
    alpha_r = 8.4e12  # 1.0e13
    temperature = temperature
    detrapping_energy = 5802.3  # = 0.50eV  R. Delaporte-Mathurin et al 2021 Nucl. Fusion 61 036038, trap 3
    variable = C_trapped_Cu
  []
  ############################## NodalKernels for CuCrZr (block = 2)
  [time_CuCrZr]
    type = TimeDerivativeNodalKernel
    variable = C_trapped_CuCrZr
  []
  [trapping_CuCrZr]
    type = TrappingNodalKernel
    variable = C_trapped_CuCrZr
    temperature = temperature
    alpha_t = 2.75e11    # 1e15
    N = 1.0e0  # = ${tungsten_atomic_density} #/m^3 (W lattice density)
    Ct0 = ${Ct0_CuCrZr}
    trap_per_free = 1.0e0     # 1.0e1
    mobile_concentration = 'C_mobile_CuCrZr'
    extra_vector_tags = ref
  []
  [release_CuCrZr]
    type = ReleasingNodalKernel
    alpha_r = 8.4e12  # 1.0e13
    temperature = temperature
    detrapping_energy = 5802.3  # = 0.50eV  R. Delaporte-Mathurin et al 2021 Nucl. Fusion 61 036038, trap 4
    # detrapping_energy = 9631.8   # = 0.83 eV  R. Delaporte-Mathurin et al 2021 Nucl. Fusion 61 036038, trap 5
    variable = C_trapped_CuCrZr
  []
[]

[BCs]
  [C_mob_W_top_flux]
    type = FunctionNeumannBC
    variable = C_mobile_W
    boundary = 'top'
    function = mobile_flux_bc_func
  []
  [mobile_tube]
    type = DirichletBC
    variable = C_mobile_CuCrZr
    value = 1.0e-18
    boundary = '2to1'
  []
[]

[Functions]
  ### Maximum mobile flux of 7.90e-13 at the top surface (1.0e-4 [m])
  ### 1.80e23/m^2-s = (5.0e23/m^2-s) *(1-0.999) = (7.90e-13)*(${tungsten_atomic_density})/(1.0e-4)  at steady state
  [mobile_flux_bc_func]
    type = ParsedFunction
    expression =   'if((t % 1600) < 100.0, 0.0    + 7.90e-13*(t % 1600)/100,
            if((t % 1600) < 500.0, 7.90e-13,
            if((t % 1600) < 600.0, 7.90e-13 - 7.90e-13*((t % 1600)-500)/100, 0.0)))'
  []
[]

[Materials]
  ############################## Materials for W (block = 4)
  [diffusivity_W]
    type = ADParsedMaterial
    property_name = diffusivity_W
    coupled_variables = 'temperature'
    block = 4
    expression = '2.4e-7*exp(-4525.8/temperature)'  # H diffusivity in W
    outputs = all
  []
  [solubility_W]
    type = ADParsedMaterial
    property_name = solubility_W
    coupled_variables = 'temperature'
    block = 4
    # expression = '2.95e-5 *exp(-12069.0/temperature)'        # H solubility in W = (1.87e24)/(${tungsten_atomic_density}) [#/m^3]
    expression = '2.95e-5 *exp(-12069.0/temperature) + 4.95e-8 * exp(-6614.6/temperature)'  # H solubility in W = (1.87e24)/(${tungsten_atomic_density}) [#/m^3]
    outputs = all
  []
  [converter_to_regular_W]
    type = MaterialADConverter
    ad_props_in = 'diffusivity_W'
    reg_props_out = 'diffusivity_W_nonAD'
    block = 4
  []
  ############################## Materials for Cu (block = 3)
  [diffusivity_Cu]
    type = ADParsedMaterial
    property_name = diffusivity_Cu
    coupled_variables = 'temperature'
    block = 3
    expression = '6.60e-7*exp(-4525.8/temperature)'  # H diffusivity in Cu
    outputs = all
  []
  [solubility_Cu]
    type = ADParsedMaterial
    property_name = solubility_Cu
    coupled_variables = 'temperature'
    block = 3
    expression = '4.95e-5*exp(-6614.6/temperature)'  # H solubility in Cu = (3.14e24)/(${tungsten_atomic_density}) [#/m^3]
    outputs = all
  []
  [converter_to_regular_Cu]
    type = MaterialADConverter
    ad_props_in = 'diffusivity_Cu'
    reg_props_out = 'diffusivity_Cu_nonAD'
    block = 3
  []
  ############################## Materials for CuCrZr (block = 2)
  [diffusivity_CuCrZr]
    type = ADParsedMaterial
    property_name = diffusivity_CuCrZr
    coupled_variables = 'temperature'
    block = 2
    expression = '3.90e-7*exp(-4873.9/temperature)'  # H diffusivity in CuCrZr
    outputs = all
  []
  [solubility_CuCrZr]
    type = ADParsedMaterial
    property_name = solubility_CuCrZr
    coupled_variables = 'temperature'
    block = 2
    expression = '6.75e-6*exp(-4525.8/temperature)'  # H solubility in CuCrZr = (4.28e23)/(${tungsten_atomic_density}) [#/m^3]
    outputs = all
  []
  [converter_to_regular_CuCrZr]
    type = MaterialADConverter
    ad_props_in = 'diffusivity_CuCrZr'
    reg_props_out = 'diffusivity_CuCrZr_nonAD'
    block = 2
  []
  ############################## Materials for others
  [interface_jump_4to3]
    type = SolubilityRatioMaterial
    solubility_primary = solubility_W
    solubility_secondary = solubility_Cu
    boundary = '4to3'
    concentration_primary = C_mobile_W
    concentration_secondary = C_mobile_Cu
  []
  [interface_jump_3to2]
    type = SolubilityRatioMaterial
    solubility_primary = solubility_Cu
    solubility_secondary = solubility_CuCrZr
    boundary = '3to2'
    concentration_primary = C_mobile_Cu
    concentration_secondary = C_mobile_CuCrZr
  []
[]

[Postprocessors]
  ############################################################ Postprocessors for W (block = 4)
  [F_recombination]
    type = SideDiffusiveFluxAverage
    boundary = 'top'
    diffusivity = 5.01e-24   # (3.01604928)/(6.02e23)/[gram(T)/m^2]
    # diffusivity = 5.508e-19   # (1.0e3)*(1.0e3)/(6.02e23)/(3.01604928) [gram(T)/m^2]
    variable = Sc_C_total_W
  []
  [F_permeation]
    type = SideDiffusiveFluxAverage
    boundary = '2to1'
    diffusivity = 5.01e-24   # (3.01604928)/(6.02e23)/[gram(T)/m^2]
    # diffusivity = 5.508e-19   # (1.0e3)*(1.0e3)/(6.02e23)/(3.01604928) [gram(T)/m^2]
    variable = Sc_C_total_CuCrZr
  []

  [Int_C_mobile_W]
    type = ElementIntegralVariablePostprocessor
    variable = C_mobile_W
    block = 4
  []
  [ScInt_C_mobile_W]
    type = ScalePostprocessor
    value =  Int_C_mobile_W
    scaling_factor = 3.491e10   # (1.0e3)*(1.0e3)*(${tungsten_atomic_density})/(6.02e23)/(3.01604928) [gram(T)/m^2]
  []
  [Int_C_trapped_W]
    type = ElementIntegralVariablePostprocessor
    variable = C_trapped_W
    block = 4
  []
  [ScInt_C_trapped_W]
    type = ScalePostprocessor
    value = Int_C_trapped_W
    scaling_factor = 3.491e10   # (1.0e3)*(1.0e3)*(${tungsten_atomic_density})/(6.02e23)/(3.01604928) [gram(T)/m^2]
  []
  [Int_C_total_W]
    type = ElementIntegralVariablePostprocessor
    variable = C_total_W
    block = 4
  []
  [ScInt_C_total_W]
    type = ScalePostprocessor
    value = Int_C_total_W
    scaling_factor = 3.491e10   # (1.0e3)*(1.0e3)*(${tungsten_atomic_density})/(6.02e23)/(3.01604928) [gram(T)/m^2]
  []
  # ############################################################ Postprocessors for Cu (block = 3)
  [Int_C_mobile_Cu]
    type = ElementIntegralVariablePostprocessor
    variable = C_mobile_Cu
    block = 3
  []
  [ScInt_C_mobile_Cu]
    type = ScalePostprocessor
    value =  Int_C_mobile_Cu
    scaling_factor = 3.491e10   # (1.0e3)*(1.0e3)*(${tungsten_atomic_density})/(6.02e23)/(3.01604928) [gram(T)/m^2]
  []
  [Int_C_trapped_Cu]
    type = ElementIntegralVariablePostprocessor
    variable = C_trapped_Cu
    block = 3
  []
  [ScInt_C_trapped_Cu]
    type = ScalePostprocessor
    value = Int_C_trapped_Cu
    scaling_factor = 3.44e10   # (1.0e3)*(1.0e3)*(${tungsten_atomic_density})/(6.02e23)/(3.01604928) [gram(T)/m^2]
  []
  [Int_C_total_Cu]
    type = ElementIntegralVariablePostprocessor
    variable = C_total_Cu
    block = 3
  []
  [ScInt_C_total_Cu]
    type = ScalePostprocessor
    value = Int_C_total_Cu
    scaling_factor = 3.491e10   # (1.0e3)*(1.0e3)*(${tungsten_atomic_density})/(6.02e23)/(3.01604928) [gram(T)/m^2]
  []
  # ############################################################ Postprocessors for CuCrZr (block = 2)
  [Int_C_mobile_CuCrZr]
    type = ElementIntegralVariablePostprocessor
    variable = C_mobile_CuCrZr
    block = 2
  []
  [ScInt_C_mobile_CuCrZr]
    type = ScalePostprocessor
    value =  Int_C_mobile_CuCrZr
    scaling_factor = 3.491e10   # (1.0e3)*(1.0e3)*(${tungsten_atomic_density})/(6.02e23)/(3.01604928) [gram(T)/m^2]
  []
  [Int_C_trapped_CuCrZr]
    type = ElementIntegralVariablePostprocessor
    variable = C_trapped_CuCrZr
    block = 2
  []
  [ScInt_C_trapped_CuCrZr]
    type = ScalePostprocessor
    value = Int_C_trapped_CuCrZr
    scaling_factor = 3.44e10   # (1.0e3)*(1.0e3)*(${tungsten_atomic_density})/(6.02e23)/(3.01604928) [gram(T)/m^2]
  []
  [Int_C_total_CuCrZr]
    type = ElementIntegralVariablePostprocessor
    variable = C_total_CuCrZr
    block = 2
  []
  [ScInt_C_total_CuCrZr]
    type = ScalePostprocessor
    value = Int_C_total_CuCrZr
    scaling_factor = 3.491e10   # (1.0e3)*(1.0e3)*(${tungsten_atomic_density})/(6.02e23)/(3.01604928) [gram(T)/m^2]
  []
[]

[VectorPostprocessors]
  [line_tritium]
    type = LineValueSampler
    start_point = '0 14.0e-3 0'
    end_point = '0 6.0e-3 0'
    num_points = 100
    sort_by = 'y'
    variable = 'C_total_W C_total_Cu C_total_CuCrZr C_mobile_W C_mobile_Cu C_mobile_CuCrZr C_trapped_W C_trapped_Cu C_trapped_CuCrZr flux_y'
    execute_on = timestep_end
  []
[]
