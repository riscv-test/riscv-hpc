#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# /lib/fftw-3.3.8.sh
#
# FFTW 3.3.8 Release
#
# http://www.fftw.org/
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=
ARCHIVE=http://www.fftw.org/fftw-3.3.8.tar.gz
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
tar xzvf $ARCHIVE
mv fftw-3.3.8 $SRC
cd $SRC

#------------------------------------------------
# STAGE-3: INITIATE THE BUILD
#------------------------------------------------
./configure CC="$RV_CC" CFLAGS="$RV_CFLAGS -O3"
make -j$MAX_THREADS
make install

exit 0

# EOF