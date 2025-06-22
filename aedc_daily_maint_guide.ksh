#!/bin/ksh
#------------------------------------------------------------------------------
# TITLE   : aedc_daily_maint_guide
# PURPOSE : display and run all available daily utilities
#           
# GROUP   : IS
# DATE    :25 JANUARY 2000
# Modification 20 Feb 2005  by Abeer Elasyed  
#    to simplified the check sybase log procedure
#------------------------------------------------------------------------------
# Define environment variables
#
. /aedc/etc/setsccenv.ksh
. $SCCROOT/aedc_SCC_functions
dly_tmplt=/home/sis/REPORTS/Daily_Templet

function GET_SELECTION {
  echo "Select one or more nodes from This list:"
  echo "<< $1 >>"
  echo \

  read SELECTION?"Selected Node(s) >"
  echo ""
}


####################################################################
# -- Main loop; get and execute user command until the 'quit'
#    command is selected
####################################################################


enter_his_date_range 
mktime ${date1_asc}:00:00 |read asc_day
mktime ${date1_asc}:00:00|read d1
d2=`expr ${d1} + 86400 `
  

read da_temp?" Daily Templete Tasks [ y or n ] >> "
case $da_temp in
y|Y) 

var_asctime $asc_day '%Y_%m'|read mnth

var_asctime $asc_day '%d/%m/%Y'|read curnt_day
var_asctime $d2 '%d/%m/%Y'|read curnt_day2

echo "\n Current Day is `tput blink``tput bold` $curnt_day2 `tput sgr0`\n "

grep -e "From" $dly_tmplt/$mnth/1wek_daly_temp |read Fstwek
grep -e "From" $dly_tmplt/$mnth/2wek_daly_temp |read Sstwek
grep -e "From" $dly_tmplt/$mnth/3wek_daly_temp |read Tstwek
grep -e "From" $dly_tmplt/$mnth/4wek_daly_temp |read Rstwek
cd $dly_tmplt/$mnth/
ls -Ftl|awk '{print $9}'|sort -n|tail -1|read Rec
	if [ $Rec = "5wek_daly_temp" ]
	then
	grep -e "From" $dly_tmplt/$mnth/5wek_daly_temp |read Vstwek
	read chse_wek?" There are ranges of each week [ choose 1,2,3,4 ]

	1 ) 1stWeek $Fstwek 

	2 ) 2ndWeek $Sstwek 

	3 ) 3rdWeek $Tstwek 

	4 ) 4thWeek $Rstwek 

	5 ) 5thWeek $Vstwek  
 

 >> "
	else

read chse_wek?" There are ranges of each week [ choose 1,2,3,4 ]

	1 ) 1stWeek $Fstwek 

	2 ) 2ndWeek $Sstwek 

	3 ) 3rdWeek $Tstwek 

	4 ) 4thWeek $Rstwek 

 >> "
	fi

case $chse_wek in

	1) cd $dly_tmplt/$mnth/
DISPLAY=ascdts:0.1
xedit $dly_tmplt/$mnth/1wek_daly_temp & ;;

	2) cd $dly_tmplt/$mnth/
DISPLAY=ascdts:0.1
xedit $dly_tmplt/$mnth/2wek_daly_temp & ;;

	3) cd $dly_tmplt/$mnth/
DISPLAY=ascdts:0.1
xedit $dly_tmplt/$mnth/3wek_daly_temp & ;;

	4) cd $dly_tmplt/$mnth/
DISPLAY=ascdts:0.1
xedit $dly_tmplt/$mnth/4wek_daly_temp & ;;


	5) cd $dly_tmplt/$mnth/
DISPLAY=ascdts:0.1
xedit $dly_tmplt/$mnth/5wek_daly_temp & ;;


	*) 
	 ;;
	esac
 ;;

n|N)
 ;;

*) 
 ;;
esac

DISPLAY=ascdts:0.0

while true
do
mktime ${date1_asc}:00:00 |read asc_day  
var_asctime $asc_day '%d/%m/%Y'|read day

  clear
echo   "                    Daily Maintenance Utility 
 for:	 $range          
		 __________________________________"

echo "
 1 ) Check & clean nodes size.  

 2 ) Check DISK PLEX and HISTALM      
			 	( aedc_diskplex_check.ksh )"
# 30 ) Check daily backup log files.
 				#( aedc_dump_daily.ksh )
