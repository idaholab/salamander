!config navigation breadcrumbs=False scrollspy=False

&nbsp;



# Software for Advanced Large-scale Analysis of MAgnetic confinement for Numerical Design, Engineering & Research (SALAMANDER) class=center style=font-weight:200;font-size:200%

!style halign=center
SALAMANDER is designed as an open-source, fully integrated, multiphysics, multiscale, Nuclear Quality Assurance Level 1 (NQA-1) compliant framework facilitating 3D, high-fidelity fusion system modeling.

!style halign=center
SALAMANDER is an application based on the
[MOOSE framework](https://mooseframework.inl.gov) performing system-level, engineering scale (i.e., at the scale of
centimeters and meters), and microstructure-scale (i.e., at the scale of microns) multiphysics
calculations related to magnetic confinement fusion energy systems.
Interfaces to other MOOSE-based codes, including tritium transport ([TMAP8](https://mooseframework.inl.gov/tmap8))
and neutronics ([Cardinal](https://cardinal.cels.anl.gov/)) are also included to support SALAMANDER simulations.

!row!
!col! small=12 medium=4 large=4 icon=get_app
## [Getting Started](getting_started/installation.md) class=center style=font-weight:200;font-size:150%;

!style halign=center
Quickly learn how to obtain the SALAMANDER source code, compile an executable, and
run simulations with these instructions.
!col-end!

!col! small=12 medium=4 large=4 icon=settings

## [Code Reference](syntax/index.md) class=center style=font-weight:200;font-size:150%;

!style halign=center
SALAMANDER provides capabilities that can be applied to a wide variety of problems.
The Code Reference provides detailed documentation of specific code features.
General user notes on SALAMANDER can also be found [here](getting_started/salamander_user_notes.md).
!col-end!

!col! small=12 medium=4 large=4 icon=assessment
## [Verification, Validation, and Example Cases](verification_validation_examples/index.md) class=center style=font-weight:200;font-size:150%;

!style halign=center
Verification, validation, and example cases list cases showcasing SALAMANDER's capabilities
and ensuring its accuracy.
!col-end!
!row-end!

## SALAMANDER is built on MOOSE style=clear:both;

!style halign=left
SALAMANDER is based on [MOOSE], an extremely flexible framework and simulation environment
that permits the solution of coupled physics problems of varying size and dimensionality.
These can be solved using computer hardware appropriate for the model size, ranging from
laptops and workstations to large high performance computers.

Code reliability is a central principle in code development, and this project
employs a well-defined development and testing strategy.  Code changes are only
merged into the repository after both a manual code review and the automated
regression test system have been completed.  The testing process and status of
SALAMANDER is available at [civet.inl.gov](https://civet.inl.gov/repo/530/).

SALAMANDER and MOOSE are developed at Idaho National Laboratory by a team of
computer scientists and engineers and is supported by various funding agencies,
including the [United States Department of Energy](http://energy.gov).  Development
of these codes is ongoing at [INL](https://www.inl.gov) and by collaborators
throughout the world.

Learn more about SALAMANDER in this United States Department of Energy Office of Technology Transition National Lab Discovery Series webinar from June 2024:

!media https://www.youtube.com/embed/gMLr_ElY84A?si=mSBI28bnuu0dnKb7
       id=SALAMANDER-DOE-OTT
       caption=SALAMANDER webinar for the United States Department of Energy Office of Technology Transition National Lab Discovery Series (June 2024).

## SALAMANDER results from a collaboration across several institutions style=clear:both;

!style halign=left
SALAMANDER started as a project lead by Idaho National laboratory in collaboration with North Carolina State University, the University of Illinois Urbana-Champaign, and the United Kingdom Atomic Energy Authority. We are always looking for new collaborations and encourage everyone to [get started](getting_started/installation.html), start [contributing](getting_started/contributing.html), and connect with the team on [the SALAMANDER GitHub discussion](https://github.com/idaholab/salamander/discussions).

!media large_media/framework/inl_blue.png link=https://www.inl.gov style=display:block;margin:auto;width:30%;

&nbsp;

!row! style=display:inline-flex;
!col! small=12 medium=4 large=3

!media figures/ncstate-brick-2x2-red.png link=https://www.ncsu.edu/ style=width:100%;display:block;

!col-end!

!col! small=12 medium=4 large=3

!media figures/University-Wordmark-Full-Color-RGB.png link=https://illinois.edu/ dark_src=figures/University-Wordmark-Reversed-Orange-RGB.png style=width:100%;padding:20px 0;display:block;

!col-end!

!col! small=12 medium=4 large=3

!media figures/UK_Atomic_Energy_Authority_logo.svg link=https://ccfe.ukaea.uk/ dark_src=figures/UK-AEA_WHITE_SML_AW.png style=width:50%;display:block;

!col-end!
!row-end!

