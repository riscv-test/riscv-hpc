#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# /lib/lapack-master.sh
#
# Lapack Master Branch
#
# https://github.com/Reference-LAPACK/lapack.git
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=https://github.com/Reference-LAPACK/lapack.git
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
if [[ -z "${RV_FORT}" ]]; then
  #-- no fortran compiler
  exit -1
else
  #-- build with Fortran support
  mkdir build
  cd build
  FC="$RV_FORT $RV_CFLAGS" CC="$RV_CC $RV_CFLAGS" cmake -DCMAKE_INSTALL_LIBDIR=$INSTALL_PATH ../
  cmake --build . -j --target install
fi

exit 0

# EOF
