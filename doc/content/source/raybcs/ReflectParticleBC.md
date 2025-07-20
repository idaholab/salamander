# ReflectParticleBC

!syntax description /RayBCs/ReflectParticleBC

Since particle velocity data is stored in `RayData`, it will not be updated by [ReflectRayBC.md]. 
This boundary condition performs the same operation as [ReflectRayBC.md] and then updates the particles velocity data ensuring it is consistent with the particles direction after reflection.

# Example Input Syntax

!listing test/tests/raybcs/1d.i block=RayBCs

!syntax parameters /RayBCs/ReflectParticleBC

!syntax inputs /RayBCs/ReflectParticleBC

!syntax children /RayBCs/ReflectParticleBC

