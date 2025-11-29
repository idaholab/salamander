# This is the main input file handling the multiapp between neutronics and heat transfer when neutronics is being coupled.
# it itself does not run a simulation, but calls the two subapps.
# The point of this input file structure (as opposed to have the heat transfer handle the multiapp)
# is that we call allocate different number of resources to each subapp.

!include divertor_monoblock_mesh.params
!include divertor_monoblock_mesh.i

number_processor_MOOSE = 12
number_processor_OpenMC = 488

[Problem]
  solve = false
[]

[MultiApps/heat_transfer]
  type = TransientMultiApp
  input_files = 'divertor_monoblock_HT_TMAP8_mechanics_neutronics_combine.i'
  execute_on = timestep_begin
  max_procs_per_app = ${number_processor_MOOSE}
[]

[MultiApps/neutronics]
  type = TransientMultiApp
  input_files = 'divertor_monoblock_neutronics.i'
  execute_on = timestep_begin
  max_procs_per_app = ${number_processor_OpenMC}
[]

[Transfers]
  [heat_source_to_divertor]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = neutronics
    to_multi_app = heat_transfer
    source_variable = heating_local
    variable = heating_local
    execute_on = timestep_begin
  []
  [temperature_to_openmc]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = heat_transfer
    to_multi_app = neutronics
    source_variable = temperature
    variable = temperature
    execute_on = timestep_begin
  []
[]

[Executioner]
  type = Transient
  dt = 1e50 # using a very large time so that that time limit of the main app is dictated by the other sub app.
[]

