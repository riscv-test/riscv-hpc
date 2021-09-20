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
  cmake -D CMAKE_C_COMPILER:STRING="$RV_CC $RV_CFLAGS" \
        -D CMAKE_CXX_COMPILER:STRING="$RV_CXX $RV_CXXFLAGS" \
        -D CMAKE_Fortran_COMPILER:STRING="$RV_FORT $RV_FORTFLAGS" \
        -D Trilinos_ENABLE_Kokkos:BOOL=ON \
        -D Trilinos_ENABLE_KokkosKernels:BOOL=ON \
        -D Trilinos_ENABLE_Tpetra:BOOL=ON \
        -D TPL_ENABLE_BLAS:BOOL=OFF \
        -D TPL_ENABLE_LAPACK:BOOL=OFF \
        -D TPL_ENABLE_Boost:BOOL=OFF \
        -D CMAKE_INSTALL_PREFIX:PATH=$INSTALL_PATH \
        ../
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
