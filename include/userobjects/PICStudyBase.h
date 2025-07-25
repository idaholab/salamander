//* This file is part of SALAMANDER: Software for Advanced Large-scale Analysis of MAgnetic
// confinement for Numerical Design, Engineering & Research,
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
//* Copyright 2025, Battelle Energy Alliance, LLC
//* ALL RIGHTS RESERVED
//*

#pragma once

#include "Ray.h"
#include "RayTracingStudy.h"

#include "ParticleInitializerBase.h"
class ParticleStepperBase;

class PICStudyBase : public RayTracingStudy
{
public:
  PICStudyBase(const InputParameters & parameters);

  static InputParameters validParams();

  virtual void generateRays() override;

  /**
   * Method for getting the rays after they have finished tracing
   * useful for looking at the rays data if needed by another object
   */
  const std::vector<std::shared_ptr<Ray>> & getBankedRays() const;

  /**
   * Getter method for getting the ray data indicies which are needed to access the velocity
   * components stored in ray data
   * @param all_components if true all three data indicies will be provided if not then only the
   * indicies consistent with the dimension of the mesh will be provided i.e. if the mesh being used
   * is 1D then only the index for the x component will be provided if all_components is false
   */
  const std::vector<RayDataIndex> getVelocityIndicies(const bool all_components) const;

protected:
  /// The banked rays to be used on the next timestep (restartable)
  std::vector<std::shared_ptr<Ray>> & _banked_rays;

  virtual void postExecuteStudy() override;
  /// Ray data for storing velocity components
  ///@{
  const RayDataIndex _v_x_index;
  const RayDataIndex _v_y_index;
  const RayDataIndex _v_z_index;
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
   * Method for getting a rays velocity as a vector
   * Each component is retrieved from ray data and given
   * back to user as a vector to make calculations easier
   * @param ray the ray
   * @param v the point where the rays velocity will be stored
   */
  void getVelocity(const Ray & ray, Point & v) const;

  /**
   * Method for updating the rays velocity data given a new velocity
   * @param ray the ray that will have its velocity updated
   * @param v the new velocity to give the ray
   */
  void setVelocity(Ray & ray, const Point & v) const;

  /**
   *  Method that users should override for their custom particle initialization
   *  This is only called when the study first starts up
   */
  virtual void initializeParticles() = 0;
  /**
   * Method that defines how to reuse particles this will be called on
   * every step after the initialization has been called
   */
  virtual void reinitializeParticles();

  /**
   * Sets up the given ray object with the contained with in the InitialParticleData struct
   * @param ray the aquired ray to which the data will be assigned
   * @param data the initial particle data that will be given to the day
   */
  virtual void setInitialParticleData(std::shared_ptr<Ray> & ray, const InitialParticleData & data);

private:
  /// Whether or not we've generated rays yet (restartable)
  bool & _has_generated;
};
