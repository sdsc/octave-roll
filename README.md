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

The sdsc-roll must be installed on the build machine, since the build process
depends on make include files provided by that roll.

The roll sources assume that modulefiles provided by SDSC compiler and mpi
rolls are available, but it will build without them as long as the environment
variables they provide are otherwise defined.

The build process requires the FFTW and HDF5 libraries and assumes that
the modulefiles provided by the corresponding SDSC rolls are available.
It will build without the modulefiles as long as the environment variables
they provide are otherwise defined.

If the MKL modulefile provided by the SDSC intel roll is present, or if the
MKL_ROOT environment variable is otherwise defined, the build process will use
the MKL BLAS and LAPACK libraries; otherwise, it will make use of whatever
system libraries are available.


## Building

To build the octave-roll, execute this on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make 2>&1 | tee build.log
```

A successful build will create the file `octave-*.disk1.iso`.  If you built the
roll on a Rocks frontend, proceed to the installation step. If you built the
roll on a Rocks development appliance, you need to copy the roll to your Rocks
frontend before continuing with installation.

This roll source supports building with different compilers and with different
MPI flavors. The `ROLLCOMPILER` and `ROLLMPI` make variables can be used to
specify the names of the compiler and MPI modulefiles to use for building the
software, e.g.,

```shell
make ROLLCOMPILER=gnu ROLLMPI=mvapich2_ib 2>&1 | tee build.log
```

The build process recognizes "gnu", "intel" or "pgi" as the value for the
`ROLLCOMPILER` variable; any MPI modulefile name may be used as the value of
the `ROLLMPI` variable.  The defaults values are "gnu" and "rocks-openmpi".

For gnu compilers, the roll also supports a `ROLLOPTS` make variable value of
'avx' and 'avx2', indicating that the target architecture supports AVX instructions.


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll octave 
% cd /export/rocks/install
% rocks create distro
% rocks run roll octave | bash
```

In addition to the software itself, the roll installs octave environment
module files in:

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
