# ------------------------------------------------------------------------------
# MESH REFINEMENT
# ------------------------------------------------------------------------------
max_size_r = 0.1
max_size_azimuthal = 0.1
max_size_z = 0.05

size_r = ${max_size_r}
size_azimuthal = ${max_size_azimuthal}
size_z = ${max_size_z}

# ------------------------------------------------------------------------------
# FIXED GEOMETRY: POSITION AND OUTER ENVELOPES
# ------------------------------------------------------------------------------
translate_x = -0.12884753
translate_y = -0.21039937

polygon_num_sides = 6
cos30 = 0.86602540378443864676

R_max = 0.5625
small_hex_apothem = 0.563
large_hex_apothem = 0.649086040
outer_circle_radius = 0.75

# Derived dimensions used only to estimate maximum radial/tangential sizes.
small_hex_vertex = ${fparse small_hex_apothem / cos30}
large_hex_vertex = ${fparse large_hex_apothem / cos30}
hex_side_length = ${large_hex_vertex}

# ------------------------------------------------------------------------------
# AZIMUTHAL DISCRETIZATION
# ------------------------------------------------------------------------------
m_azimuthal = ${fparse hex_side_length / size_azimuthal}
n_sectors_per_side = ${fparse 2 * ceil(m_azimuthal / 2)} # to get even count

# ------------------------------------------------------------------------------
# FIXED RADIAL GEOMETRY BREAKPOINTS
# ------------------------------------------------------------------------------
# material and topology interfaces
r00 = 0
r01 = 0.03125
r02 = 0.09
r03 = 0.125
r04 = 0.126590946
r05 = 0.175
r06 = 0.215
r07 = 0.25
r08 = 0.34
r09 = 0.375
r10 = 0.42
r11 = 0.4375
r12 = 0.5
r13 = 0.5125
r14 = 0.5285
r15 = ${R_max}

# Actual intervals in each mandatory radial region.
n_ring_01 = ${fparse ceil((r01 - r00) / size_r)}
n_ring_02 = ${fparse ceil((r02 - r01) / size_r)}
n_ring_03 = ${fparse ceil((r03 - r02) / size_r)}
n_ring_04 = ${fparse ceil((r04 - r03) / size_r)}
n_ring_05 = ${fparse ceil((r05 - r04) / size_r)}
n_ring_06 = ${fparse ceil((r06 - r05) / size_r)}
n_ring_07 = ${fparse ceil((r07 - r06) / size_r)}
n_ring_08 = ${fparse ceil((r08 - r07) / size_r)}
n_ring_09 = ${fparse ceil((r09 - r08) / size_r)}
n_ring_10 = ${fparse ceil((r10 - r09) / size_r)}
n_ring_11 = ${fparse ceil((r11 - r10) / size_r)}
n_ring_12 = ${fparse ceil((r12 - r11) / size_r)}
n_ring_13 = ${fparse ceil((r13 - r12) / size_r)}
n_ring_14 = ${fparse ceil((r14 - r13) / size_r)}
n_ring_15 = ${fparse ceil((r15 - r14) / size_r)}

# The circle-to-small-hex and large-hex-to-circle regions approach only
# 0.0005 in thickness at their tangent directions.  Keep one layer in those
# two transition regions even when max_size_r is reduced; otherwise very thin
# elements can be created.  The true hex-to-hex duct remains size controlled.
n_background = 1
n_duct = ${fparse ceil((large_hex_vertex - small_hex_vertex) / size_r)}
n_peripheral = 1

# ------------------------------------------------------------------------------
# FIXED AXIAL GEOMETRY BREAKPOINTS
# ------------------------------------------------------------------------------
z00 = -9.015017
z01 = -8.595016
z02 = -8.195017
z03 = 8.354983
z04 = 9.104983
z05 = 9.354983
z06 = 9.604983
z07 = 9.634983
z08 = 10.207480
z09 = 10.238730
z10 = 10.404980
z11 = 10.554980
z12 = 10.754980
z13 = 10.794980
z14 = 10.854980
z15 = 11.066860
z16 = 11.082480
z17 = 11.254980
z18 = 11.354980
z19 = 11.394980
z20 = 11.457480

