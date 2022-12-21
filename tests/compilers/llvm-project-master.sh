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
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DLLVM_ENABLE_PROJECTS="clang;flang;lld" -DLLVM_TARGETS_TO_BUILD="RISCV" ../llvm
if [ $? -ne 0 ]; then
  exit -1
fi
make -j$MAX_THREADS
if [ $? -ne 0 ]; then
  exit -1
fi
make install
if [ $? -ne 0 ]; then
  exit -1
fi

#-- remove the current build so we can reconstruct everything for RISC-V openmp
rm -Rf ./*
cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_C_COMPILER=$RV_SYSROOT/bin/riscv64-unknown-linux-gnu-gcc -DCMAKE_CXX_COMPILER=$RV_SYSROOT/bin/riscv64-unknown-linux-gnu-g++ -DLIBOMP_ARCH=riscv64 -DOPENMP_ENABLE_LIBOMPTARGET=OFF ../openmp
if [ $? -ne 0 ]; then
  exit -1
fi
make -j$MAX_THREADS
if [ $? -ne 0 ]; then
  exit -1
fi
make install
if [ $? -ne 0 ]; then
  exit -1
fi


exit 0

# EOF
