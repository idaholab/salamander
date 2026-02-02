# Particle Steppers

Within the particle-in-cell capabilities in SALAMANDER, two main particle steppers are provided, the [Leapfrog](LeapFrogStepper.md) stepper and the [Boris](BorisStepper.md) stepper. Both of these particle steppers are second order accurate in time.
In order to verify that these steppers work properly, a convergence studies can be utilized to ensure that second order accuracy is observed.

# Demonstration Problems

The problem utilized to verify the implementation of the particle steppers is based on a classic example of single particle motion, cyclotron motion.
While cyclotron motion requires a magnetic field, we will utilize the analytic solution for particle motion to configure electric fields to reproduce the same particle paths.

## Cyclotron Motion

The problem setup of cyclotron motion starts with a static magnetic field perpendicular to the plane in which the particle is traveling.
For this example, the particle is traveling within the `xy` plane, and the magentic field is aligned along the positive `z` direction:

\begin{equation}
  \vec{B} \left(\vec{r}, t \right)
  =
  B_0 \hat{z},
\end{equation}

where $B$ represents the magnetic field and $B_0$ denotes the magnitude of the magnetic field.
Starting from Newtons equation of motion

\begin{equation}
  \frac{d\vec{v}}{dt}
  =
  \frac{q}{m}
  \vec{v} \times \vec{B},
\end{equation}

where $\vec{v}$ is the particle's velocity, $q$ is the particle's charge, and $m$ is the particle's mass.

The analytic solution to these equations are given by

\begin{equation}
  x(t) = r_L \sin \left( \omega_c t \right),
\end{equation}
\begin{equation}
  y(t) = r_L \cos \left( \omega_c t \right),
\end{equation}

where $r_L$ is the what is called the Larmor radius and given by

\begin{equation}
  r_L = \frac{v_\perp}{\omega_c},
\end{equation}

where $v_\perp$ is the initial speed of the particle in the plane perpendicular to the magnetic field, and $\omega_c$ is the gyro frequency.
The gyrofrequency is defined as

\begin{equation}
  \omega_c = \frac{q B_0}{m}.
\end{equation}

## Time Varying Electric Field

The leapfrog stepper is designed to move particles through an electric field.
Starting from the equations of motion for a particle in an electric field, the particle velocity is given by

\begin{equation}
  \frac{d\vec{v}}{dt}
  =
  \frac{q}{m}
  \vec{E}.
\end{equation}

We can then plug in the solution for the particles path from the example of cycltron motion to calculate the electric field which will reproduce the same particle motion.
Doing so yields the electric field:

\begin{equation}
  \vec{E} \left( \vec{r}, t \right) =
  - \frac{m}{q} \omega_c^2 r_L \sin \left( \omega_c t \right) \hat{x} +
  - \frac{m}{q} \omega_c^2 r_L \cos \left( \omega_c t \right) \hat{y}.
\end{equation}

## Convergence Studies

For the sake of simplicity, all particle properties are set to unity, in S.I. units, and the magnetic field magnitude $B_0$ is set to 1 T.
Four time steps are used, each one an order of magnitude smaller than the last, $\Delta t \in [1, 10^{-1}, 10^{-2}, 10^{-3}]$ seconds.
After a simulation at a given time step is completed, the relative $l_2$ and $l_\infty$ norms of the error between the analytic solution and simulated are taken.
Plotting these errors on a log-log plot and then calculating the slope reveals the order of accuracy of the time integration, both implemented steppers are second order accurate in time, so the slope of each line should be two.

### Boris Stepper: Cyclotron Motion

This test specifically tests the part of the stepper which calculates the force on the particle due to the magnetic field.
The relative $l_2$ and $l_\infty$ errors seen in [boris_cyclotron_l2] and [boris_cyclotron_linf] respectively show the error over the course of the convergence study.
Both errors indicate that the implementation of the Boris Stepper achieves the expected second order accuracy in time when moving a particle through a magnetic field.
Second order accuracy is observed for both particle position and velocity.

!row! style=display:inline-flex;
!col! small=12 medium=6 large=6

!media plot_cyclotron_boris.py
       id=boris_cyclotron_l2
       image_name=boris_cyclotron_l2.png style=width:100%;display:block;
       caption=Relative $l_2$ error for particle position and velocity for a particle subject to cyclotron motion being pushed via the Boris Stepper for four different time step sizes.

