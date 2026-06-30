//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
//* confinement for Numerical Design, Engineering & Research,
//* A multiphysics application for modeling plasma facing components
//* https://github.com/idaholab/salamander
//* https://mooseframework.inl.gov/salamander
//*
//* SALAMANDER is powered by the MOOSE Framework
//* https://www.mooseframework.inl.gov
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
//*
//* Copyright 2025, Battelle Energy Alliance, LLC and North Carolina State University
//* ALL RIGHTS RESERVED
//*

#pragma once

#include "Ray.h"
#include "RayTracingStudy.h"

#include "ParticleInitializerBase.h"
class ParticleStepperBase;

struct AssignedParticleData
{
  /// the charge of the particles being created by the current initializer
  Real charge;
  /// the charge of the particles being created by the current initializer
  Real mass;
  /// the numeric value associated with a specific species this is managed by the study and not the initializers
  unsigned int species_id;
};

class PICStudyBase : public RayTracingStudy
{
public:
  PICStudyBase(const InputParameters & parameters);

  static InputParameters validParams();

  virtual void generateRays() override;

  /**
   * Method for getting the particles after they have finished tracing
   */
  const std::vector<std::shared_ptr<Ray>> & particles() const;

  /// Methods for getting the specific data that is stored on the
  /// particles in ray data
  ///@{
  const Real weight(const Ray & particle) const;
  const Real charge(const Ray & particle) const;
  const Real mass(const Ray & particle) const;
  const unsigned int species(const Ray & particle) const;
  ///@}

  /**
   * Method for getting a particles velocity as a Point
   * Each component is retrieved from ray data and given
   * back to user to make calculations easier
   * @param particle the particle
   * @param velocity the point where the particles velocity will be stored
   */
  void velocity(const Ray & particle, Point & velocity) const;
  /**
   * Method for getting a single velocity component for a particle
   * Each component is retrieved from ray data and given
   * back to user to make calculations easier
   * the value of component must be < 3
   * @param particle the particle
   * @returns the velocity component
   */
  const Real velocityComponent(const Ray & particle, const unsigned int component) const;
  /**
   * Method for updating the rays velocity data given a new velocity
   * @param particle the particle that will have its velocity updated
   * @param v the new velocity to give the ray
   */
  void setVelocity(Ray & particle, const Point & v) const;

  /**
   * Provides the numeric value assigned to a given species name provided the species name
   * @param species_name the name of the species for which you want the id
   * @returns the id that the study has assigned to the species name
   * @throws mooseError if the species_name is unknown to the study
   */
  unsigned int speciesId(const std::string & species_name) const noexcept(false);

protected:
  /// the list of all of the species ids that map to the species names
  std::vector<unsigned int> _species_ids;
  /// the names that the user assigned to each of the species in the system
  std::vector<std::string> _species_names;
  /// a list of the masses of each unique species in the system
  std::vector<Real> _species_masses;
  /// a list of the charge of each unique species in the system
  std::vector<Real> _species_charges;

  /// The banked rays to be used on the next timestep (restartable)
  std::vector<std::shared_ptr<Ray>> & _banked_rays;

  virtual void postExecuteStudy() override;
  /// Ray data for storing velocity components
  ///@{
  const std::array<RayDataIndex, 3> _velocity_indicies;
  ///@}
  /// Ray data for storing the number of real particles each ray represents
  const RayDataIndex _weight_index;
  /// Ray data for storing the charge of the particle
  const RayDataIndex _charge_index;
  /// Ray data for storing the mass of the particle
  const RayDataIndex _mass_index;
  /// Ray data for storing the type of physical particle a ray represents
  const RayDataIndex _species_index;

  /// the velocity updater object which we will hold the rules for how our
  /// particles velocities are updated
  const ParticleStepperBase & _stepper;

  /// temporary variable used when resetting rays
  Point _temporary_velocity;

  /**
   *  Method that users should override for their custom particle initialization
   *  This is only called when the study first starts up
   */
  virtual void initializeParticles();
  /**
   * Method that defines how to reuse particles this will be called on
   * every step after the initialization has been called
   */
  virtual void reinitializeParticles();

  /**
   * Sets up the given ray object with the contained with in the InitialParticleData struct
   * @param ray the aquired ray to which the data will be assigned
   * @param assigned_data the data that will be set by the study and not directly stored in the
   * InitialParticleData struct
   * @param data the initial particle data that will be given to the day
   */
  virtual void setInitialParticleData(std::shared_ptr<Ray> & ray,
                                      const AssignedParticleData & assigned_data,
                                      const InitialParticleData & data);

  /**
   * Takes in the data required to initialize a particle and then returns the shared pointer
   * that is created using acquireRay
   * @param assigned_data the data that will be set by the study and not directly stored in the
   * InitialParticleData struct
   * @param data The initial particle data provided by a ParticleInitializer
   * @returns a shared pointer to a ray that is ready to be propagated.
   */
  virtual std::shared_ptr<Ray> createParticle(const AssignedParticleData & assigned_data,
                                              const InitialParticleData & data);

private:
  /// Whether or not we've generated rays yet (restartable)
  bool & _has_generated;
};
