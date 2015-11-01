#!/bin/sh
basedir='/seastor/helenhelen/ISR_2015'
datadir=$basedir/Searchlight_RSM/ref_space/diff
resultdir=$basedir/Searchlight_RSM/standard_space_fsl/sub
mkdir $resultdir -p
templatefile=/opt/fmritools/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz
#for ((m=5; m<=21; m++))
for m in 1
#for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
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
affinedir=$basedir/$SUB/analysis/pre_encoding_run2_set1.feat/reg
        for c in ln mem
        do
	for cc in DBwc DBall
	do
	datafile=$datadir/${c}_${cc}_${sub}.nii.gz
	resultfile=$resultdir/${c}_${cc}_${sub}.nii.gz
	$FSLDIR/bin/applywarp --ref=$affinedir/standard --in=$datafile --out=$resultfile --warp=$affinedir/highres2standard_warp --premat=$affinedir/example_func2highres.mat --interp=trilinear
	done
	done
	for c in ERS
	do
	for cc in IBwc IBall DBwc DBall ID
	do
	datafile=$datadir/${c}_${cc}_${sub}.nii.gz
	resultfile=$resultdir/${c}_${cc}_${sub}.nii.gz
	 $FSLDIR/bin/applywarp --ref=$affinedir/standard --in=$datafile --out=$resultfile --warp=$affinedir/highres2standard_warp --premat=$affinedir/example_func2highres.mat --interp=trilinear
	done
	done
done
