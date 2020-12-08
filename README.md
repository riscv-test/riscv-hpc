# riscv-hpc
[![GitHub license](https://img.shields.io/badge/license-BSD-blue.svg)](https://raw.githubusercontent.com/riscv-test/riscv-hpc/master/LICENSE)

This repository serves as the basis for the official RISC-V HPC test suite
that is executed via the Jenkins CI host at https://riscv-test.org.

## License
The RISC-V HPC test suite is licensed under a BSD-style license = see the [LICENSE](LICENSE) file for details.

## Architecture Overview

## Developing New Scripts
### Overview
### Template Script
### Script Naming Convention
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

#### Build Execution

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
| MAX\_THREADS | Integer | The maximum number of threads for the respective build node|
| NODE\_NAME | String | Name of the CI node executing the tests (for logging)|
| NODE\_LABELS | String(s) | Node labels utilized to pair the executing node and the test|

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

