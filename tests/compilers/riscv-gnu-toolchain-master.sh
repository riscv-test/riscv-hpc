#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# riscv-gnu-toolchain-master.sh
#
# RISC-V GNU Toolchain: Master branch
#
# https://github.com/riscv/riscv-gnu-toolchain
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
SRC=$TEST-SRC
REPO=https://github.com/riscv/riscv-gnu-toolchain
ARCHIVE=
#------------------------------------------------


#------------------------------------------------
# STAGE-1: SOURCE THE ENVIRONMENT SCRIPT
#------------------------------------------------
. $WORKSPACE/common/build_env.sh $TEST $NODE_NAME "$NODE_LABELS" $MAX_THREADS $REPO $ARCHIVE

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
git clone --recursive $REPO $SRC
cd $SRC

#------------------------------------------------
# STAGE-5: INITIATE THE BUILD
#------------------------------------------------
./configure --prefix=$INSTALL_PATH --enable-multilib
make -j$MAX_THREADS

exit 0

# EOF