echo "
 3 ) Dealing with 'ECC down problem' :

    3a ) Prepare Daily load report : choose eastimated east	
				( aedc_LD_east_mid_west_alex.ksh )
    3b ) Fillin estimated data in the Database
				( fillin_estimated_Eastload_inDB.ksh )
    3c ) recreate acc,pkacc historical files after fillin
 				( aedc_daily_copy_his_cronjob.ksh )
 4 ) Check if nfs is mounted & it's size.
				( aedc_nfs )
 5 ) Check copy historical alarms log
				( aedc_daily_copy_his.ksh )
 6 ) STABILITY OF SCC SITE STATUS Communication Reports			
        			(aedc_local-status)"
#Check if IS&R is running:
#___________________________
#   7a) Check if the optical disk mount      7b) Load the optical disk

echo "
 8 ) Check ECS/m databas  {ECS/m db debug tool 
				(aedc_make-eddt-log.ksh )	 
 9 ) Check SYBASE Log.	
				
 10 ) Check time synch                     
				( aedc_timediff_used )
 11) Check free kbyte for aedcdb "

# 12 ) Communication Reports     ( aedc_daily_commuication_check )
            
echo "  =========================================================
 13) Maximium  Transformer Load  Daily Report 
				( aedc_dly_max_ld_rp_AMP.ksh )"
# 14) Daily CB outages Reports
#				(aedc_CBFailDailyFromTSCC7.ksh)
#				[ 3 copies:E.Magdy,E.Talaat&E.Fouly  ]
echo "
 15) Maximium/Minimium  Transformer Volt  Report 
				( aedc_get_max_min_volt.ksh )
				
 17) Outging feeder Cable  % load
				( aedc_PercntOutFeederLoading.ksh )"
#echo"
# 16) Cable Fail report		( aedc_CableFail_report )

# 18) IQ-chart
#"

#14 ) NSR backup check# 16) Transformer Volt  Daily Report 

cal | cut -c 17-19 | grep [0-9] | tail -1 | read last_Thu

case `date | awk '{print $3}'` in
25)
echo  "`tput blink` *)`tput sgr0``tput bold` Start Monthly SW Report`tput sgr0` "
;;

#${last_Thu})
#echo  "`tput blink` 19c)`tput sgr0``tput bold` Last Thurthday of month Report
#				( aedc_max_value_from_DHAVG.ksh )
#				[ 2 copy:Eng.Nagy , Eng.M ElFoly ]`tput sgr0` ";;
esac

case `date | awk '{print $1}'` in
Thu)
echo  "`tput blink` 19a)`tput sgr0``tput bold` Weekly Alex PF chart
				 ( aedc_ALEX_PF.ksh )
				 [ save the O/P on PC at 
				 E:\Report\Misc_reports\Power_Factor\2010 ]`tput sgr0` "


echo  "`tput blink` 19b)`tput sgr0``tput bold` Move SCC_save Files To PC
				 [ save the O/P on PC at 
				 D:\E=Software\Previous_SccSave\ ]`tput sgr0` "
;;
Sat)
echo  "`tput blink` 19d)`tput sgr0``tput bold` Weekly Max. Alex Load
				 ( aedc_ALEX_MAX_LD.ksh )
				 [ Report the O/P on PC on the cover letter in
				 D:\E=Software\Templates\Forms\letters\cover letters\ ]`tput sgr0` "

;;
esac


echo "
 20) Substation Trans. Daily Load Report 
				( aedc_SS_tr_ld.ksh )"
				
#echo " 21) Industrial Load At 19,20,21
# 				( aedc_IndustrialCutOff_dailyRep.ksh )"

echo  "Last step executed: $maincmd  
"
read maincmd?" `tput bold` Your choice (<q> to quit) >`tput sgr0` "

  if [[ -z ${maincmd} ]]
  then
    maincmd=b
  fi
   if [ $maincmd = "q" ] 
  then
    break
  fi


#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  case ${maincmd} in

    1) 
NODE_LIST="ascdac1 ascdac2 ascsys1 ascsys2 ascoper1 ascoper2 ascdts"
export NODE_LIST
    ecsdo  $SCCROOT/aedc_cleanup.ksh
          ;;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    2)
      cd  $SCCROOT
      aedc_diskplex_check.ksh
;;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    3a )
echo "Prepare Daily load report ,please choose eastimated east" 
cd $SCCROOT
       aedc_LD_east_mid_west_alex.ksh
