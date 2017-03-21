#!sh/bin/
basedir=/seastor/helenhelen/ISR_2015
#for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
for m in 1
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
datadir=$basedir/data_singletrial/test_py/all
#datadir=$basedir/data_singletrial/test_py/py
resultdir=$basedir/data_singletrial/test_py/roi
#resultdir=$basedir/data_singletrial/test_py/py
mkdir $resultdir -p
        for roi in $maskdir/tVVC.nii.gz
        #for roi in $maskdir/*.nii.gz
        do
for cc in py_lss py_tmap matlab_lss
do
        roi_prefix=`basename $roi | sed -e "s/.nii.gz//"`
        fsl_sub -q verylong.q fslmeants -i $datadir/${cc}.nii.gz --showall -m $maskdir/${roi_prefix} -o $resultdir/${cc}_${roi_prefix}.txt
done #cc
        done # roi
done # sub
