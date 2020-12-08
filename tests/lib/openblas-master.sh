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
make HOSTCC=gcc CC=$RV_CC ARCH=riscv64 FC=$RV_FORT TARGET=RISCV64_GENERIC -j$MAX_THREADS
make PREFIX=$INSTALL_PATH install

exit 0

# EOF
