# This input file combines the input files required to run heat transfer coupled with thermomechanics

# Outputs
outputs_name = divertor_monoblock_heat_transfer_mechanics/divertor_monoblock_heat_transfer_mechanics

# Problem convergence set up
problem_converge_on = 'disp_x disp_y disp_z temperature'

[Problem]
  converge_on = ${problem_converge_on}
[]

!include divertor_monoblock_base.i
!include divertor_monoblock_HT_BC_no_neutronics.i
!include divertor_monoblock_mechanics.i
