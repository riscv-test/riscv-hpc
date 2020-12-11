#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# /templates/template-master.sh
#
# RISC-V Test Suite Template Script
#
# https://github.com/riscv-test/riscv-hpc.git
#

#------------------------------------------------
# GLOBAL VARIABLES
#------------------------------------------------
# The following variables are defined by the
# pipeline infrastructure
#
# - BUILDROOT : Source directory where all packages will be uncompressed and built
# - COMPILER : The compiler utilized for the respective build, aka `riscv-gnu-toolchain-master`
# - COMPILER_INSTALL_PATH : The installation path for the target compiler
# - COMPILER_SRC : The source code location for the target compiler
# - RISCV : The RISCV installation path.  Set for convenience for build scripts that require it
# - RV_CC : The RISC-V C compiler path
# - RV_CXX : The RISC-V C++ compiler path
# - RV_FORT : The RISC-V Fortran compiler path
# - RV_CFLAGS : The RISC-V C Flags
# - RV_CXXFLAGS : The RISC-V CXX Flags
# - RV_FORTFLAGS : The RISC-V Fort Flags
# - MAX_THREADS : The maximum number of threads for the respective build node
# - NODE_NAME : Name of the CI node executing the tests (for logging)
# - NODE_LABELS : Node labels utilized to pair the executing node and the test

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=
ARCHIVE=
#------------------------------------------------

#------------------------------------------------
# STAGE-1: SOURCE THE ENVIRONMENT SCRIPT
#------------------------------------------------
. $WORKSPACE/common/build_env.sh $TEST $NODE_NAME "$NODE_LABELS" $MAX_THREADS $REPO $ARCHIVE

#------------------------------------------------
# STAGE-2: CLONE THE REPO
#------------------------------------------------
cd $BUILDROOT
rm -Rf $SRC
git clone $REPO $SRC
cd $SRC

#------------------------------------------------
# STAGE-3: INITIATE THE BUILD
#------------------------------------------------

# CC='$RV_CC $RV_CFLAGS' make -j$MAX_THREADS

exit 0

# EOF
