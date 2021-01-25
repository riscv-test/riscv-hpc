#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# /lib/openblas-master.sh
#
# OpenBLAS Master Branch
#
# https://github.com/xianyi/OpenBLAS.git
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=https://github.com/xianyi/OpenBLAS.git
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
  #-- build without Fortran support
  make HOSTCC=gcc CC="$RV_CC $RV_CFLAGS" ARCH=riscv64 NO_LAPACKE=1 TARGET=RISCV64_GENERIC -j$MAX_THREADS
  if [ $? -ne 0 ]; then
    exit -1
  fi
else
  #-- build with Fortran support
  make HOSTCC=gcc CC="$RV_CC $RV_CFLAGS" FC=$RV_FORT ARCH=riscv64 TARGET=RISCV64_GENERIC -j$MAX_THREADS
  if [ $? -ne 0 ]; then
    exit -1
  fi
fi
make PREFIX=$INSTALL_PATH install
if [ $? -ne 0 ]; then
  exit -1
fi

exit 0

# EOF