# Derived extrusion heights and layer counts.
h01 = ${fparse z01 - z00}
h02 = ${fparse z02 - z01}
h03 = ${fparse z03 - z02}
h04 = ${fparse z04 - z03}
h05 = ${fparse z05 - z04}
h06 = ${fparse z06 - z05}
h07 = ${fparse z07 - z06}
h08 = ${fparse z08 - z07}
h09 = ${fparse z09 - z08}
h10 = ${fparse z10 - z09}
h11 = ${fparse z11 - z10}
h12 = ${fparse z12 - z11}
h13 = ${fparse z13 - z12}
h14 = ${fparse z14 - z13}
h15 = ${fparse z15 - z14}
h16 = ${fparse z16 - z15}
h17 = ${fparse z17 - z16}
h18 = ${fparse z18 - z17}
h19 = ${fparse z19 - z18}
h20 = ${fparse z20 - z19}

n_z_01 = ${fparse ceil(h01 / size_z)}
n_z_02 = ${fparse ceil(h02 / size_z)}
n_z_03 = ${fparse ceil(h03 / size_z)}
n_z_04 = ${fparse ceil(h04 / size_z)}
n_z_05 = ${fparse ceil(h05 / size_z)}
n_z_06 = ${fparse ceil(h06 / size_z)}
n_z_07 = ${fparse ceil(h07 / size_z)}
n_z_08 = ${fparse ceil(h08 / size_z)}
n_z_09 = ${fparse ceil(h09 / size_z)}
n_z_10 = ${fparse ceil(h10 / size_z)}
n_z_11 = ${fparse ceil(h11 / size_z)}
n_z_12 = ${fparse ceil(h12 / size_z)}
n_z_13 = ${fparse ceil(h13 / size_z)}
n_z_14 = ${fparse ceil(h14 / size_z)}
n_z_15 = ${fparse ceil(h15 / size_z)}
n_z_16 = ${fparse ceil(h16 / size_z)}
n_z_17 = ${fparse ceil(h17 / size_z)}
n_z_18 = ${fparse ceil(h18 / size_z)}
n_z_19 = ${fparse ceil(h19 * 5 / size_z)}
n_z_20 = ${fparse ceil(h20 / size_z)}

# ------------------------------------------------------------------------------
# FIXED IDS, NAMES, AND GENERATOR SETTINGS
# ------------------------------------------------------------------------------
ring_block_ids_list = '1000 1001 1002 1003 1004 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014'
background_block_id = 1015
duct_block_ids_list = '1016'
peripheral_block_id = 1017
void_block_id = 9999

base_external_boundary_id = 10000
outer_external_boundary_id = 10001
bottom_boundary_name = z_min_cut
top_boundary_name = z_max_target_end
cut_boundary_name = generated_cut_surfaces

volume_block_ids_list = '5 6 7 8 9 15 16 17'
volume_block_names_list = 'vol5 vol6 vol7 vol8 vol9 vol15 vol16 vol17'
extrusion_direction = '0 0 1'


# ------------------------------------------------------------------------------
# FIXED SIDESET SELECTION VALUES
# ------------------------------------------------------------------------------
sideset_selection_epsilon = 1e-6

cooling_channel_vol5_split_radius_sq = ${fparse 0.25 * (r02 + r04) * (r02 + r04)}
cooling_channel_vol6_split_radius_sq = ${fparse 0.25 * (r06 + r07) * (r06 + r07)}
cooling_channel_vol7_split_radius_sq = ${fparse 0.25 * (r08 + r09) * (r08 + r09)}

