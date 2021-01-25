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
git clone --recursive $REPO $SRC
cd $SRC

#------------------------------------------------
# STAGE-3: INITIATE THE BUILD
#------------------------------------------------
./configure --prefix=$INSTALL_PATH --enable-multilib
if [ $? -ne 0 ]; then
  exit -1
fi
make linux -j$MAX_THREADS
if [ $? -ne 0 ]; then
  exit -1
fi

exit 0

# EOF
