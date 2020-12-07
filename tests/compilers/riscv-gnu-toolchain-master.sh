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
REPO=https://github.com/riscv/riscv-gnu-toolchain
ARCHIVE=
INSTALL_PATH=$WORKSPACE/$TEST
#------------------------------------------------


#------------------------------------------------
# STAGE-1: SOURCE THE ENVIRONMENT SCRIPT
#------------------------------------------------
. $WORKSPACE/common/build_env.sh $TEST $NODE_NAME $NODE_LABELS $MAX_THREADS $INSTALL_PATH $REPO $ARCHIVE

#------------------------------------------------
# STAGE-2: REMOVE THE STALE BUILD
#------------------------------------------------
rm -Rf $INSTALL_PATH

#------------------------------------------------
# STAGE-3: SETUP THE INSTALL PATH
#------------------------------------------------
mkdir -p $INSTALL_PATH

#------------------------------------------------
# STAGE-4: INITIATE THE BUILD
#------------------------------------------------
./configure --prefix=$INSTALL_PATH --enable-multilib
make -j$MAX_THREADS

exit 0

# EOF
