# CAD-based Geometry Workflow for Multiphysics Fusion neutronics Problems Using SALAMANDER

This example describes a workflow for modeling fusion problems in SALAMANDER through [Cardinal](https://cardinal.cels.anl.gov/) which wraps OpenMC Monte Carlo particle transport code within [MOOSE framework](https://mooseframework.inl.gov) framework [!citep](giudicelli2024moose). This example demonstrates using a computer aided design (CAD)-based geometry workflow. It is based on the work published in [!cite](Eltawila2024PBNC).

Fusion system designs are complex and require intricate and accurate models that can be best represented using CAD-based geometry. Fusion neutronics models frequently leverage on CAD based geometries. An example is the Paramak python package [!citep](shimwell2021paramak) which allows production of 3D CAD models of fusion reactors. The model shown in [paramak] is based on the same generic workflow described in this tutorial.

!media figures/cad_workflow_paramakmodel.png
  id=paramak
  caption=Tokamak model based on CAD generated with Paramak package.
  style=display:block;margin-left:auto;margin-right:auto;width:30%;

The results of the coupled neutronics and heat transfer model are shown in [tokamak_temperatures] and [tokamak_tritium_production] for the temperature distribution and tritium production rate density.

!row! style=display:inline-flex;
!col! small=12 medium=4 large=3
!media figures/cad_workflow_tokamak_temps.png
  id=tokamak_temperatures
  caption=Example Paramak tokamak model temperature distribution result.
  style=display:block;margin-left:auto;margin-right:auto;width:130%;

!col-end!

!col! small=12 medium=4 large=3
!media figures/cad_workflow_tokamak_tritium_production.png
  id=tokamak_tritium_production
  caption=Example Paramak tokamak model tritium production rate density result.
  style=display:block;margin-left:auto;margin-right:auto;width:130%;

!col-end!
!row-end!

This example demonstrates, on a simple but extensive mesh, how to:

- Generate meshes for a coupled multiphysics SALAMANDER model.
- Couple OpenMC [!citep](openmc) and SALAMANDER using Cardinal for fixed source Monte Carlo calculations.
- Use Cardinal [!citep](novak2022_cardinal) to tally values of interest such as tritium production and heating which would be used in SALAMANDER to solve for the temperature and tritium distributions.

We describe this workflow for a generic CAD model which is extremely simplified for the purpose of the demonstration. Nonetheless, the same workflow is applicable to more complex CAD geometries. This model was also used in [!cite](Eltawila2024PBNC) to perform mesh refinement studies to investigate how the mesh refinement level affects multiphysics results. The meshed geometry was prepared using direct accelerated geometry Monte Carlo (DAGMC) for particle transport, and a volumetric mesh was also prepared to be used in SALAMANDER’s finite element solver and to tally OpenMC results for heat source distribution and tritium production. Cardinal was used to run OpenMC Monte Carlo particle transport within SALAMANDER. The data transfer system transferred heat source and temperature distribution between OpenMC and SALAMANDER as shown in [transfers], with coupling between neutron transport and heat conduction achieved via Picard iteration.

!media figures/cad_workflow_transfers.png
  id=transfers
  caption=Illustration of OpenMC and MOOSE coupling.
  style=display:block;margin-left:auto;margin-right:auto;width:80%;

## Generating the meshes

The CAD model was first developed in FUSION360 and was imported into Cubit to assign blocks, materials, and side sets and generate the mesh ([volumetric_mesh]). A corresponding DAGMC surface mesh ([DAGMC_mesh]) was exported directly from the meshed geometry in Cubit (by loading the volumetric meshed geometry in Cubit and exporting a DAGMC surface mesh).

In this example, `tmesh_1.e` ([volumetric_mesh]) is the finite element mesh used in SALAMANDER on which the heat transfer physics is solved. `tmesh_1.h5m` ([DAGMC_mesh]) is the DAGMC surface mesh used for particle transport in OpenMC (which bounds the surfaces between different materials). Cardinal also allows for mesh tallying for tallying OpenMC results directly on the mesh overlayed on the OpenMC geometry which `tmesh_1.e` ([volumetric_mesh]) could be used for as well as an unstructured volume mesh. This could be used by changing the tally type and adding a mesh template (`tally_type = mesh`, `mesh_template = tmesh_1.e`) in Cardinal Tally blocks.

&nbsp;

!row! style=display:inline-flex;
!col! small=12 medium=4 large=3

!media figures/cad_workflow_mesh_1.png
  id=volumetric_mesh
  caption=Model volumetric mesh.
  style=display:block;margin-left:auto;margin-right:auto;width:130%;

!col-end!

!col! small=12 medium=4 large=3

!media figures/cad_workflow_d1.png
  id=DAGMC_mesh
  caption=Model DAGMC mesh.
  style=display:block;margin-left:auto;margin-right:auto;width:130%;

!col-end!
!row-end!

## OpenMC

The OpenMC input files is as follows:

!listing /test/tests/neutronics/cad_workflow/model.py language=python

## Cardinal

The Cardinal input files is shown below. The ([MoabSkinner](https://cardinal.cels.anl.gov/source/userobjects/MoabSkinner.html)) was chosen in this model to update the DAGMC geometry from SALAMANDER mesh directly ensuring meshes matching which is further discussed in [!cite](Eltawila2024PBNC) as well as the use of cell tallies.

!listing /test/tests/neutronics/cad_workflow/openmc.i

## SALAMANDER (MOOSE) Heat Transfer

The SALAMANDER input file is as follows:

!listing /test/tests/neutronics/cad_workflow/solid.i

## Execution

To generate OpenMC xml files, run:

```
python model.py
```

Then to run the coupled calculation:

```
mpiexec -np 2 salamander-opt -i solid.i --n-threads=2
```

This will run SALAMANDER with 2 MPI processes and 2 OpenMP threads per rank. To run the simulation faster, you can increase the parallel processes/threads, or simply decrease the number of particles used in OpenMC. When the simulation has completed, you will have created a number of different output files:

- `solid_out.e`, an Exodus output with the solid mesh and solution from the MOOSE/SALAMANDER input file.
- `solid_out_openmc0.e`, an Exodus output with the OpenMC solution and the data that was ultimately transferred in/out of OpenMC.

## Results

&nbsp;

The results of this simulation on the finest mesh are shown in [temperatures], [tritium_production], and [results]. More information, including a mesh sensitivity study, is available in [!cite](Eltawila2024PBNC).

&nbsp;

!row! style=display:inline-flex;
!col! small=12 medium=4 large=3

!media figures/cad_workflow_Temps.png
  id=temperatures
  caption=Temperature distribution result from [!cite](Eltawila2024PBNC).
  style=display:block;margin-left:auto;margin-right:auto;width:130%;

!col-end!

!col! small=12 medium=4 large=3

!media figures/cad_workflow_tritium_production.png
  id=tritium_production
  caption=Tritium production rate density result from [!cite](Eltawila2024PBNC).
  style=display:block;margin-left:auto;margin-right:auto;width:130%;

!col-end!
!row-end!

&nbsp;

!table id=results caption=Summary of the results from the coupled simulation published in [!cite](Eltawila2024PBNC).
| Parameter (Units) | Value | Units |
| :- | :- | :- |
| Armor Max. Temp.          | $1062.4$                                   | `[K]`      |
| First Wall Max. Temp.     | $1057.6$                                   | `[K]`      |
| Breeder Max. Temp.        | $987.4$                                    | `[K]`      |
| Heat Source               | $2.44 \times 10^5 \pm 3 \times 10^3$       | `[W]`      |
| Tritium Production.       | $4.70 \times 10^{13} \pm 8 \times 10^{11}$ | `[atoms/s]`|

&nbsp;
