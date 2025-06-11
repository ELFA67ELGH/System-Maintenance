#!/bin/ksh
while true
do

echo "		        	Monthly_Report
		        	**************
#echo "
#1)  Monthly Outages CB Report [sumary (outages number & total_out_time for all outages)]
#	aedc_CBFailMonthlyfromTSCC7.ksh
# 
#______________________________________________________________"

echo "
2)  From IQ Report (Alexandria Load Graph MWA Monthly )
 to pc [ System_bcp(F:)/SCADA_backup/REPORTS/MonthlyIQ/2015/alex_mwa_april2015.jpg ]
1 copy (SW)
______________________________________________________________

3)  Total Max Load Report 	
			 aedc_SS_tr_ld.ksh
   /home/sis/REPORTS/SS_LD/Monthly/
"
#Run On  External Dxterm Run : 
# 				aedc_total_max_load_fromAmp.ksh
#		    00:00:00 to 23:59:59
#	     &	    08:00:00    14:00:00
#*O/P ----->/home/sis/REPORTS/SUM-SS/Details/ 

echo "______________________________________________________________
4)  Monthly SS_Traans.Ld Report : 
				aedc_dly_max_ld_rp_AMP.ksh
*O/P  ----->/home/sis/REPORTS/MONTH_LD_REPORT/
______________________________________________________________

5)  SS Trans. Consumptions MWHr :
				 aedc_TR_KWH.ksh
*O/P -----> /home/sis/REPORTS/KWH/
______________________________________________________________

6) Note : Use  add_CutOff.ksh  
   Alexadria Max Load Mwatts:	aedc_ALEX_MAX_LD.ksh
       				aedc_AlexLdProfile_for_MonthlyPeakDay.ksh

*O/P -----> /home/sis/REPORTS/nondelivered_report/
  Copies 5X2 Report   { Chairman , Eng.Nagy, Eng.Nazynie(Amany),FollowUp & SW }
______________________________________________________________"

echo "
7b) Monthly Cable failures Report
      .  aedc_CableFail_report
7 copies (Eng.Elfoly&Eng.Talaat)
______________________________________________________________"

#echo "
#8) Alexandria Load Profile for monthly peak day
#         aedc_AlexLdProfile_for_MonthlyPeakDay.ksh
#2 copies (Eng.Nazynie(AMANY) & SW )
#______________________________________________________________
echo "7) Alex.Trans.SS Peak load (Mwatt)
      			aedc_ss_AtPeak_multidays.ksh
*O/P -----> /home/sis/REPORTS/Temporary/Mervat/Load_20_21_from_Database/Peak
 1 copy   (Eng.Mervat)
______________________________________________________________
8) a/Updating File Alex_load_ratio (PC1)
      E:\Reports\Alex_load\Alexandria_ld
   b/Updating File CutOff_grp & ALEX_REDUCE_LOADES.tlg (PC1)
      E:\software/cutOff_grp/

9) please reduce /nfs size 

10) please prepare  east,middle Substations I/O load
				1 copy   (Eng.Abd Elsalam ) 
______________________________________________________________
"
echo  "Last step executed: $cmd
"
read cmd?"  Your choice (<q> to quit) > "

if [[ -z ${cmd} ]]
  then
    cmd=b
  fi
   if [ $cmd = "q" ]
  then
    break
  fi

case ${cmd} in

#1 )clear
# echo " 
#2 copies  ( Eng.Elfoly & Eng.Amany)  
#"
#	$SCCROOT/aedc_CBFailMonthlyfromTSCC7.ksh
#;;

2 ) 
echo " 
`tput blink`  From IQ Report (Alexandria Load Graph MWA Monthly )  `tput sgr0`
  1 copies  ( SW ) 
 "  
#echo " From IQ Report (Alexandria Load Graph MWA Monthly )  "
 
 ;;


3 )
#	$SCCROOT/aedc_total_max_load_fromAmp.ksh
	$SCCROOT/aedc_SS_tr_ld.ksh
 ;;

