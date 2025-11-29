# This is the input file defining the heat transfer boundary conditions when neutronics is being coupled.
# The heat source is described as a volumetric heat source and not as a top heat source (as is done with divertor_monoblock_HT_BC_no_neutronics.i).
# This complements divertor_monoblock_base.i

[AuxVariables]
  [heating_local]
    order = CONSTANT
    family = MONOMIAL
    block = '2 3 4'
    initial_condition = 1e7
  []
  [time_dep_heating_local]
    order = CONSTANT
    family = MONOMIAL
    block = '2 3 4'
    initial_condition = 0.0
  []
[]

[Kernels]
  [heating_local_W]
    type = CoupledForce
    variable = temperature
    v = time_dep_heating_local
    block = 4
  []
  [heating_local_Cu]
    type = CoupledForce
    variable = temperature
    v = time_dep_heating_local
    block = 3
  []
  [heating_local_CuCrZr]
    type = CoupledForce
    variable = temperature
    v = time_dep_heating_local
    block = 2
  []
[]

[AuxKernels]
  [heating_local_t]
    type = ParsedAux
    variable = time_dep_heating_local
    coupled_variables = heating_local
    expression = 'heating_local * pulse_func'
    functor_names = 'pulse_func'
  []
[]

[Functions]
  ### pulse func (to be multiplied by heating_local)
  [pulse_func]
    type = ParsedFunction
    expression =   'if((t % 1600) < 100.0, 0.0 + 1.0*(t % 1600)/100,
                    if((t % 1600) < 500.0, 1.0,
                    if((t % 1600) < 600.0, 1.0 - 1.0*((t % 1600)-500)/100, 0.0)))'
  []
[]
