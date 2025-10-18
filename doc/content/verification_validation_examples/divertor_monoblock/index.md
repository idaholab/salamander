# SALAMANDER Simulation of a ITER-like Divertor Monoblock

## Case overview

extension of [!cite](Shimada2024114438) in 3D and with multiphysics.

## Geometry and Mesh


`divertor_monoblock_mesh.i` and `divertor_monoblock_mesh.params`.


## Operation History


## Heat Conduction

The input file for this case, `divertor_monoblock_HT_combine.i`, calls on `divertor_monoblock_base.i` and `divertor_monoblock_HT_BC_no_neutronics.i` using the `!include` feature to combine input files.

## Heat Conduction and Tritium Transport

The input file for this case, `divertor_monoblock_HT_TMAP8_combine.i`, calls on `divertor_monoblock_base.i`, `divertor_monoblock_HT_BC_no_neutronics.i`, and `divertor_monoblock_TMAP8.i` using the `!include` feature to combine input files.

## Heat Conduction and Thermomechanics

The input file for this case, `divertor_monoblock_HT_mechanics_combine.i`, calls on `divertor_monoblock_base.i`, `divertor_monoblock_HT_BC_no_neutronics.i`, and `divertor_monoblock_mechanics.i` using the `!include` feature to combine input files.

## Heat Conduction, Tritium Transport, and Thermomechanics

The input file for this case, `divertor_monoblock_HT_TMAP8_mechanics_combine.i`, calls on `divertor_monoblock_base.i`, `divertor_monoblock_HT_BC_no_neutronics.i`, `divertor_monoblock_TMAP8.i`, and `divertor_monoblock_mechanics.i` using the `!include` feature to combine input files.