!col-end!

!col! small=12 medium=6 large=6

!media plot_cyclotron_boris.py
       id=boris_cyclotron_linf
       image_name=boris_cyclotron_linf.png style=width:100%;display:block;
       caption=Relative $l_\infty$ error for particle position and velocity for a particle subject to cyclotron motion being pushed via the Boris Stepper for four different time step sizes.

!col-end!
!row-end!


### Boris Stepper: Time Varrying Electric Field

In this example, the part of the Boris stepper which handles the acceleration on the particle due to the electric field is tested.
Both the relative $l_2$, [boris_efield_l2], and $l_\infty$, [boris_efield_linf], errors are examined.
The errors show that the implementation of of the Boris stepper achieves the expected second order accuracy in time when moving a particle through an electric field.

!row! style=display:inline-flex;
!col! small=12 medium=6 large=6

!media plot_circular_e_field_boris.py
       image_name=boris_circular_e_field_l2.png
       id=boris_efield_l2
       style=width:100
       caption=Relative $l_2$ error for particle position and velocity for a particle being moved in a time varrying electric field via the Boris Stepper for four different time step sizes.

!col-end!

!col! small=12 medium=6 large=6

!media plot_circular_e_field_boris.py
       image_name=boris_circular_e_field_linf.png
       id=boris_efield_linf
       style=width:100
       caption=Relative $l_\infty$ error for particle position and velocity for a particle being moved in a time varrying electric field via the Boris Stepper for four different time step sizes.

!col-end!
!row-end!

### Leapfrog Stepper: Time Varrying Electric Field

Since the Leapfrog stepper can be thought of as a special case of the Boris stepper where no magnetic field is present, the resulting errors should be the same as those produced in the previous test shown in [boris_efield_l2] and [boris_efield_linf].
In fact, the errors and order of accuracy of the stepper implementation should be the same in both tests.
In examining the relative $l_2$, [leap_efield_l2], and $l_\infty$, [leap_efield_linf], errors for this test case it can be seen that they are infact the same as those observed in [boris_efield_l2] for $l_2$ and [boris_efield_linf] for $l_\infty$.

!row! style=display:inline-flex;
!col! small=12 medium=6 large=6

!media plot_circular_e_field_leapfrog.py
       image_name=leapfrog_circular_e_field_l2.png style=width:100%;display:block;
       id=leap_efield_l2
       caption=Relative $l_2$ error for particle position and velocity for a particle being moved in a time varrying electric field via the Leapfrog Stepper for four different time step sizes.

!col-end!

!col! small=12 medium=6 large=6

!media plot_circular_e_field_leapfrog.py
       image_name=leapfrog_circular_e_field_linf.png style=width:100%;display:block;
       id=leap_efield_linf
       caption=Relative $l_\infty$ error for particle position and velocity for a particle being moved in a time varrying electric field via the Leapfrog Stepper for four different time step sizes.

!col-end!
!row-end!

Through this verification test both the Boris and the Leapfrog steppers have been verified.
Both portions of the Boris stepper, the one that handles the acceleration due to a magnetic field and the one that handles the acceleration due to an electric field produce results which are, as expected, second order accurate in time.
Additionally, the Leapfrog stepper produces these expected results as well.

## Input Files

There are several input files used for this verification case.
The two for the Boris stepper can be found at [/boris_stepper/cyclotron_motion.i] and [/boris_stepper/circular_e_field.i].
The one for the Leapfrog stepper can be found at [/leapfrog_stepper/circular_e_field.i]
Since the majority of the input files content is the same for all cases the files are broken up into several files.

- [/stepper_base.i] disables the field solver, so that particle motion tests are only conducted in fields that are known exactly, and sets up the PICStudy.
- [/boris_base.i] adds magnetic field components to the list of AuxVariables and selects the [BorisStepper.md] as the particle stepper.
- [/leapfrog_base.i] selects the [LeapFrogStepper.md] as the particle stepper.
- [/boris_stepper/cyclotron_motion.i], [/boris_stepper/circular_e_field.i], and [/leapfrog_stepper/circular_e_field.i] setup the initial conditions for the particles and fields for each case.

To combine them into one input file when running the simulation, the `!include` feature is utilized.

!alert tip title=Input file include syntax information
To learn more about the `!include` feature, refer to the [application_usage/input_syntax.md] page.
