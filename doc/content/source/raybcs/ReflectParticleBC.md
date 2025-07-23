# ReflectParticleBC

!syntax description /RayBCs/ReflectParticleBC

A [Ray.md] can only have a direction vector that has non-zero components consistent with the dimensionality of the spatial domain in which the simulation is being performed.
However, it is often useful to retain three-dimensional velocity information regardless of the dimensionality of the spatial domain.
This requires storing each component of the velocity vector as a seperate piece of `RayData` and the [ReflectRayBC.md] has no knowledge of this velocity data.
As a result it will not be updated properly by the [ReflectRayBC.md].
This boundary condition performs the same operation as [ReflectRayBC.md] and then updates the particles velocity data ensuring it is consistent with the particles direction after reflection.

# Example Input Syntax

!listing test/tests/raybcs/1d.i block=RayBCs

!syntax parameters /RayBCs/ReflectParticleBC

!syntax inputs /RayBCs/ReflectParticleBC

!syntax children /RayBCs/ReflectParticleBC