4 )

	$SCCROOT/aedc_dly_max_ld_rp_AMP.ksh
 ;;

5 )

	$SCCROOT/aedc_TR_KWH.ksh
;;

6 )  outDir6="/home/sis/REPORTS/nondelivered_report" 
. $SCCROOT/aedc_ALEX_MAX_LD.ksh
outDir6a="${outDir6}/ALEX_MaxDlyLd/`var_asctime  $asc_from  '%Y'`"
MkChkDir $outDir6a 
	
	read cpy?"
`ls -top ${outDir6a}/max_load_aedc*|sed "s-${outDir6a}/--"`
 Save in $outDir6a     y/[n]  >> "
case v${cpy} in
vy|vY|vyes|vYes|vYES) 
echo "Coping out file to $outDir6a"

cp -p /tmp/scc/max_load_aedc \
      ${outDir6a}/max_load_aedc1`var_asctime  $asc_from  "%b%Y"`
;;
esac

#============================
sleep 5
clear
echo " 
     DCC daily Maximum Load 
"	
sleep 3	

. $SCCROOT/aedc_LD_east_mid_west_alex.ksh 
outDir6b="${outDir6}/DCC_MaxDlyLd/`var_asctime  $asc_from  '%Y'`"
MkChkDir $outDir6b 
final_fl_b=DCC_max_load_`var_asctime  $asc_from  "%b%Y"`

read cpy?"
`ls -top ${outDir6b}/*|sed "s-${outDir6b}/--"`
 Save in $outDir6b     y/[n]  >> "
case v${cpy} in
vy|vY|vyes|vYes|vYES) 
echo "Coping out file to $outDir6b"

cp -p /tmp/scc/aedc/ld_final_aedc.dat ${outDir6b}/${final_fl_b}
cp -p /tmp/scc/aedc/EastLdFinal ${outDir6b}/E_${final_fl_b}
cp -p /tmp/scc/aedc/MiddleLdFinal ${outDir6b}/M_${final_fl_b}
cp -p /tmp/scc/aedc/WestLdFinal ${outDir6b}/W_${final_fl_b}
;;
esac


#============================
sleep 5
clear
echo " 
     Alex. Load Profile  At Peak Load 
"	
sleep 3	


. $SCCROOT/aedc_AlexLdProfile_for_MonthlyPeakDay.ksh
outDir6c="${outDir6}/LD_PROFILE/`var_asctime  $asc_from  '%Y'`"
MkChkDir $outDir6c 
final_fl=`echo $PkDay_titel| awk '{print substr($3,1,3)$4}'`_ldProfile

read cpy?"
`ls -top ${outDir6c}/*|sed "s-${outDir6c}/--"`
 Save in $outDir6c     y/[n]  >> "
case v${cpy} in
vy|vY|vyes|vYes|vYES) 
echo "Coping out file to $outDir6c"

cp -p $SCCTMP/LdProf_outFl ${outDir6c}/${final_fl}
;;
esac



;;

7b )clear
 echo "

 2 copies (Eng.Elfoly & Eng.Talaat)

 "

     .	$SCCROOT/aedc_CableFail_report
;;


7) 
  . $SCCROOT/aedc_ss_AtPeak_multidays.ksh
out_dir=/home/sis/REPORTS/Temporary/Mervat/Load_20_21_from_Database/Peak

mktime `date -u +"%Y/%m/01:00:00:00"` | read strt_crnt_mn
var_asctime `expr $strt_crnt_mn - 7200` "Peak_%b%y" | read out_fl

if [ ! -z "`grep $out_fl $out_dir`" ]
then
echo "replacing the existing file $out_fl by ${out_fl}_found"
cp ${out_dir}/$out_fl ${out_dir}/${out_fl}_found
fi
cp /aedc/tmp/SS_PEAK_LD/final ${out_dir}/$out_fl 
;;

*)  echo Sorry it is  wrong input, try again
        esac


read reply?"   Hit <CR> to continue    "
done
