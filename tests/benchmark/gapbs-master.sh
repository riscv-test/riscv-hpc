#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# /benchmark/gapbs-master.sh
#
# GAPBS Master Branch
#
# https://github.com/sbeamer/gapbs.git
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=https://github.com/sbeamer/gapbs.git
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
CXX=$RV_CXX $CXX_FLAGS=$RV_CXXFLAGS make -j$MAX_THREADS

exit 0

# EOF
