!include reflection_base.i

[Mesh/gmg]
  type = GeneratedMeshGenerator
  dim = 1
  nx = 3
  xmax = 1
[]

[UserObjects]
  [initializer]
    start_points = '0.25 0 0'
    start_velocities = '1 1 1'
  []
[]

[RayBCs/reflect]
  boundary = 'left right'
[]
