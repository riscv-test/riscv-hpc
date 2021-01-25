#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# /lib/mpich-3.4.sh
#
# MPICH Version 3.4
#
# http://www.mpich.org/static/downloads/3.4/mpich-3.4.tar.gz
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=
ARCHIVE=http://www.mpich.org/static/downloads/3.4/mpich-3.4.tar.gz
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
wget $ARCHIVE
tar xzvf mpich-3.4.tar.gz
mv mpich-3.4 $SRC
cd $SRC

#------------------------------------------------
# STAGE-3: INITIATE THE BUILD
#------------------------------------------------
mkdir build
cd build

if [[ -z "${RV_FORT}" ]]; then
  #-- build without Fortran support
  CC="$RV_CC" CFLAGS="$RV_CFLAGS" CXX="$RV_CXX" CXXFLAGS="$RV_CXXFLAGS" ../configure --prefix=$INSTALL_PATH --disable-fortran --enable-cxx
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
else
  #-- build with Fortran support
  FC="$RV_FORT" FCFLAGS="$RV_CFLAGS" CC="$RV_CC" CFLAGS="$RV_CFLAGS" CXX="$RV_CXX" CXXFLAGS="$RV_CXXFLAGS" ../configure --prefix=$INSTALL_PATH --enable-fortran --enable-cxx
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
fi

exit 0

# EOF