# ------------------------------------------------------------------------------
# FIXED AXIAL SUBDOMAIN MAP
# ------------------------------------------------------------------------------
# swap_01: z00 -> z01; active volumes: vol5
swap_01 = '1000 9999 1001 9999 1002 5 1003 5 1004 9999 1005 9999 1006 9999 1007 9999 1008 9999 1009 9999 1010 9999 1011 9999 1012 9999 1013 9999 1014 9999 1015 9999 1016 9999 1017 9999'
# swap_02: z01 -> z02; active volumes: vol5, vol6
swap_02 = '1000 9999 1001 9999 1002 5 1003 5 1004 9999 1005 9999 1006 6 1007 9999 1008 9999 1009 9999 1010 9999 1011 9999 1012 9999 1013 9999 1014 9999 1015 9999 1016 9999 1017 9999'
# swap_03: z02 -> z03; active volumes: vol5, vol6, vol7
swap_03 = '1000 9999 1001 9999 1002 5 1003 5 1004 9999 1005 9999 1006 6 1007 9999 1008 7 1009 9999 1010 9999 1011 9999 1012 9999 1013 9999 1014 9999 1015 9999 1016 9999 1017 9999'
# swap_04: z03 -> z04; active volumes: vol5, vol6, vol7, vol8
swap_04 = '1000 9999 1001 9999 1002 5 1003 5 1004 9999 1005 9999 1006 6 1007 9999 1008 7 1009 8 1010 8 1011 8 1012 9999 1013 9999 1014 9999 1015 9999 1016 9999 1017 9999'
# swap_05: z04 -> z05; active volumes: vol5, vol6, vol8
swap_05 = '1000 9999 1001 9999 1002 5 1003 5 1004 9999 1005 9999 1006 6 1007 9999 1008 8 1009 8 1010 8 1011 8 1012 8 1013 8 1014 8 1015 8 1016 9999 1017 9999'
# swap_06: z05 -> z06; active volumes: vol5, vol6, vol8, vol9
swap_06 = '1000 9999 1001 9999 1002 5 1003 5 1004 9 1005 9999 1006 6 1007 9999 1008 8 1009 8 1010 8 1011 8 1012 8 1013 8 1014 8 1015 8 1016 9999 1017 9999'
# swap_07: z06 -> z07; active volumes: vol5, vol6, vol8, vol9
swap_07 = '1000 9999 1001 9999 1002 5 1003 5 1004 9 1005 9999 1006 6 1007 9999 1008 8 1009 8 1010 8 1011 8 1012 8 1013 8 1014 8 1015 9999 1016 9999 1017 9999'
# swap_08: z07 -> z08; active volumes: vol6, vol8, vol9
swap_08 = '1000 9999 1001 9999 1002 9 1003 9 1004 9 1005 9999 1006 6 1007 9999 1008 8 1009 8 1010 8 1011 8 1012 8 1013 8 1014 8 1015 9999 1016 9999 1017 9999'
# swap_09: z08 -> z09; active volumes: vol6, vol8, vol9, vol15
swap_09 = '1000 9999 1001 9999 1002 9 1003 9 1004 9 1005 9999 1006 6 1007 9999 1008 8 1009 8 1010 8 1011 8 1012 8 1013 8 1014 8 1015 15 1016 15 1017 15'
# swap_10: z09 -> z10; active volumes: vol6, vol8, vol9, vol15
swap_10 = '1000 9999 1001 9999 1002 9 1003 9 1004 9 1005 9999 1006 6 1007 9999 1008 8 1009 8 1010 8 1011 8 1012 8 1013 8 1014 8 1015 15 1016 15 1017 15'
# swap_11: z10 -> z11; active volumes: vol8, vol9, vol15
swap_11 = '1000 9999 1001 9999 1002 9 1003 9 1004 9 1005 9999 1006 9999 1007 9999 1008 8 1009 8 1010 8 1011 8 1012 8 1013 8 1014 8 1015 15 1016 15 1017 15'
# swap_12: z11 -> z12; active volumes: vol8, vol9, vol15
swap_12 = '1000 9999 1001 9999 1002 9 1003 9 1004 9 1005 9999 1006 9999 1007 9999 1008 9 1009 9 1010 8 1011 8 1012 8 1013 8 1014 8 1015 15 1016 15 1017 15'
# swap_13: z12 -> z13; active volumes: vol9, vol15
swap_13 = '1000 9999 1001 9999 1002 9 1003 9 1004 9 1005 9 1006 9 1007 9 1008 9 1009 9 1010 9 1011 9 1012 9999 1013 9999 1014 15 1015 15 1016 15 1017 15'
# swap_14: z13 -> z14; active volumes: vol9, vol15
swap_14 = '1000 9999 1001 9999 1002 9 1003 9 1004 9 1005 9 1006 9 1007 9 1008 9 1009 9 1010 9 1011 9 1012 9999 1013 15 1014 15 1015 15 1016 15 1017 15'
# swap_15: z14 -> z15; active volumes: vol15, vol16
swap_15 = '1000 9999 1001 9999 1002 16 1003 16 1004 16 1005 16 1006 16 1007 16 1008 16 1009 16 1010 16 1011 16 1012 9999 1013 15 1014 15 1015 15 1016 15 1017 15'
# swap_16: z15 -> z16; active volumes: vol15, vol16
swap_16 = '1000 9999 1001 9999 1002 16 1003 16 1004 16 1005 16 1006 16 1007 16 1008 16 1009 16 1010 16 1011 16 1012 9999 1013 15 1014 15 1015 15 1016 15 1017 15'
# swap_17: z16 -> z17; active volumes: vol15, vol16
swap_17 = '1000 9999 1001 9999 1002 16 1003 16 1004 16 1005 16 1006 16 1007 16 1008 16 1009 16 1010 16 1011 16 1012 9999 1013 15 1014 15 1015 15 1016 15 1017 9999'
# swap_18: z17 -> z18; active volumes: vol15, vol16
swap_18 = '1000 9999 1001 16 1002 16 1003 16 1004 16 1005 16 1006 16 1007 16 1008 16 1009 16 1010 16 1011 16 1012 9999 1013 15 1014 15 1015 15 1016 15 1017 9999'
# swap_19: z18 -> z19; active volumes: vol15, vol17
swap_19 = '1000 17 1001 17 1002 17 1003 17 1004 17 1005 17 1006 17 1007 17 1008 17 1009 17 1010 17 1011 17 1012 9999 1013 15 1014 15 1015 15 1016 15 1017 9999'
# swap_20: z19 -> z20; active volumes: vol15
swap_20 = '1000 9999 1001 9999 1002 9999 1003 9999 1004 9999 1005 9999 1006 9999 1007 9999 1008 9999 1009 9999 1010 9999 1011 15 1012 15 1013 15 1014 15 1015 15 1016 15 1017 9999'

