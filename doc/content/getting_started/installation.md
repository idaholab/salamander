# Installation

## Step One: Install Conda MOOSE Environment

!style halign=left
In order to install SALAMANDER, the MOOSE developer environment must be installed. The
installation procedure depends on your operating system, so click on the MOOSE
website link below that corresponds to your operating system/platform and follow
the instructions until you are done with the step named "Install MOOSE" (note that
you do not need to follow the steps from the section titled "Cloning MOOSE" and below). Then,
return to this page and continue with Step Two.

- [Linux and MacOS](https://mooseframework.inl.gov/getting_started/installation/conda.html)
- [Windows (experimental)](https://mooseframework.inl.gov/getting_started/installation/windows.html)

Advanced manual installation instructions for this environment are available
[via the MOOSE website](https://mooseframework.inl.gov/getting_started/installation/index.html).

If an error or other issue is experienced while using the conda environment,
please see [the MOOSE troubleshooting guide for Conda](https://mooseframework.inl.gov/help/troubleshooting.html#condaissues)

!alert! note title=Interested in SALAMANDER on HPC?
Those users & developers interested in running SALAMANDER on an HPC cluster environment can find more
information about that user case in our [getting_started/hpc.md] instructions.
!alert-end!

## Step Two: Clone SALAMANDER

!style halign=left
SALAMANDER is hosted on [GitHub](https://github.com/idaholab/SALAMANDER), and should be
cloned directly from there using [git](https://git-scm.com/). As in the MOOSE
directions, it is recommended that users create a directory named "projects" to
put all of your MOOSE-related work.

To clone SALAMANDER, run the following commands in Terminal:

```bash
mkdir ~/projects
cd ~/projects
git clone https://github.com/idaholab/SALAMANDER.git
cd SALAMANDER
git checkout main
```

!alert! note title=SALAMANDER branches
This sequence of commands downloads SALAMANDER from the GitHub server and checks
out the "main" code branch. There are two code branches available:

- "main", which is the current most-tested version of SALAMANDER for general usage, and
- "devel", which is intended for code development (and may be more regularly broken
  as changes occur in SALAMANDER and MOOSE).

Developers wishing to add new features should create a new branch for submission
off of the current "devel" branch.
!alert-end!

## Step Three: Build and Test SALAMANDER

!style halign=left
To compile SALAMANDER, first make sure that the conda MOOSE environment is activated
(*and be sure to do this any time that a new Terminal window is opened*):

```bash
conda activate moose
```

Then navigate to the SALAMANDER clone directory and download the MOOSE, TMAP8, and Cardinal submodules:

```bash
cd ~/projects/SALAMANDER
git submodule update --init moose
git submodule update --init tmap8
git submodule update --init cardinal
```

Next, some Cardinal dependencies need to be downloaded:

```bash
cd ~/projects/SALAMANDER/cardinal
git submodule update --init --recursive contrib/openmc
git submodule update --init contrib/DAGMC
git submodule update --init contrib/moab
```

!alert! tip title=Using Cardinal/DAGMC with Double-Down and Embree
Double-Down (and Embree) enable mixed precision ray tracing within DAGMC. While turned off by default
for now, it can be enabled by adding the following to the above commands:

```bash
git submodule update --init contrib/embree
git submodule update --init contrib/double-down
```

and simply running `export ENABLE_DOUBLE_DOWN=yes` in your terminal environment prior to compiling
SALAMANDER.
!alert-end!

To download OpenMC cross sections needed for OpenMC-based Cardinal runs, run:

```bash
cd ~/projects/SALAMANDER/cardinal
scripts/download-openmc-cross-sections.sh
```

and subsequently set the location of those cross sections in your environment:

```bash
export OPENMC_CROSS_SECTIONS=~/projects/SALAMANDER/cross_sections/cross_sections.xml
```

!alert! warning
This variable +must+ be set in your environment anytime you wish to run SALAMANDER input files that
utilize the OpenMC functionality within Cardinal! This can be done either using `export` on the
command line, or placing this command within a shell config file (`.bashrc`, `.zshrc`, etc.).
!alert-end!

!alert! note
The copies of MOOSE, TMAP8, and Cardinal provided with SALAMANDER have been fully tested against the current
SALAMANDER version, and is guaranteed to work with all current SALAMANDER tests.
!alert-end!

!alert! tip title=Disabling TMAP8
TMAP8 is an optional dependency of SALAMANDER and can be disabled to speed up build times, if TMAP8
capabilities are not needed. This can be done by simply not downloading the TMAP8 submodule
(i.e., not performing the `git submodule update --init tmap8` command above.)
!alert-end!

!alert! tip title=Disabling Cardinal
Cardinal is an optional dependency of SALAMANDER and can be disabled to speed up build times, if Cardinal
capabilities are not needed. This can be done by simply not downloading the Cardinal submodule
(i.e., not performing the `git submodule update --init cardinal` command as well as the Cardinal
dependency download commands above.)
!alert-end!

Once all dependencies have been downloaded, SALAMANDER can be compiled and tested:

```bash
cd ~/projects/SALAMANDER
make -j8
./run_tests -j8
```

!alert! note
The `-j8` flag in the above commands signifies the number of processor cores used to
build the code and run the tests. The number in that flag can be changed to the
number of physical and virtual cores on the workstation being used to build SALAMANDER.
!alert-end!

!alert! note title=Speeding up OpenMC/DAGMC/MOAB builds
If the build of Cardinal third-party libraries OpenMC, DAGMC, and MOAB is too slow on your machine,
you can attempt to pass the number of `make` cores using the `MAKEFLAGS` variable. This can do a
better job enabling proper parallelism in nested `make` builds (as is the case with Cardinal
dependencies). To use this variable, simply perform:

```bash
make MAKEFLAGS=-j8
```

instead of the `make` commands highlighted above.
!alert-end!

If SALAMANDER is working correctly, all active tests will pass. This indicates that
SALAMANDER is ready to be used and further developed.

## Update SALAMANDER

SALAMANDER (and its underlying dependencies MOOSE, TMAP8, and Cardinal) is under heavy development and is
updated on a continuous basis. Therefore, it is important that the local copy of SALAMANDER be periodically
updated to obtain new capabilities, improvements, and bugfixes. Weekly updates are recommended as,
at minimum, the MOOSE submodule within SALAMANDER is updated up to several times a week.

!alert note title=Always update SALAMANDER and the Conda packages together.
There is a tight dependency between the libraries and applications provided by Conda, and the submodules that SALAMANDER depends on. Therefore, when you update one, you should always update the other.

To update your conda environment, perform the following commands (assuming that your MOOSE-based development environment is named `moose`):

!package! code
conda activate base
conda env remove -n moose
conda create -n moose moose-dev=__MOOSE_DEV__
conda activate moose
!package-end!

To update your SALAMANDER repository as a SALAMANDER user, use the following commands, which provide to general users the content of the most stable branch (`upstream/main`):

```bash
cd ~/projects/SALAMANDER
git checkout main
git fetch upstream
git rebase upstream/main
git submodule update moose
git submodule update tmap8
git submodule update cardinal
cd cardinal
git submodule update --recursive contrib/openmc
git submodule update contrib/DAGMC
git submodule update contrib/moab
```

To update your SALAMANDER repository as a SALAMANDER developer who regularly makes modifications to the code, use the following commands,
which provide developers with the `devel` branch:

```bash
cd ~/projects/SALAMANDER
git checkout devel
git fetch upstream
git rebase upstream/devel
git submodule update moose
git submodule update tmap8
git submodule update cardinal
cd cardinal
git submodule update --recursive contrib/openmc
git submodule update contrib/DAGMC
git submodule update contrib/moab
```

!alert! tip title=Disabling TMAP8
TMAP8 is an optional dependency of SALAMANDER and can be disabled to speed up build times, if TMAP8
capabilities are not needed. This can be done by simply not downloading the TMAP8 submodule
(i.e., not performing the `git submodule update tmap8` command above.)
!alert-end!

!alert! tip title=Disabling Cardinal
Cardinal is an optional dependency of SALAMANDER and can be disabled to speed up build times, if Cardinal
capabilities are not needed. This can be done by simply not downloading the Cardinal submodule
(i.e., not performing the `git submodule update cardinal` command as well as the following Cardinal
dependency update commands above.)
!alert-end!

Both sets of instructions assume that your copy of SALAMANDER is stored in `~/projects` and that the [idaholab/SALAMANDER](https://github.com/idaholab/SALAMANDER)
git remote is labeled `upstream`. Use `git remote -v` in the SALAMANDER repository location to check for
this and change the commands as necessary. Finally, SALAMANDER can be re-compiled and re-tested.

```bash
cd ~/projects/SALAMANDER
make -j8
./run_tests -j8
```

## Troubleshooting

!style halign=left
If issues are experienced in installation and testing, several resources
are available:

- [SALAMANDER Issues Page](https://github.com/idaholab/SALAMANDER/issues) for SALAMANDER bugs or feature requests.
- [SALAMANDER Discussion Forum](https://github.com/idaholab/SALAMANDER/discussions) for SALAMANDER issues and questions.
- [MOOSE FAQ page](https://mooseframework.inl.gov/help/faq/index.html) for common MOOSE issues.
- [MOOSE Discussion Forum](https://github.com/idaholab/moose/discussions) for non-SALAMANDER issues and questions.

## What next?

!style halign=left
With installation and testing complete, proceed to [using_salamander.md].
