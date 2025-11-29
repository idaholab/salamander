# This input file combines the input files required to run heat transfer coupled with TMAP8 for tritium transport

outputs_name = divertor_monoblock_heat_transfer_TMAP8/divertor_monoblock_heat_transfer_TMAP8

# Problem convergence set up
problem_converge_on = 'temperature C_mobile_W C_trapped_W C_mobile_Cu C_trapped_Cu C_mobile_CuCrZr C_trapped_CuCrZr'

[Problem]
  converge_on = ${problem_converge_on}
[]

!include divertor_monoblock_base.i
!include divertor_monoblock_HT_BC_no_neutronics.i
!include divertor_monoblock_TMAP8.i
