#!/bin/sh
basedir='/seastor/helenhelen/ISR_2015'
#datadir=$basedir/Searchlight_RSM/ref_space/LSS/zscore/diff
#resultdir=$basedir/Searchlight_RSM/standard_space/LSS/zscore/sub
datadir=$basedir/Searchlight_RSM/ref_space/glm/diff
resultdir=$basedir/Searchlight_RSM/standard_space/glm/sub
mkdir $resultdir -p
affinedir=$basedir/data_singletrial/transform/e2t
templatefile=/opt/fmritools/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz
#for ((m=5; m<=21; m++))
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
        for c in ln_mem mem_ln
        do
	datafile=$datadir/${c}_DBwc_${sub}.nii.gz
WarpImageMultiTransform 3 ${datafile} $resultdir/${c}_DBwc_${sub}.nii.gz -R $templatefile $affinedir/${sub}_Affine.txt
	done
done
