# NumberDensityAccumulator

!syntax description /UserObjects/NumberDensityAccumulator

## Overview

In SALAMANDER the particle number density $n$ is defined as

\begin{equation} \label{eq:number_density}
  n
  \left(
    \vec{r}\,
  \right)
   =
  \sum_{i=1}^N
  w_i \delta
  \left(
    \vec{r} - \vec{r}_i
  \right),
\end{equation}

where $N$ is the number of computational particles in the simulation, $w_i$ is the weight of the $i^\text{th}$ particle, and $\vec{r}_i$ is the position at which the $i^\text{th}$ computational particle exists. This is the [ChargeDensityAccumulator.md] source term without the particle charge $q_i$. The object evaluates the inner product of $n$ and the finite element test functions directly and accumulates the result into the residual of the variable it is applied to.

## Example Input Syntax

!listing test/tests/userobjects/particle_quantity_accumulation/simple_potential_solve.i block=UserObjects

!syntax parameters /UserObjects/NumberDensityAccumulator

!syntax inputs /UserObjects/NumberDensityAccumulator

!syntax children /UserObjects/NumberDensityAccumulator
