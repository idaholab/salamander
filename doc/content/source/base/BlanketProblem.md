# BlanketProblem

!syntax description /Problem/BlanketProblem

## Overview

`BlanketProblem` is a specialized `FEProblem` used to couple a 1D Thermal Hydraulics Module
(THM) sub-application, representing a coolant channel, to a boundary of a 3D heat-conduction
main application, representing the surrounding blanket structure. This main/sub-application
coupling strategy, along with the paired nearest-node data transfer it enables (see
[MultiAppMapNearestNodeTransfer.md]), was described and demonstrated for the outboard blanket of
the Fusion Nuclear Science Facility (FNSF) in [!citep](Kong2022).

In a MultiApp hierarchy with one 1D THM sub-application per 3D boundary,
[MultiAppMapNearestNodeTransfer.md] needs to know which 3D boundary each sub-application
corresponds to. `BlanketProblem` provides this association: setting its `master_bdry_name`
parameter on a sub-application (typically via `cli_args` on the `MultiApps` block) records the
name of the main application's boundary that sub-application should be paired with, exposed
through `getMasterBoundaryName()`. This is a special-purpose solution; per the class's source
comments, this coupling mechanism should eventually be generalized and moved into the MOOSE
framework itself.

## Example Input File Syntax

The following sub-application input file sets `type = BlanketProblem` in its `[Problem]` block so
that the main application (see [MultiAppMapNearestNodeTransfer.md] for the corresponding
`[MultiApps]`/`[Transfers]` blocks) can associate it with the correct boundary via
`master_bdry_name`:

!listing test/tests/transfers/multiapp_mapnearestnode_transfer/transfer_power.i block=Problem

!syntax parameters /Problem/BlanketProblem

!syntax inputs /Problem/BlanketProblem

!syntax children /Problem/BlanketProblem
