#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# llvm-project-11.0.1.sh
#
# RISC-V LLVM Toolchain: 11.0.1 Release
#
# https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/llvm-project-11.0.1.tar.xz
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=
ARCHIVE=https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/llvm-project-11.0.1.tar.xz
#------------------------------------------------


#------------------------------------------------
# STAGE-1: SOURCE THE ENVIRONMENT SCRIPT
#------------------------------------------------
. $WORKSPACE/common/build_env.sh $TEST $NODE_NAME "$NODE_LABELS" $MAX_THREADS $REPO $ARCHIVE

#------------------------------------------------
# STAGE-2: CLONE THE REPO
#------------------------------------------------
#-- IGNORED: PREBUILT LIBRARY

#------------------------------------------------
# STAGE-3: INITIATE THE BUILD
#------------------------------------------------
# Check to ensure that the compiler exists
if [ -s "$RV_CC" ];
then
  echo "Preinstalled compiler exists at $RV_CC"
else
  echo "Preinstalled compiler NOT FOUND at $RV_CC"
  exit -1
fi

exit 0

# EOF