[Mesh]
  [base_2d]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = ${polygon_num_sides}
    num_sectors_per_side = '${n_sectors_per_side} ${n_sectors_per_side} ${n_sectors_per_side} ${n_sectors_per_side} ${n_sectors_per_side} ${n_sectors_per_side}'
    flat_side_up = true

    polygon_size_style = apothem
    polygon_size = ${large_hex_apothem}

    ring_radii = '${r01} ${r02} ${r03} ${r04} ${r05} ${r06} ${r07} ${r08} ${r09} ${r10} ${r11} ${r12} ${r13} ${r14} ${r15}'
    ring_intervals = '${n_ring_01} ${n_ring_02} ${n_ring_03} ${n_ring_04} ${n_ring_05} ${n_ring_06} ${n_ring_07} ${n_ring_08} ${n_ring_09} ${n_ring_10} ${n_ring_11} ${n_ring_12} ${n_ring_13} ${n_ring_14} ${n_ring_15}'
    ring_block_ids = '${ring_block_ids_list}'

    background_intervals = ${n_background}
    background_block_ids = ${background_block_id}

    duct_sizes_style = apothem
    duct_sizes = '${small_hex_apothem}'
    duct_intervals = '${n_duct}'
    duct_block_ids = '${duct_block_ids_list}'

    preserve_volumes = off
    quad_center_elements = true
    external_boundary_id = ${base_external_boundary_id}
  []

  [large_hex_to_outer_circle]
    type = PeripheralRingMeshGenerator
    input = base_2d
    peripheral_ring_block_id = ${peripheral_block_id}
    peripheral_layer_num = ${n_peripheral}
    input_mesh_external_boundary = ${base_external_boundary_id}
    peripheral_ring_radius = ${outer_circle_radius}
    external_boundary_id = ${outer_external_boundary_id}
    preserve_volumes = off
  []

  [extrude]
    type = AdvancedExtruderGenerator
    input = large_hex_to_outer_circle
    heights = '${h01} ${h02} ${h03} ${h04} ${h05} ${h06} ${h07} ${h08} ${h09} ${h10} ${h11} ${h12} ${h13} ${h14} ${h15} ${h16} ${h17} ${h18} ${h19} ${h20}'
    num_layers = '${n_z_01} ${n_z_02} ${n_z_03} ${n_z_04} ${n_z_05} ${n_z_06} ${n_z_07} ${n_z_08} ${n_z_09} ${n_z_10} ${n_z_11} ${n_z_12} ${n_z_13} ${n_z_14} ${n_z_15} ${n_z_16} ${n_z_17} ${n_z_18} ${n_z_19} ${n_z_20}'
    biases = '1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1'
    direction = '${extrusion_direction}'
    bottom_boundary = ${bottom_boundary_name}
    top_boundary = ${top_boundary_name}

    # temporary_2D_block_id final_volume_block_id pairs by axial interval
    subdomain_swaps = '${swap_01};
                         ${swap_02};
                         ${swap_03};
                         ${swap_04};
                         ${swap_05};
                         ${swap_06};
                         ${swap_07};
                         ${swap_08};
                         ${swap_09};
                         ${swap_10};
                         ${swap_11};
                         ${swap_12};
                         ${swap_13};
                         ${swap_14};
                         ${swap_15};
                         ${swap_16};
                         ${swap_17};
                         ${swap_18};
                         ${swap_19};
                         ${swap_20}'
  []

  [delete_void]
    type = BlockDeletionGenerator
    input = extrude
    block = '${void_block_id}'
    new_boundary = ${cut_boundary_name}
  []

  [name_volume_blocks]
    type = RenameBlockGenerator
    input = delete_void
    old_block = '${volume_block_ids_list}'
    new_block = '${volume_block_names_list}'
  []

  [to_stl_coordinates]
    type = TransformGenerator
    input = name_volume_blocks
    transform = TRANSLATE
    vector_value = '${translate_x} ${translate_y} ${z00}'
  []

  [vol17_exposed_target]
    type = SideSetsAroundSubdomainGenerator
    input = to_stl_coordinates
    block = vol17
    new_boundary = vol17_exposed_target
    normal = '0 0 1'
    normal_tol = 1e-6
    fixed_normal = true
    include_only_external_sides = true
  []

  [target_heat_flux]
    type = ParsedGenerateSideset
    input = vol17_exposed_target
    combinatorial_geometry = '1 > 0'
    included_boundaries = '${top_boundary_name} vol17_exposed_target'
    included_subdomains = 'vol15 vol17'
    include_only_external_sides = true
    normal = '0 0 1'
    normal_tol = 1e-6
    fixed_normal = true
    new_sideset_name = target_heat_flux
  []

  [vol17_to_vol15_interface]
    type = SideSetsBetweenSubdomainsGenerator
    input = target_heat_flux
    primary_block = vol17
    paired_block = vol15
    new_boundary = vol17_to_vol15_interface
  []

  [cooling_channel_vol5]
    type = ParsedGenerateSideset
    input = vol17_to_vol15_interface
    combinatorial_geometry = '(x-x0)^2 + (y-y0)^2 < rsplit2 & z > zlo+eps & z < zhi-eps'
    constant_names = 'x0 y0 rsplit2 zlo zhi eps'
    constant_expressions = '${translate_x} ${translate_y} ${cooling_channel_vol5_split_radius_sq} ${z00} ${z07} ${sideset_selection_epsilon}'
    included_boundaries = '${cut_boundary_name}'
    included_subdomains = vol5
    include_only_external_sides = true
    new_sideset_name = cooling_channel_vol5
  []

  [cooling_channel_vol6]
    type = ParsedGenerateSideset
    input = cooling_channel_vol5
    combinatorial_geometry = '(x-x0)^2 + (y-y0)^2 < rsplit2 & z > zlo+eps & z < zhi-eps'
    constant_names = 'x0 y0 rsplit2 zlo zhi eps'
    constant_expressions = '${translate_x} ${translate_y} ${cooling_channel_vol6_split_radius_sq} ${z01} ${z10} ${sideset_selection_epsilon}'
    included_boundaries = '${cut_boundary_name}'
    included_subdomains = vol6
    include_only_external_sides = true
    new_sideset_name = cooling_channel_vol6
  []

  [cooling_channel_vol7]
    type = ParsedGenerateSideset
    input = cooling_channel_vol6
    combinatorial_geometry = '(x-x0)^2 + (y-y0)^2 < rsplit2 & z > zlo+eps & z < zhi-eps'
    constant_names = 'x0 y0 rsplit2 zlo zhi eps'
    constant_expressions = '${translate_x} ${translate_y} ${cooling_channel_vol7_split_radius_sq} ${z02} ${z04} ${sideset_selection_epsilon}'
    included_boundaries = '${cut_boundary_name}'
    included_subdomains = vol7
    include_only_external_sides = true
    new_sideset_name = cooling_channel_vol7
  []

  [cooling_channel_vol5_outer]
    type = ParsedGenerateSideset
    input = cooling_channel_vol7
    combinatorial_geometry = '(x-x0)^2 + (y-y0)^2 > rsplit2 & z > zlo+eps & z < zhi-eps'
    constant_names = 'x0 y0 rsplit2 zlo zhi eps'
    constant_expressions = '${translate_x} ${translate_y} ${cooling_channel_vol5_split_radius_sq} ${z00} ${z07} ${sideset_selection_epsilon}'
    included_boundaries = '${cut_boundary_name}'
    included_subdomains = vol5
    include_only_external_sides = true
    new_sideset_name = cooling_channel_vol5_outer
  []

  [cooling_channel_vol6_outer]
    type = ParsedGenerateSideset
    input = cooling_channel_vol5_outer
    combinatorial_geometry = '(x-x0)^2 + (y-y0)^2 > rsplit2 & z > zlo+eps & z < zhi-eps'
    constant_names = 'x0 y0 rsplit2 zlo zhi eps'
    constant_expressions = '${translate_x} ${translate_y} ${cooling_channel_vol6_split_radius_sq} ${z01} ${z10} ${sideset_selection_epsilon}'
    included_boundaries = '${cut_boundary_name}'
    included_subdomains = vol6
    include_only_external_sides = true
    new_sideset_name = cooling_channel_vol6_outer
  []

  [cooling_channel_vol7_outer]
    type = ParsedGenerateSideset
    input = cooling_channel_vol6_outer
    combinatorial_geometry = '(x-x0)^2 + (y-y0)^2 > rsplit2 & z > zlo+eps & z < zhi-eps'
    constant_names = 'x0 y0 rsplit2 zlo zhi eps'
    constant_expressions = '${translate_x} ${translate_y} ${cooling_channel_vol7_split_radius_sq} ${z02} ${z04} ${sideset_selection_epsilon}'
    included_boundaries = '${cut_boundary_name}'
    included_subdomains = vol7
    include_only_external_sides = true
    new_sideset_name = cooling_channel_vol7_outer
  []

  [split_generated_cut_surfaces]
    type = BreakBoundaryOnSubdomainGenerator
    input = cooling_channel_vol7_outer
    boundaries = '${cut_boundary_name}'
    show_info = true
  []
[]
