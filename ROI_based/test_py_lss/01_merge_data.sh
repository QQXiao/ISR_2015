basedir=/seastor/helenhelen/ISR_2015	
#resultdir=$basedir/data_singletrial/ms_LSS/ref_space
resultdir=$basedir/data_singletrial/test_py
datadir=$basedir/ISR01/analysis

#substart=$1
#subend=$2
#for ((m = $substart; m <= $subend; m++))
for m in 1
#for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for ((m=5; m<=21; m++))
do
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
#merege file
for cc in py_lss py_tmap matlab_lss
do
#for c in encoding test
#do
#for r in 1 2
#do
#for s in 1 2
#do
#cp $datadir/single_${c}_run${r}_set${s}.feat/betaseries/ev1_lss.nii.gz $resultdir/py_lss_${c}_run${r}_set${s}.nii.gz
#cp $datadir/single_${c}_run${r}_set${s}.feat/betaseries/ev1_lss_tmap.nii.gz $resultdir/py_tmap_${c}_run${r}_set${s}.nii.gz
#cp $datadir/single_${c}_run${r}_set${s}.feat/stats/pe1ls_one_at_time.nii.gz $resultdir/matlab_lss_${c}_run${r}_set${s}.nii.gz
#fsl_sub fslmerge -t $resultdir/run/${cc}_${c}_run${r} $resultdir/${cc}_${c}_run${r}_set*.nii.gz
#done #s
#done #r
#fsl_sub fslmerge -t $resultdir/cond/${cc}_${c} $resultdir/run/${cc}_${c}_*.nii.gz
#done #c
fsl_sub fslmerge -t $resultdir/all/${cc} $resultdir/cond/${cc}_*.nii.gz
done #cc
done #sub
