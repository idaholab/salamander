# MultiAppMapNearestNodeTransfer

!syntax description /Transfers/MultiAppMapNearestNodeTransfer

## Overview

`MultiAppMapNearestNodeTransfer` is a `MultiAppConservativeTransfer` that transfers field data
between a 3D main application (e.g. a heat-conduction model of a blanket structure) and each of
its 1D Thermal Hydraulics Module (THM) sub-applications (e.g. coolant channels) using a
nearest-node search. This transfer, and the paired main/sub-application coupling strategy it
relies on (see [BlanketProblem.md]), were described and demonstrated for the outboard blanket of
the Fusion Nuclear Science Facility (FNSF) in [!citep](Kong2022).

A naive nearest-node search must check every node on the receiving side's mesh for every source
node, which becomes both slow and, in a parallel simulation, unreliable once a mesh is split
across MPI ranks: the true nearest node may live on a neighboring processor whose local bounding
box does not appear to be a candidate. As described in [!citep](Kong2022), a fusion blanket may
have hundreds of individual coolant channels sharing the same 3D domain, which makes a naive
global nearest-node search over the full 3D mesh especially expensive.

`MultiAppMapNearestNodeTransfer` addresses this by explicitly pairing each sub-application with
the specific `source_boundary`/`target_boundary` of the main application it corresponds to
(using `BlanketProblem::getMasterBoundaryName()` on the sub-application), so the nearest-node
search only needs to consider nodes on that one paired boundary rather than the entire mesh. To
keep the search reliable across MPI partitions, each processor's local bounding box is enlarged
by the `bbox_extend_factor` parameter before candidate nodes are gathered, ensuring that a true
nearest node located just across a partition boundary is not missed. When the source and target
meshes do not move between transfers, setting `fixed_meshes = true` allows the nearest-node
pairing to be computed once and cached, rather than recomputed on every call.

## Example Input File Syntax

The following main-application input file pairs several 1D THM sub-applications with boundaries
of a 3D main application via `MultiAppMapNearestNodeTransfer`, using `BlanketProblem` (see
[BlanketProblem.md]) on the sub-application side to identify which boundary each corresponds to:

!listing test/tests/transfers/multiapp_mapnearestnode_transfer/transfer_interface.i block=Transfers

!syntax parameters /Transfers/MultiAppMapNearestNodeTransfer

!syntax inputs /Transfers/MultiAppMapNearestNodeTransfer

!syntax children /Transfers/MultiAppMapNearestNodeTransfer