#head -8 /tmp/scc/aedc/ld_final_aedc.dat > /tmp/scc/aedc/ld_final_aedc_avg.dat
#grep "[0-9]" /tmp/scc/aedc/ld_final_aedc.dat|grep "|" | 
#    sort -u > /tmp/scc/aedc/ld_tmp  
    
#cat /tmp/scc/aedc/ld_tmp >> /tmp/scc/aedc/ld_final_aedc_avg.dat 
#grep "|" /tmp/scc/aedc/ld_final_aedc.dat|
#    grep [__] | sort -u >> /tmp/scc/aedc/ld_final_aedc_avg.dat
    
#awk '{sum+=$11}END{print " Average :\t"sum/NR}' /tmp/scc/aedc/ld_tmp >> /tmp/scc/aedc/ld_final_aedc_avg.dat

#cat /tmp/scc/aedc/ld_final_aedc_avg.dat
#_PRT /tmp/scc/aedc/ld_final_aedc_avg.dat
;;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    3b )
echo "Fillin estimated data in the Database"
cd $SCCROOT
       fillin_estimated_Eastload_inDB.ksh
;;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    3c )
echo "recreate acc,pkacc historical files after fillin" 
cd $SCCROOT
echo ${date1_asc} | cut -c 1-10 | read sug_recrt_day
read recrt_day?"Enter date to ecreate acc,pkacc < ${sug_recrt_day} > >> "
if [ -z "${recrt_day}" ]
then
recrt_day=$sug_recrt_day
fi
       aedc_daily_copy_his_cronjob.ksh -d "${recrt_day}" -t acc
       aedc_daily_copy_his_cronjob.ksh -d "${recrt_day}" -t pkacc

;;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    30)
echo Check daily backup log files 
cd $SCCROOT
       aedc_dump_daily.ksh
;;

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    4)  #
cd  $SCCROOT/

      aedc_nfs
	;;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

       5) 
#	$SCCROOT/aedc_daily_copy_his.ksh
echo $date1_asc|awk 'FS=":" {print $1}'|awk 'FS="/",OFS="\n"{print $1,$2,$3}'|
	{ read yyyy ; read mm ; read dd ; }
echo "${dd}_${mm}_${yyyy}" | read day
echo "${yyyy}_${mm}_${dd}" | read day1
echo   "			CronJob  Task Check 
		=========="
