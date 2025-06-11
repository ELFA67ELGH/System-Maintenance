#!/bin/ksh
#------------------------------------------------------------------------------
#
# TITLE   : cleanup
# PURPOSE : Script to remove unwanted files from various directories under
#           the $CAEROOT.
# GROUP   : SIS
# AUTHOR  : Alaa Nagy
# DATE    : April 4, 2000
# REVISION
# HISTORY :
#------------------------------------------------------------------------------

CAEROOT=/aedc
. setenv.ksh
df |grep -w "aedc_domain#aedc"

   echo "\n cleaning  `hostname` ....\n"

#-------------------------------------------------------------
#added on 2 june 2001 to clean temperary directories  for AEDC  SCC scripts
#------------------------------------------------------------- 
#
find   /aedc/data/maps/  -name  *.cxx -atime +1 -exec rm -ef {} \;
find   /aedc/data/maps/  -name  *.h -atime +1 -exec rm -ef {} \;
find   /aedc/data/maps/ -name *.tmp -atime +1 -exec rm -ef {} \;
find    /aedc/tmp/scc/  -mtime +1 -exec rm -ef {} \;
find    /aedc/tmp/scc/  -ctime +1 -exec rm -ef {} \;
find    /aedc/tmp -depth  -ctime +1 -exec rm -ef {} \;  



#------------------------------------------------------------------------------
# -- Remove editor backup files...
# -- Note that files under the $CAEROOT/src directory are not removed.
#------------------------------------------------------------------------------

find $CAEROOT/bin -name "*~" -exec rm -ef {} \;
find $CAEROOT/cnf -name "*~" -exec rm -ef {} \;
find $CAEROOT/data -name "*~" -exec rm -ef {} \;
find $CAEROOT/err -name "*~" -exec rm -ef {} \;
find $CAEROOT/etc -name "*~" -exec rm -ef {} \;
find $CAEROOT/etc -name ".*~" -exec rm -ef {} \;
find $CAEROOT/include -name "*~" -exec rm -ef {} \;
find $CAEROOT/lib -name "*~" -exec rm -ef {} \;
find $CAEROOT/map -name "*~" -exec rm -ef {} \;

find $CAEROOT/bin -name "#*#" -exec rm -ef {} \;
find $CAEROOT/cnf -name "#*#" -exec rm -ef {} \;
find $CAEROOT/data -name "#*#" -exec rm -ef {} \;
find $CAEROOT/err -name "#*#" -exec rm -ef {} \;
find $CAEROOT/etc -name "#*#" -exec rm -ef {} \;
find $CAEROOT/etc -name "#.*#" -exec rm -ef {} \;
find $CAEROOT/include -name "#*#" -exec rm -ef {} \;
find $CAEROOT/lib -name "#*#" -exec rm -ef {} \;
find $CAEROOT/map -name "#*#" -exec rm -ef {} \;


#------------------------------------------------------------------------------
# -- Remove core files....
#------------------------------------------------------------------------------

find $CAEROOT/bin -name "core" -exec rm -ef {} \;
find $CAEROOT/cnf -name "core" -exec rm -ef {} \;
find $CAEROOT/data -name "core" -exec rm -ef {} \;
find $CAEROOT/etc -name "core" -exec rm -ef {} \;
find $CAEROOT/include -name "core" -exec rm -ef {} \;
find $CAEROOT/lib -name "core" -exec rm -ef {} \;
find $CAEROOT/map -name "core" -exec rm -ef {} \;

# -- under the err directory only delete core files more than
# -- a week old.

 find $CAEROOT/err -name "*core*"  -exec rm -ef {} \;




 
#------------------------------------------------------------------------------
# -- Remove selected files from the cnf and etc directories...
#------------------------------------------------------------------------------

if [[ "`hostname`" != $DEV ]]; then
   rm -ef $CAEROOT/cnf/*~
   echo "`hostname`"
fi


#------------------------------------------------------------------------------
# -- Remove any archive libraries and the so_locations file from the
# -- lib directory...
#------------------------------------------------------------------------------

if [[ "`hostname`" != $DEV ]]; then
   find $CAEROOT/lib -name "lib*.a" -exec rm -ef {} \;
   rm -ef $CAEROOT/lib/so_locations
fi

#------------------------------------------------------------------------------
# -- Special Cleanup...
#------------------------------------------------------------------------------

# -- Remove all unrequired directories from $CAEROOT/data directories...

#------------------------------------------------------------------------------
# -- SCC added..
#------------------------------------------------------------------------------
   rm -ef $CAEROOT/data/maps/*.cxx
   rm -ef $CAEROOT/data/maps/*.h
   rm -ef $CAEROOT/data/maps/*old
   rm -ef $CAEROOT/data/maps/*tmp
   rm -ef $CAEROOT/data/maps/*.sif


df

sleep   2



