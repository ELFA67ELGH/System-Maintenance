#!/bin/ksh
#------------------------------------------------------------------------------
# TITLE   :  aedc_cleanning 
# PURPOSE : Cleanning core and temp files
#
# GROUP   : IS of SCC
# DATE    : 14 April 1999
#------------------------------------------------------------------------------
# @(#) $Header$
# $Log$
#------------------------------------------------------------------------------

date
find /aedc/err -name "core"  -exec rm -ef {} \;
df
echo
