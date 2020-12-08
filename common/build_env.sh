#!/bin/bash -xe
#
# RISC-V HPC Test Suite
#
# Common Build Test Script
#
# common/build_test.sh
#

#------------------------------------------------
# ARGUMENTS
#------------------------------------------------
# $1 = TEST NAME
# $2 = NODE NAME
# $3 = NODE LABELS
# $4 = MAX THREADS
# $5 = TEST SOURCE
#------------------------------------------------

#------------------------------------------------
# SETUP THE ENVIRONMENT VARIABLES
#------------------------------------------------
mkdir -p $WORKSPACE/build
export BUILDROOT="$WORKSPACE/build"
export INSTALL_PATH="$WORKSPACE/$1-INSTALL"

#------------------------------------------------
# PRINT THE ENVIRONMENT
#------------------------------------------------
echo "-----------------------------------------------------------"
echo " DATE         = `date`"
echo " TEST NAME    = $1"
echo " NODE NAME    = $2"
echo " NODE LABELS  = $3"
echo " MAX THREADS  = $4"
echo " TEST SOURCE  = $5"
echo " INSTALL PATH = $INSTALL_PATH"
echo "-----------------------------------------------------------"

# EOF
