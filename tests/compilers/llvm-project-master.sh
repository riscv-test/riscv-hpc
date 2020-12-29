#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# llvm-project-master.sh
#
# RISC-V LLVM Toolchain: Master branch
#
# https://github.com/llvm/llvm-project
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=https://github.com/llvm/llvm-project.git
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
cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_BUILD_TYPE=Debug -DLLVM_ENABLE_PROJECTS="clang;flang;libcxx;libcxxabi;libc;openmp;lld" -DLLVM_TARGETS_TO_BUILD="RISCV" -DLLVM_LIBC_ENABLE_LINTING=OFF ../llvm
make -j$MAX_THREADS
make install

exit 0

# EOF
