#!/bin/sh
basedir=/seastor/helenhelen/ISR_2015
datadir=$basedir/Searchlight_RSM/ref_space/zscore/diff
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=ISR0${m}
	sub=sub0${m}
    else
        SUB=ISR${m}
	sub=sub${m}
    fi
    echo $SUB
maskdir=$basedir/${SUB}/roi_ref
	#for c in ERS_IBwc ERS_DBwc mem_DBwc ln_DBwc
	for c in ERS_ID
	do
	resultdir=$basedir/peak/VVC/data/vvc_data/${c}
	mkdir $resultdir -p
	datafile=$datadir/${c}_${sub}.nii.gz
	maskfile=$maskdir/vvc.nii.gz
	resultfile=$resultdir/${sub}.nii.gz
	fsl_sub fslmaths $datafile -mul $maskfile $resultfile
	done
done
