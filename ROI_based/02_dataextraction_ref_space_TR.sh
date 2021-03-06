#!sh/bin/
basedir=/seastor/helenhelen/ISR_2015
roidir=/seastor/helenhelen/roi/ISR
#roidir=/seastor/helenhelen/roi/ISR/sub_hipp
#roidir=/seastor/helenhelen/roi/ISR_add
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for m in 1
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
maskdir=$basedir/${SUB}/roi_ref
#maskdir=$basedir/${SUB}/roi_ref/sub_hipp
datadir=$basedir/data_singletrial/TR/ref_space/set
resultdir=$basedir/ROI_based/ref_space/TR/raw
mkdir $resultdir -p
        #for roi in $roidir/*.nii.gz
        for roi in $maskdir/*.nii.gz
        do
        roi_prefix=`basename $roi | sed -e "s/.nii.gz//"`
        for c in encoding test
        do
            for t in 1 2 3 4
            do
            fsl_sub -q verylong.q fslmeants -i $datadir/${c}_${sub}_${t}TR.nii.gz --showall -m $maskdir/${roi_prefix} -o $resultdir/${c}_${sub}_${roi_prefix}_${t}TR.txt
            done
        done
        done # roi
done # sub
