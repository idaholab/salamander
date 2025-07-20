!include reflection_base.i

[Mesh/gmg]
  type = GeneratedMeshGenerator
  dim = 3
  nx = 3
  ny = 3
  nz = 3
  xmax = 1
  ymax = 1
  zmax = 1
[]

[UserObjects]
  [initializer]
    start_points = '0.165 0.835 0.165
                    0.5 0.5 0.5
                    0.5 0.5 0.5
                    0.5 0.5 0.5'
    start_velocities = '1 1 1
                        1 0 0
                        0 1 0
                        0 0 1'
  []
[]

[RayBCs/reflect]
  boundary = 'left right top bottom front back'
[]
