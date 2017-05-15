#!sh/bin/
basedir=/seastor/helenhelen/ISR_2015
datadir=$basedir/data_singletrial/glm/all
resultdir=$basedir/data_singletrial/glm/all_std
affinedir=$basedir/data_singletrial/transform/e2t
templatefile=/opt/fmritools/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz

for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       sub=sub0${m}
       SUB=ISR0${m}
    else
        sub=sub${m}
        SUB=ISR${m}
    fi
    echo $SUB
datafile=$datadir/${sub}.nii.gz
fsl_sub -q verylong.q WarpTimeSeriesImageMultiTransform 4 ${datafile} ${resultdir}/${sub}.nii.gz -R $templatefile $affinedir/${sub}_Affine.txt
done
