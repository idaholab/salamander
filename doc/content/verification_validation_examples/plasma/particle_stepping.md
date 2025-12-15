# Particle Steppers

Within SALAMANDER two main particle steppers are provided, the [Leapfrog](LeapFrogStepper.md) stepper and the [Boris](BorisStepper.md) stepper.
Both of these particle steppers are second order accurate in time.
In order to verify that these steppers work properly a convergence studies can be utilized to ensure that second order accuracy is observed.

# Demonstration Problem

The example of single particle motion utilized in the verification of these capabilities is with a classic examples of single particle motion, cyclotron motion.
While cycltron motion requires a magnetic field we will utilize the analytic solution for particle motion to configure electric fields to reproduce the same praticle paths.

## Cycltron Motion

The problem setup of cycltron motion starts with a static magnetic field perpendicular to the plane in which the particle is traveling.
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

The analytic solution to this equations are given by

\begin{equation}
  x(t) = r_L \sin \left( \omega_c t \right)
\end{equation}
\begin{equation}
  y(t) = r_L \cos \left( \omega_c t \right)
\end{equation}

Where $r_L$ is the whats called the Larmor radius and given by

\begin{equation}
  r_L = \frac{v_\perp}{\omega_c}
\end{equation}

Where $v_\perp$ is the initial speed of the particle in the plane perpendicular to the magnetic field, and $\omega_c$ is the gyro frequency.
The gyro frequency is defined as

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

We can then plug in the solution for the particles path from the example of cycltron motion. to calculate the electric field which will reproduce the same particle motion.
Doing so yields the electric field

\begin{equation}
  \vec{E} \left( \vec{r}, t \right) =
  - \frac{m}{q} \omega_c^2 r_L \sin \left( \omega_c t \right) \hat{x} +
  - \frac{m}{q} \omega_c^2 r_L \cos \left( \omega_c t \right) \hat{y}
\end{equation}

## Convergence Studies

For the sake of simplicity all particle properties are set to unity, in S.I. units, and the magnetic field magnitude $B_0$ is set to 1 T.
Four time steps are used, each one an order of mangitude smaller than the last, $\Delta t \in [1, 10$^{-1}$, 10$^{-2}$, 10$^{-3}$]$ seconds.
After a simulation at a given time step is completed the relative $l_2$, and $l_\infty$ norms of the error between the analytic solution and simulated are taken.
Plotting these errors on a log-log plot and then taking the slope reveals the order of accuracy of the time integration, both implemented steppers are second order accurate in time, so the slope of each line should be two.

!media plot_stepper_errors.py
       image_name=boris_circular_e_field_l2.png
       style=width:50%;margin-bottom:2%;margin-left:auto;margin-right:auto

