!include reflection_base.i

[Mesh/gmg]
  type = GeneratedMeshGenerator
  dim = 2
  nx = 3
  ny = 3
  xmax = 1
  ymax = 1
[]


[UserObjects]
  [initializer]
    start_points = '0.25 0.75 0
                    0.5 0.5 0
                    0.5 0.5 0'
    start_velocities = '1 1 1
                        1 0 1
                        0 1 1'
  []
[]



[RayBCs/reflect]
  boundary = 'left right top bottom'
[]
