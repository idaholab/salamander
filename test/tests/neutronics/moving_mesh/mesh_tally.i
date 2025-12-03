[GlobalParams]
  use_displaced_mesh = true
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  [f]
    type = GeneratedMeshGenerator
    dim = 3
    xmin = -0.05
    xmax = 0.15
    ymin = -0.05
    ymax = 0.05
    zmin = -0.05
    zmax = 0.05
    nx = 20
    ny = 10
    nz = 10
  []
  [subdomains]
    type = ParsedSubdomainIDsGenerator
    input = f
    expression = 'if (x < 0.05, 1, 2)'
  []
  [name]
    type = RenameBlockGenerator
    input = subdomains
    old_block = '1 2'
    new_block = 'left right'
  []
  [rescale]
    type = TransformGenerator
    input = name
    transform = scale
    vector_value = '100.0 100.0 100.0'
  []
  [convert_to_tet]
    type = ElementsToTetrahedronsConverter
    input = rescale
  []

  allow_renumbering = false
[]

[Problem]
  type = OpenMCCellAverageProblem
  cell_level = 0
  verbose = true
  power = 100
  skinner = moab
  temperature_blocks = 'left right'

  [Tallies]
    [heat]
      type = MeshTally
      score = 'kappa_fission'
    []
  []
[]

[AuxVariables]
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
[]

[AuxKernels]
  [disp_x]
    type = FunctionAux
    variable = disp_x
    function = disp_x
  []
  [disp_z]
    type = FunctionAux
    variable = disp_z
    function = disp_z
  []
[]

[Functions]
  [disp_x]
    type = ParsedFunction
    expression = '2.0*x'
  []
  [disp_z]
    type = ParsedFunction
    expression = '2.0*z'
  []
[]

[UserObjects]
  [moab]
    type = MoabSkinner
    verbose = true

    temperature = temp
    n_temperature_bins = 5
    temperature_min = 0.0
    temperature_max = 1000.0

    output_skins = true
  []
[]

[Postprocessors]
  [power]
    type = ElementIntegralVariablePostprocessor
    variable = kappa_fission
  []
  [max_p]
    type = ElementExtremeValue
    variable = kappa_fission
    value_type = max
  []
  [min_p]
    type = ElementExtremeValue
    variable = kappa_fission
    value_type = min
  []
[]

[Executioner]
  type = Transient
  num_steps = 2
[]

[Outputs]
  exodus = false
  csv = true
[]
