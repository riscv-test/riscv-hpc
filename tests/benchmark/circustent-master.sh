#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# /benchmark/circustent-master.sh
#
# CircusTent Master Branch
#
# https://github.com/tactcomplabs/circustent
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=https://github.com/tactcomplabs/circustent.git
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
mkdir build
cd build
CC="$RV_CC" CFLAGS="$RV_CFLAGS -L$COMPILER_INSTALL_PATH/lib" CXX="$RV_CXX" CXX_FLAGS="$RV_CXXFLAGS -L$COMPILER_INSTALL_PATH/lib" cmake -DENABLE_OMP=ON ../
if [ $? -ne 0 ]; then
  exit -1
fi

make -j$MAX_THREADS
if [ $? -ne 0 ]; then
  exit -1
fi

exit 0

# EOF
