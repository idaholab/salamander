# Particle Steppers

Within SALAMANDER two main particle steppers are provided, the [Leapfrog](LeapFrogStepper.md) stepper and the [Boris](BorisStepper.md) stepper. Both of these particle steppers are second order accurate in time.
In order to verify that these steppers work properly a convergence studies can be utilized to ensure that second order accuracy is observed.

# Demonstration Problem

The example of single particle motion utilized in the verification of these capabilities is with a classic examples of single particle motion, cyclotron motion.
While cycltron motion requires a magnetic field we will utilize the analytic solution for particle motion to configure electric fields to reproduce the same praticle paths.

## Cyclotron Motion

The problem setup of cyclotron motion starts with a static magnetic field perpendicular to the plane in which the particle is traveling.
For this example, the particle is traveling within the `XY` plane, and the magentic field is aligned along the positive `Z` direction.

\begin{equation}
  \vec{B} \left(\vec{r}, t \right)
  =
  B_0 \hat{z}
\end{equation}

Where $B$ represents the magnetic field and $B_0$ denotes the magnitude of the magnetic field.
Starting from Newtons equation of motion

\begin{equation}
  \frac{d\vec{v}}{dt}
  =
  \frac{q}{m}
  \vec{v} \times \vec{B}
\end{equation}

Where $\vec{v}$ is the particle's velocity, $q$ is the particle's charge, and $m$ is the particle's mass.

The analytic solution to these equations are given by

\begin{equation}
  x(t) = r_L \sin \left( \omega_c t \right)
\end{equation}
\begin{equation}
  y(t) = r_L \cos \left( \omega_c t \right)
\end{equation}

Where $r_L$ is the what is called the Larmor radius and given by

\begin{equation}
  r_L = \frac{v_\perp}{\omega_c}
\end{equation}

Where $v_\perp$ is the initial speed of the particle in the plane perpendicular to the magnetic field, and $\omega_c$ is the gyro frequency.
The gyrofrequency is defined as

\begin{equation}
  \omega_c = \frac{q B_0}{m}.
\end{equation}

## Time Varying Electric Field

The leapfrog stepper is designed to move particles through an electric field.
Starting from the equations of motion for a particle in an electric field is given by

\begin{equation}
  \frac{d\vec{v}}{dt}
  =
  \frac{q}{m}
  \vec{E}.
\end{equation}

We can then plug in the solution for the particles path from the example of cycltron motion to calculate the electric field which will reproduce the same particle motion.
Doing so yields the electric field

\begin{equation}
  \vec{E} \left( \vec{r}, t \right) =
  - \frac{m}{q} \omega_c^2 r_L \sin \left( \omega_c t \right) \hat{x} +
  - \frac{m}{q} \omega_c^2 r_L \cos \left( \omega_c t \right) \hat{y}
\end{equation}

## Convergence Studies

For the sake of simplicity, all particle properties are set to unity, in S.I. units, and the magnetic field magnitude $B_0$ is set to 1 T.
Four time steps are used, each one an order of mangitude smaller than the last, $\Delta t \in [1, 10^{-1}, 10^{-2}, 10^{-3}]$ seconds.
After a simulation at a given time step is completed the relative $l_2$, and $l_\infty$ norms of the error between the analytic solution and simulated are taken.
Plotting these errors on a log-log plot and then calculating the slope reveals the order of accuracy of the time integration, both implemented steppers are second order accurate in time, so the slope of each line should be two.

### Boris Stepper: Cyclotron Motion

This test specifically tests the part of the stepper which calculates the force on the particle due to the magnetic field.
In examing the errors from the figures below it can be seen that the implementatio of the Boris Stepper utilized achieves the expected second order accuracy in time for both $x$, and $y$ particle positions as well as the $x$, and $y$ componenets of the particles velocity.

!row! style=display:inline-flex;
!col! small=12 medium=6 large=6

!media plot_cyclotron_boris.py
       image_name=boris_cyclotron_l2.png style=width:100%;display:block;
       caption=Relative $l_2$ error for particle position and velocity for a particle subject to cyclotron motion being pushed via the Boris Stepper for four different time step sizes.

!col-end!

!col! small=12 medium=6 large=6

!media plot_cyclotron_boris.py
       image_name=boris_cyclotron_linf.png style=width:100%;display:block;
       caption=Relative $l_\infty$ error for particle position and velocity for a particle subject to cyclotron motion being pushed via the Boris Stepper for four different time step sizes.

!col-end!
!row-end!


### Boris Stepper: Time Varrying Electric Field

In this example, the part of the Boris stepper which handles the acceleration on the particle due to the electric field is tested.
In the figures below it clearly demonstrated that this part of the stepper also achieves the second order accuracy expected.

!row! style=display:inline-flex;
!col! small=12 medium=6 large=6

!media plot_circular_e_field_boris.py
       image_name=boris_circular_e_field_l2.png
       style=width:100%;display:block
       caption=Relative $l_2$ error for particle position and velocity for a particle being moved in a time varrying electric field via the Boris Stepper for four different time step sizes.

!col-end!

!col! small=12 medium=6 large=6

!media plot_circular_e_field_boris.py
       image_name=boris_circular_e_field_linf.png
       style=width:100%;display:block
       caption=Relative $l_\infty$ error for particle position and velocity for a particle being moved in a time varrying electric field via the Boris Stepper for four different time step sizes.

!col-end!
!row-end!

### Leapfrog Stepper: Time Varrying Electric Field

Since the Leapfrog stepper can be thought of as a special case of the Boris stepper where no magentic field is present the resulting errors should be the same as those produced in the previous test.
If the figures and calculated orders of accuracy in the above section are compared with the figures and orders of accuracy in this section they should be the same.
In doing this comparison it is clear that this is the case and the two steppers, as expected, produce the same results.

!row! style=display:inline-flex;
!col! small=12 medium=6 large=6

!media plot_circular_e_field_leapfrog.py
       image_name=leapfrog_circular_e_field_l2.png style=width:100%;display:block;
       caption=Relative $l_2$ error for particle position and velocity for a particle being moved in a time varrying electric field via the Leapfrog Stepper for four different time step sizes.

!col-end!

!col! small=12 medium=6 large=6

!media plot_circular_e_field_leapfrog.py
       image_name=leapfrog_circular_e_field_linf.png style=width:100%;display:block;
       caption=Relative $l_\infty$ error for particle position and velocity for a particle being moved in a time varrying electric field via the Leapfrog Stepper for four different time step sizes.

!col-end!
!row-end!

Through this verification test both the Boris and the Leapfrog steppers have been verified.
Both portions of the Boris stepper, the one that handles the acceleration due to a magnetic field and the one that handles the acceleration due to an electric field produce results which second order accurate in time.
Additionally, the Leapfrog stepper produces these results as well.
