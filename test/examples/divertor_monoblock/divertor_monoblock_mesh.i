# This is the input file for the mesh of the divertor monoblock.

# Geometry
radius_1 = ${units 6 mm -> m}
radius_2 = ${units 7.5 mm -> m}
radius_3 = ${units 8.5 mm -> m}
pitch = ${units 28 mm -> m}

[Mesh]
  [ccmg]
    type = ConcentricCircleMeshGenerator
    num_sectors = 36
    rings = ${rings}
    radii = '${radius_1} ${radius_2} ${radius_3}'
    has_outer_square = on
    pitch = ${pitch}
    portion = left_half
    preserve_volumes = false
    smoothing_max_it = 3
  []
  [ccmg_extrude]
    type = AdvancedExtruderGenerator
    input = ccmg
    direction = '0 0 1'
    heights = '${thickness_monoblock}'
    num_layers = '${num_layer_mesh_thickness}'
  []
  [ssbsg1]
    type = SideSetsBetweenSubdomainsGenerator
    input = ccmg_extrude
    primary_block = '4'   # W
    paired_block = '3'    # Cu
    new_boundary = '4to3'
  []
  [ssbsg2]
    type = SideSetsBetweenSubdomainsGenerator
    input = ssbsg1
    primary_block = '3'   # Cu
    paired_block = '4'    # W
    new_boundary = '3to4'
  []
  [ssbsg3]
    type = SideSetsBetweenSubdomainsGenerator
    input = ssbsg2
    primary_block = '3'   # Cu
    paired_block = '2'    # CuCrZr
    new_boundary = '3to2'
  []
  [ssbsg4]
    type = SideSetsBetweenSubdomainsGenerator
    input = ssbsg3
    primary_block = '2'   # CuCrZr
    paired_block = '3'    # Cu
    new_boundary = '2to3'
  []
  [ssbsg5]
    type = SideSetsBetweenSubdomainsGenerator
    input = ssbsg4
    primary_block = '2'   # CuCrZr
    paired_block = '1'    # H2O
    new_boundary = '2to1'
  []
  [bdg]
    type = BlockDeletionGenerator
    input = ssbsg5
    block = '1'       # H2O
  []
[]
