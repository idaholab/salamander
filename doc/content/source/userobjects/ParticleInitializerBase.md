# ParticleInitializerBase

`ParticleInitializerBase` is the abstract class from which all initializers should be derived. The method `getParticleData` should be called by a [PICStudyBase.md] and will return a list of `InitialParticleData` structs which contain all of the information needed for a [PICStudyBase.md] to create and place particles in the finite element mesh.