echo "1) Historical File (Alarm & Acct) :
-----------------------------------------"
ls -Ftl /aedc/err/scc/his_alarm_size_check.log|awk 'FS="sis"{print $2}'
ls -Ftl /aedc/data/*.his
grep sis  /aedc/err/scc/copy_his.log|awk '{print $9,"\t",$7"-"$6,$8"\t"$5"\tByte"}'|
sort -k3|sed 's-/aedc/data/nfs/historical/-   -'	

echo "\n Report Files  :
-----------------------------------------"
n=2
 for DirLable in DAILY_MAX_VALUE Wednesday_OUTSS_max_value Dly_MinMaxVOLT Shabakat
 do
 echo "\n ${n}) "
 for RepDir in "/home/sis/REPORTS" "/SYBASE/sub_home/REPORTS"
 do
 cd ${RepDir}/${DirLable}/${yyyy}_${mm}/ 
 echo "`pwd`/ >>"
   if [ -z "`ls -top | grep aedc | grep ${day1}`" ] 
   then
   echo "	file for ${day1} is not found"
   else 
   ls -top | grep aedc | grep ${day1} | awk 'FS="aedc"{print "\t",$2}'
   fi
 done
 n=`expr $n + 1`
 done
cd $SCCROOT

echo "\n6) CableFailure  error /aedc/err/scc/CableFail_log   :
------------------------------------------ "
grep -p `echo $date1_asc |cut -c 1-10` /aedc/err/scc/CableFail_log | 
   grep -p -e Level -e "More Than One" -e "rerun" -e "sw_id"  |grep -v  row |wc -l |awk '{print $1}' |read no
 if [ $no -eq  0 ]
then
echo ">>  No Error messeges Found <<
 "
else
grep -p `echo $date1_asc |cut -c 1-10`  /aedc/err/scc/CableFail_log |
   grep -p -e Level -e "More Than One" -e "rerun" -e "sw_id"  |grep -v  row
fi

echo "\n7) OutagesNotes  error /aedc/err/scc/OutagesNotes_log  :
-------------------------------------------- "
grep -p `echo $date1_asc |cut -c 1-10` /aedc/err/scc/OutagesNotes_log | 
   grep -p -e Level -e "More Than One" -e "rerun"  |grep -v  row |wc -l |awk '{print $1}' |read no
 if [ $no -eq  0 ]
then
echo ">>  No Error messeges Found <<
 "
else
grep -p `echo $date1_asc |cut -c 1-10`  /aedc/err/scc/OutagesNotes_log |
   grep -p -e Level -e "More Than One" -e "rerun" |grep -v  row
fi
;;

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     6) echo Check the STABILITY OF SCC SITE STATUS
    cd $SCCROOT/
      aedc_local-status
;;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
   7a) check_master_sys
	echo  Check if "IS&R" is running
      cd  $SCCROOT
          optical_disk_size
#cd   $SCCROOT
         aedc_optical_check
;;
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    7b) 
       check_master_sys

 #rsh $DBA_HOST   "ls -l /od0/"
OPT_HOST=`rsh $DBA_HOST "df|grep od0|wc -c"`
  if [ $OPT_HOST -eq 0 ]
then
echo "the optical disk is not mount you can't load it"
else
read request?"Do you want to load the optical disk (y/n )> "
if [ "`echo $request`" = "y" ]
then
idli
fi
fi
;;
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      8) . $SCCROOT/aedc_make-eddt-log.ksh
              ;;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

     9)
 if [[ -z ${date1_asc} ]]
 then
 read current_date?"enter the date on the form  yy/mm/dd <CR>to exit : >>>>> "
 else
# var_asctime `mktime $date1_asc` %d/%m/%Y|read current_date1
 var_asctime `mktime $date1_asc` %y/%m/%d|read current_date
 echo The currently date is $current_date

 read   date?"Do you want to enter a new date  < y/n > : "
   case ${date} in
    y|Y)
 read current_date?"enter the date on the form  yy/mm/dd  <CR>to exit :>>>>> " ;;
     esac
 fi
    asctime `mktime "20${current_date}:00:00:00" ` | cut -c 5-10 | read current_date2
var_asctime `mktime "20${current_date}:00:00:00" ` %d/%m/%Y | read current_date1
 
rm -f $SCCTMP/sys1.tmp  $SCCTMP/sys2.tmp

for node in  ascsys1 ascsys2
do

echo $node | sed 's/asc//'|read nam
rm -f  $SCCTMP/${nam}.tmp
echo "
"
echo "
$node SYBASE Log $current_date1 :
________________________________ " |tee $SCCTMP/${nam}.tmp
 rsh $node  " grep  $current_date  /aedc/err/sybase_sql.log |grep -v DBCC " |tee -a  $SCCTMP/${nam}.tmp
no=`wc -l $SCCTMP/${nam}.tmp |awk '{print $1}' `
 if [ $no -lt  4 ]
then
echo
echo "There is no error message in $node" |tee -a  $SCCTMP/${nam}.tmp
fi
#echo " PLEESE .......
#check the command
# < rsh $node  'sudo grep  plex  /var/adm/messages '
#"
echo "
$node Plex messages $current_date2 :
________________________________ " |tee $SCCTMP/plex${nam}.tmp
sudo rsh $node  "tail -200  /var/adm/messages|grep  plex " >  $SCCTMP/allplex${nam}.tmp
grep "$current_date2" $SCCTMP/allplex${nam}.tmp | tee -a $SCCTMP/plex${nam}.tmp
no1=`wc -l $SCCTMP/plex${nam}.tmp |awk '{print $1}' `
 if [ $no1 -lt  4 ]
then
echo
echo "There is no Plex error message in $node" |tee -a  $SCCTMP/plex${nam}.tmp
fi

done
echo "
"
 ;;

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     10) echo Check time synch
    . $SCCROOT/aedc_timediff_used
;;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    11) clear

echo "
print 'aedcdb DataBase'
go
sp_helpdb aedcdb
go
print 'dbcontrol DataBase'
go
sp_helpdb dbcontrol
go
print 'iutddb DataBase'
go
sp_helpdb iutddb
go"|isql -Udbu -Pdbudbu |grep -e DataBase -e only -e " ------------------------------ " -e "fragments" |
    awk '{if($5=="only")
    {printf("%-31s %6s %-8s %2d%%\t\t%14s\n",$1,$2,$3,100*(($2*1024)-$6)/(1024*$2),$6)}
    else
    print $0 }'

ls -l /aedc/err/scc/prev_spaceused.log /aedc/err/scc/spaceused.log|awk '{print $6,$7,$8}'|{ read space_from ; read space_to ;}  
echo "\n\n  Check change in historical tables size from `tput bold`${space_from}`tput sgr0` to `tput bold`${space_to}`tput sgr0` .... \n
table				size_increase(KB)
-----------------------------	-----------------"
comm -23 /aedc/err/scc/prev_spaceused.log /aedc/err/scc/spaceused.log > /aedc/tmp/scc/prev_space_diff
comm -13 /aedc/err/scc/prev_spaceused.log /aedc/err/scc/spaceused.log > /aedc/tmp/scc/currnt_space_diff
paste /aedc/tmp/scc/prev_space_diff /aedc/tmp/scc/currnt_space_diff|awk '$1==$4{printf("%-30s\t%d\n",$1,$5-$2)}'

#comm -3 /aedc/err/scc/prev_spaceused.log /aedc/err/scc/spaceused.log|awk '{for (i=0;i<=NR;i++)
#if (NR == 2*i+1) printf("%s ", $0)
#else
#if (NR == 2*i) printf("%s\n", $0)}'|awk '$1==$4{printf("%-30s\t%d\n",$1,$5-$2)}'
echo
;;


   12)
    cd $SCCROOT/
  .  aedc_daily_commuication_check 
;;


   13)
    cd $SCCROOT/
   clear
  .  aedc_dly_max_ld_rp_AMP_eastdown16May22.ksh
  .  aedc_Filter_dly_max_ld_rp_AMP.ksh	${DAILY_LD_REPORT}.Z 
;;

#14) echo NSR backup
#         nwadmin
#       ;;
   14)
	$SCCROOT/aedc_CBFailDailyFromTSCC7.ksh
#	$SCCROOT/aedc_CBFail.ksh
;;
   15)
    cd $SCCROOT/
   clear
  .  aedc_get_max_min_volt.ksh
 echo "$date1_asc" | cut -c1-7 | sed 's@/@_@' | read SubOutDir
 
for MainDir in "/home/sis/REPORTS/DAILY_Max_Min_VOLT" "/SYBASE/sub_home/REPORTS/DAILY_Max_Min_VOLT"
do
if [[ ! -d ${MainDir}/$SubOutDir ]]
then
    mkdir ${MainDir}/$SubOutDir
fi
  ls ${MainDir}/${SubOutDir}/`basename $Out_Fl` | grep "not found" | read chk
  if [ -z "$chk" ]
  then

  echo "coping $Out_Fl to ${MainDir}/${SubOutDir}/"
  cp $Out_Fl ${MainDir}/${SubOutDir}/
  else
  echo "there is a file named `basename $Out_Fl` under ${MainDir}/${SubOutDir}/"
  read per?"do you want to replace it ? < y|[n] > >> "
if [ "$per" = "y" ]
then
echo "coping $Out_Fl to ${MainDir}/${SubOutDir}/"
cp $Out_Fl ${MainDir}/${SubOutDir}/
fi
fi
done
;;

   16)
    cd $SCCROOT/
   clear
  .  aedc_CableFail_report
;;
   17)
    . aedc_PercntOutFeederLoading.ksh
;;

   18)
clear
echo "\n\n\n ==> Run the procedure  ALEXDCC_LOAD_GPH_MWA_Daily from IQ

 ==> change the date from Utilities menu --> Author 

 ==> print [ 3 copies:E.Fathy,E.Magdy&E.Fouly  ]

 ==> manualy write Alex_Min_load on the copy of E.Rayied"
rsh ascsys . /aedc/etc/.iq.startup `print $DISPLAY`

;;

 #  19a)
 #  . aedc_ALEX_PF.ksh ;;   
 #   19c)
 #echo "Execute the script for yesterday (Last Wednesday of month)"
 #sleep 3
 #    . aedc_max_value_from_DHAVG.ksh ;;


  19d) aedc_ALEX_MAX_LD.ksh ;;
  
#  20) aedc_SS_tr_ld_eastdown16May22.ksh ;;

  20) aedc_SS_tr_ld.ksh ;;

  21) aedc_IndustrialCutOff_dailyRep.ksh ;;
  
   *)  echo Sorry it is  wrong input, try again
	esac

 
read reply?"   Hit <CR> to continue    "
done







