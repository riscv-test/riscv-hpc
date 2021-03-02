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
REPO=https://github.com/trilinos/Trilinos.git
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
  echo "NO FORTRAN COMPILER FOUND; CANNOT BUILD TRILINOS"
  exit -1
else
  #-- build with Fortran support
  mkdir build
  cd build
  cmake -DCMAKE_C_COMPILER="$RV_CC $RV_CFLAGS" -DCMAKE_CXX_COMPILER="$RV_CXX $RV_CXXFLAGS" -DCMAKE_Fortran_COMPILER="$RV_FORT $RV_FORTFLAGS" -DTrilinos_ENABLE_ALL_PACKAGES=ON -DTPL_ENABLE_BLAS=OFF -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH ../
  make -j$MAX_THREADS
  if [ $? -ne 0 ]; then
    exit -1
  fi
fi
make install
if [ $? -ne 0 ]; then
  exit -1
fi

exit 0

# EOF
