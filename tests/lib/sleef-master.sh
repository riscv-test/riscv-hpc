#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# /lib/sleef-master.sh
#
# SLEEF Master Branch
#
# https://github.com/shibatch/sleef
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=https://github.com/shibatch/sleef
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
CC="$RV_CC $RV_CFLAGS" cmake -DCMAKE_BUILD_TYPE=Release -CMAKE_INSTALL_PREFIX=$INSTAL_PATH -DSLEEF_SHOW_CONFIG=ON ../
make
make install

exit 0

# EOF
