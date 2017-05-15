#!sh/bin/
basedir=/seastor/helenhelen/ISR_2015
datadir=$basedir/data_singletrial/glm/all_std
resultdir=$basedir/ROI_based/std_space/glm/raw
mkdir -p $resultdir
roidir=/seastor/helenhelen/roi/ISR/single
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
    for roi in $roidir/*.nii.gz
    do
        roi_prefix=`basename $roi | sed -e "s/.nii.gz//"`
        fsl_sub -q verylong.q fslmeants -i $datadir/${sub}.nii.gz --showall -m $maskdir/${roi_prefix} -o $resultdir/${sub}_${roi_prefix}.txt
    done
done
