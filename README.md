# riscv-hpc
[![GitHub license](https://img.shields.io/badge/license-BSD-blue.svg)](https://raw.githubusercontent.com/riscv-test/riscv-hpc/master/LICENSE)

This repository serves as the basis for the official RISC-V HPC test suite
that is executed via the Jenkins CI host at https://riscv-test.org.

## License
The RISC-V HPC test suite is licensed under a BSD-style license - see the [LICENSE](LICENSE) file for details.

## Architecture Overview

The RISCV-HPC test architecture is setup specifically to support testing various compilers, libraries 
benchmarks and applications for high performance computing against the RISC-V software ecosystem.  
The test architecture is crafted specifically to support inclusion of a variety of different 
software tools that can be built using different compilers and/or compiler versions.  Note that 
these software entities are NOT executed.  We do not execute and/or track benchmark performance 
of any software package, benchmark or application.  Rather, this infrastructure is designed to 
find the gaps in the RISC-V software ecosystem.  

As we see in the figure below, the test infrastructure is crafted using a series of build scripts 
integrated into a Jenkins pipeline.  Each pipeline instance is initiated at a specific cadence 
(documented in the Jenkins environment).  The first stage of the pipeline initializes  the test environment.  The second stage of the pipeline initializes a set of global 
variables that are utilized by individual test scripts.  These global variables initialize values 
such as the absolute installation path of the target compiler, the required compiler flags and other 
various paths.  The third stage of the pipeline builds the target compiler.  For compilers that are 
designated as "release" builds, we utilize a previously built compiler (as release builds rarely change).  
For compiler builds that target the top of tree source code, we build and install the entire compiler from scratch.  
Once the compiler build has been deemed stable, we execute three sets of nested pipeline stages.  The first 
stage builds and installs candidate libraries.  This can be from release archives or from top-of-tree 
git repositories.  We execute library builds first in order to permit their use by other benchmark or application builds.  
The second and third nested pipeline stages build benchmarks and full applications.  Each of the library, benchmark 
and application builds is driven by a single, specifically formatted test script that handles package-specific 
build options.

Each compiler configuration pipeline resides in a unique pipeline instance.  
The master set of pipeline instances are currently hosted in a public Jenkins instance at 
[https://riscv-test.org/](https://riscv-test.org/).

![Test Architecture](https://raw.githubusercontent.com/riscv-test/riscv-hpc/master/imgs/test-architecture.jpg)

## Developing New Scripts
### Overview

In order to ensure correct execution within the RISCV-HPC environment, each 
test script requires four major steps.  We outline these steps as follow with additional 
detail provided below:

1. Initialization of Top-Level Variables
2. Environment Setup
3. Source Code Retrieval
4. Configuration, Build and Installation


### Template Script

We have provided a number of template scriptes in `/templates/`
- template-master.sh : sample test script

### Script Naming Convention

The test harness requires script naming convention for test driver scripts.
These can be summarized as follows:
* Each script name must be unique with respect to adjacent scripts.  Scripts 
names may not collide with one another.
* Script names must be descriptive of the target test.
* Script names must end in `*.sh`
* Script names may contain alphanumeric characters, underscores and dashes.  Other
special characters are not permitted.
* Script names should be constructed as `Name-Release.sh`

### Required Script Elements

Each test script must be constructed using the same set of basic steps.  Developers are 
encouraged to utilize the provided templates in order to ensure that scripts remain homogeneous 
within the RISC-V HPC test suite.  Developers may also expand upon the basic set of 
script elements in order to perform additional tests and/or build steps.  At this time 
we require the following four basic elements:

#### Top Level Variable Definitions
The first basic element required in the test script initializes a series of script-local 
variables that are utilized for additional processing.  For this, we require 
the script to set three variables: `TEST`, `REPO` and/or `ARCHIVE`.  The `TEST` 
variable is usually set to the basename of the script.  This ensures that the test 
naming convention is unique across scripts.  If a test targets a git repository, 
then source URL for the repository is set with the `REPO` variable.  If a test 
targets a compressed archive, then the `ARCHIVE` variable is set.  However, 
all three variables must be present.

An example of initializing these variables is as follows:

```
#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=https://github.com/riscv-test/riscv-hpc.git
ARCHIVE=
#------------------------------------------------
```

#### Environment Setup
The second stage of the test script utilizes a common script found in the 
test tree to initialize several script-local variables.  This utilizes the `build\_env.sh` 
script.  This script takes a number of variables as arguments.  Note that the arguments 
are combinations of the script-local variables defined above and global CI variables.

We highly recommend utilizing the source code below and not deviating from
the calling convention.

```
#------------------------------------------------
# STAGE-1: SOURCE THE ENVIRONMENT SCRIPT
#------------------------------------------------
. $WORKSPACE/common/build_env.sh $TEST $NODE_NAME "$NODE_LABELS" $MAX_THREADS $REPO $ARCHIVE
```

#### Source Code Retrieval

The second stage of the build script should retrieve the target source code and place it 
in a directory previously initialized by the environment script.  The environment 
sript initializes a variable called `$SRC` that contains the absolute path to the 
directory where the source code should reside.  Examples of doing so 
for both Git based source and Archive based source are provided below.  Also note 
that this stage changes directory to the target source directory.

```
#------------------------------------------------
# STAGE-2: CLONE THE REPO
#------------------------------------------------
cd $BUILDROOT
rm -Rf $SRC
git clone $REPO $SRC
cd $SRC
```

```
#------------------------------------------------
# STAGE-2: CLONE THE REPO
#------------------------------------------------
cd $BUILDROOT
rm -Rf $SRC
wget $ARCHIVE
tar xzvf PACKAGE.tar.gz
mv PACKAGE $SRC
cd $SRC
```

#### Build Execution

The final stage in the script should configure, build and install the source code.  This stage 
will require any package-specific options to be configured using the target compilation actions.  
For compiler and build-specific options, we provide a set of global variables that contain C, CXX 
and Fortran compiler paths and flags.  In the case that no Fortran compiler is available (eg, LLVM), 
then the `RV_FORT` variable will be null.  

Note that for each step in the build, the script should check the return status of major commands.  
For any commands that fail, a non-zero exit code should be returned at minimum.  This will force the
pipeline stage to fail (but not the entire Jenkins pipeline).  An example of configuring, building and 
installing a package is as follows (we use CMake as a example)

```
#-- from $SRC
mkdir build
cd build
CXX=$RV_CXX CXX_FLAGS="$RV_CXXFLAGS" cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH ../
if [ $? -ne 0 ]; then
  exit -1
fi

make -j$MAX_THREADS
if [ $? -ne 0 ]; then
  exit -1
fi

make install
if [ $? -ne 0 ]; then
  exit -1
fi

exit 0
```

### Global CI Variables

The following global variables will be present in the CI execution environment.  These varaibles 
can be utilized within any execution script.

| VARIABLE | TYPE | Description  |
|---|---|---|
| BUILDROOT | String | Source directory where all packages will be uncompressed and built|
| COMPILER | String | The compiler utilized for the respective build, aka `riscv-gnu-toolchain-master`|
| COMPILER\_INSTALL\_PATH | String | The installation path for the target compiler|
| COMPILER\_SRC | String | The source code location for the target compiler|
| RISCV | String | The RISCV installation path.  Set for convenience for build scripts that require it|
| RV\_CC | String | The RISC-V C compiler path|
| RV\_CXX | String | The RISC-V C++ compiler path|
| RV\_FORT | String | The RISC-V Fortran compiler path|
| RV\_CFLAGS | String | The RISC-V C Flags|
| RV\_CXXFLAGS | String | The RISC-V CXX Flags|
| RV\_FORTFLAGS | String | The RISC-V Fort Flags|
| MAX\_THREADS | Integer | The maximum number of threads for the respective build node|
| NODE\_NAME | String | Name of the CI node executing the tests (for logging)|
| NODE\_LABELS | String(s) | Node labels utilized to pair the executing node and the test|
| -- | -- | -- |
| RV\_SYSROOT\_BASE | String | Base directory location of pre-existing (pre-built) compilers|
| RV\_SYSROOT | String | Location of a baseline, known working GNU compiler used for cross compilation `RV_SYSROOT_BASE/path`|

### Test Environment

## Contributing
We welcome outside contributions from corporate, acaddemic and individual developers.  However,
there are a number of fundamental ground rules that you must adhere to in order to participate.  These
rules are outlined as follows:

## Authors
* *John Leidel* - *Chief Scientist* - [Tactical Computing Labs](http://www.tactcomplabs.com)
* *David Donofrio* - *Chief Hardware Architect* - [Tactical Computing Labs](http://www.tactcomplabs.com)

## Acknowledgements
* None at this time

