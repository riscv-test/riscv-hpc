#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# /application/clustal-1.2.4.sh
#
# Clustal 1.2.4
#
# http://www.clustal.org/omega/
#

#------------------------------------------------
# TOP-LEVEL VARIABLES
#------------------------------------------------
TEST=$(basename $0)
REPO=
ARCHIVE=http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz
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
tar xzvf clustal-omega-1.2.4.tar.gz
mv clustal-omega-1.2.4 $SRC
cd $SRC

#------------------------------------------------
# STAGE-3: INITIATE THE BUILD
#------------------------------------------------
CC="$RV_CC" CFLAGS="$RV_CFLAGS" CXX="$RV_CXX" CXXFLAGS="$RV_CXXFLAGS" ./configure --prefix=$INSTALL_PATH
if [ $? -ne 0 ]; then
  exit -1
fi

make
if [ $? -ne 0 ]; then
  exit -1
fi

make install
if [ $? -ne 0 ]; then
  exit -1
fi

exit 0

# EOF
