# SALAMANDER Simulation of a ITER-like Divertor Monoblock

## Case overview

This case extends the case described in [!cite](Shimada2024114438) and available in [TMAP8 as an example case](TMAP8/doc/content/examples/divertor_monoblock/index.md).
The original case models heat conduction and tritium transport in a 2D representation of an ITER-like divertor monoblock.

In this case, we first reproduce the same simulation in 3D, and then introduce new physics available in SALAMANDER such as thermomechanics and neutronics via the coupling with Cardinal and OpenMC.
Although this effort is a demonstration case and these simulation are not validated (this is left to future work), we investigate the interactions between the different physics, and illustrate how single-physics simulations can be limited in some cases.

## Geometry and Mesh


`divertor_monoblock_mesh.i` and `divertor_monoblock_mesh.params`.


## Operation History and Boundary Conditions

!include /ver-1ic.md start=We simulate a 20,000-second plasma discharge end=very fine mesh and increase computational costs show-end=true


## Multiphysics configurations

In the cases below, we model different configurations of the multiphysics simulations, building the case from simple heat conduction to including tritium transport via TMAP8, thermomechanics, and neutronics.

### Heat Conduction

The input file for this case, `divertor_monoblock_HT_combine.i`, calls on `divertor_monoblock_base.i` and `divertor_monoblock_HT_BC_no_neutronics.i` using the `!include` feature to combine input files.

### Heat Conduction and Tritium Transport

The input file for this case, `divertor_monoblock_HT_TMAP8_combine.i`, calls on `divertor_monoblock_base.i`, `divertor_monoblock_HT_BC_no_neutronics.i`, and `divertor_monoblock_TMAP8.i` using the `!include` feature to combine input files.

### Heat Conduction and Thermomechanics

The input file for this case, `divertor_monoblock_HT_mechanics_combine.i`, calls on `divertor_monoblock_base.i`, `divertor_monoblock_HT_BC_no_neutronics.i`, and `divertor_monoblock_mechanics.i` using the `!include` feature to combine input files.

### Heat Conduction, Tritium Transport, and Thermomechanics

The input file for this case, `divertor_monoblock_HT_TMAP8_mechanics_combine.i`, calls on `divertor_monoblock_base.i`, `divertor_monoblock_HT_BC_no_neutronics.i`, `divertor_monoblock_TMAP8.i`, and `divertor_monoblock_mechanics.i` using the `!include` feature to combine input files.

### Heat Conduction, Tritium Transport, and Neutronics

This case couples heat conduction and tritium transport (TMAP8) with neutronics calculations via Cardinal/OpenMC. In this case, we use the MOOSE's multi-app system to couple neutronics to the other physics and transfer the desired information.

`divertor_monoblock_main_HT_TMAP8_neutronics.i` is the main input file handling the multiapp for the coupling between neutronics and the other physics.
It itself does not run a simulation, but calls the two subapps.
The point of this input file structure (as opposed to have the heat transfer handle the multiapp) is that we call allocate different number of resources to each subapp.
This is key because why the Monte Carlo neutronics calculations greatly benefits from using several processors to perform calculations in parallel,
using so many processors for the simulation handling heat conduction and tritium transport would increase inter-processor communication without accelerating the solve.

`divertor_monoblock_main_HT_TMAP8_neutronics.i` threfore calls
`divertor_monoblock_HT_TMAP8_neutronics_combine.i` for the heat conduction and tritium transport simulation
and `divertor_monoblock_neutronics.i` for the neutronics calculations.
The neutron flux calculated in the neutronics calculation is transferred to the other multiphysics simulation as a volumetric heat source term.

The input file `divertor_monoblock_HT_TMAP8_neutronics_combine.i`, calls on `divertor_monoblock_base.i`, `divertor_monoblock_HT_BC_neutronics.i`, and `divertor_monoblock_TMAP8.i` using the `!include` feature to combine input files.

### Heat Conduction, Tritium Transport, Thermomechanics, and Neutronics

This case couples heat conduction, tritium transport (TMAP8), thermomechanics with neutronics calculations via Cardinal/OpenMC. In this case, we use the MOOSE's multi-app system to couple neutronics to the other physics and transfer the desired information.

`divertor_monoblock_main_HT_TMAP8_mechanics_neutronics.i` is the main input file handling the multiapp for the coupling between neutronics and the other physics.
It itself does not run a simulation, but calls the two subapps.
Just like in the previous case, the point of this input file structure (as opposed to have the heat transfer handle the multiapp) is that we call allocate different number of resources to each subapp.

`divertor_monoblock_main_HT_TMAP8_mechanics_neutronics.i` threfore calls
`divertor_monoblock_HT_TMAP8_mechanics_neutronics_combine.i` for the heat conduction, tritium transport, and thermomechanics simulation
and `divertor_monoblock_neutronics.i` for the neutronics calculations.
The neutron flux calculated in the neutronics calculation is transferred to the other multiphysics simulation as a volumetric heat source term.

The input file `divertor_monoblock_HT_TMAP8_mechanics_neutronics_combine.i`, calls on `divertor_monoblock_base.i`, `divertor_monoblock_HT_BC_neutronics.i`, `divertor_monoblock_TMAP8.i`, and `divertor_monoblock_mechanics.i` using the `!include` feature to combine input files.




