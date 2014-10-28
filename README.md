# SDSC "octave" roll

## Overview

This roll bundles GNU Octave.

For more information about please visit the official web page:

- <a href="http://www.gnu.org/software/octave/" target="_blank">Octave</a> is a high-level interpreted language, primarily intended for numerical computations. It provides capabilities for the numerical solution of linear and nonlinear problems, and for performing other numerical experiments.


## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate octave source file(s) using a machine that does
have Internet access and copy them into the `src/<package>` directories on your
Rocks development machine.


## Dependencies

Intel MKL libraries.  If you're building with the Intel compiler or there is
an mkl modulefile present (the mkl-roll provides this), then the build process
will pick these up automatically.  Otherwise, you'll need to set the MKL_ROOT
environment variable to the library location.

FFTW libraries.  If there is an fftw modulefile present (the fftw-roll provides
this), then the build process will pick these up automatically.  Otherwise,
you'll need to set the FFTWHOME environment variable to the library location.

HDF5 libraries.  If there is an hdf5 modulefile present (the hdf5-roll provides
this), then the build process will pick these up automatically.  Otherwise,
you'll need to set the HDF5HOME environment variable to the library location.

cmake.  If there is an cmake modulefile present (the cmake-roll provides
this), then the build process will pick this up automatically.  Otherwise,
you'll need to add the appropriate directory to your PATH environment variable.

## Building

To build the octave-roll, execute these instructions on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make default 2>&1 | tee build.log
```

A successful build will create the file `octave-*.disk1.iso`.  If you built the
roll on a Rocks frontend, proceed to the installation step. If you built the
roll on a Rocks development appliance, you need to copy the roll to your Rocks
frontend before continuing with installation.

This roll source supports building with different compilers and for different
MPI flavors.  The `ROLLCOMPILER` and `ROLLMPI` make variables can be used to
specify the names of compiler and MPI modulefiles to use for building the
software, e.g.,

```shell
make ROLLCOMPILER=gnu ROLLMPI=mvapich2_ib 2>&1 | tee build.log
```

The build process recognizes "gnu", "intel" or "pgi" as the value for the
`ROLLCOMPILER` variable; any MPI modulefile name may be used as the value of
the `ROLLMPI` variable.  The default values are "gnu" and "rocks-openmpi".

The values of the `ROLLCOMPILER` and `ROLLMPI` variables are incorporated into
the names of the produced rpms.  For example,

```shell
make ROLLCOMPILER=gnu ROLLMPI=mvapich2_ib 2>&1 | tee build.log
```

produces a roll containing an rpm with a name that begins
`octave_gnu_mvapich2_ib`.

For gnu compilers, the roll also supports a `ROLLOPTS` make variable value of
'avx', indicating that the target architecture supports AVX instructions.


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll octave 
% cd /export/rocks/install
% rocks create distro
% rocks run roll octave | bash
```

In addition to the software itself, the roll installs individual environment
module files for each tool in:

```shell
/opt/modulefiles/applications
```


## Testing

The octave-roll includes a test script which can be run to verify proper
installation of the roll documentation, binaries and module files. To
run the test scripts execute the following command(s):

```shell
% /root/rolltests/octave.t 
```