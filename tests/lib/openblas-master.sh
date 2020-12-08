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
SRC=$TEST-SRC
REPO=https://github.com/xianyi/OpenBLAS.git
ARCHIVE=
#------------------------------------------------


#------------------------------------------------
# STAGE-1: SOURCE THE ENVIRONMENT SCRIPT
#------------------------------------------------
. $WORKSPACE/common/build_env.sh $TEST $NODE_NAME $NODE_LABELS $MAX_THREADS $REPO $ARCHIVE

#------------------------------------------------
# STAGE-2: REMOVE THE STALE BUILD
#------------------------------------------------
rm -Rf $INSTALL_PATH

#------------------------------------------------
# STAGE-3: SETUP THE INSTALL PATH
#------------------------------------------------
mkdir -p $INSTALL_PATH

#------------------------------------------------
# STAGE-4: CLONE THE REPO
#------------------------------------------------
cd $BUILDROOT
rm -Rf $SRC
git clone $REPO $SRC
cd $SRC

#------------------------------------------------
# STAGE-5: INITIATE THE BUILD
#------------------------------------------------
make HOSTCC=gcc CC=$RV_CC ARCH=riscv64 NO_LAPACKE=1

exit 0

# EOF
