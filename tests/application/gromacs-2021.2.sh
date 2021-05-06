#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# /application/gromacs-2021.2.sh
#
# Gromacs 2021.2
#
# https://manual.gromacs.org/2021.2/download.html
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=
ARCHIVE=https://ftp.gromacs.org/gromacs/gromacs-2021.2.tar.gz
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
tar xzvf gromacs-2021.2.tar.gz
mv gromacs-2021.2 $SRC
cd $SRC

#------------------------------------------------
# STAGE-3: INITIATE THE BUILD
#------------------------------------------------
mkdir build
cd build
CC="$RV_CC" CFLAGS="$RV_CFLAGS" CXX="$RV_CXX" CXXFLAGS="$RV_CXXFLAGS" cmake -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=OFF -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH ../
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
