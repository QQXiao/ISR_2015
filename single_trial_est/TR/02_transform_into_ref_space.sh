basedir='/seastor/helenhelen/ISR_2015'
resultdir=$basedir/data_singletrial/TR/ref_space/sep
datadir=$basedir/data_singletrial/TR/native_space
#resultdir=$basedir/data_singletrial/ms_LSS/ref_space/sep
mkdir $resultdir -p
affinedir=$basedir/data_singletrial/transform/n2e
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for ((m=5; m<=21; m++))
do
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
reffile=$basedir/ISR${SUB}/data/bold/ref.nii.gz
for c in encoding test
do
for r in 1 2
do
for s in 1 2
do
    for t in 1 2 3 4
    do
datafile=$datadir/sub${SUB}_${c}_run${r}_set${s}_${t}TR.nii.gz
fsl_sub WarpTimeSeriesImageMultiTransform 4 $datafile $resultdir/${c}_sub${SUB}_run${r}_set${s}_${t}TR.nii.gz -R $reffile $affinedir/sub${SUB}_${c}_run${r}_set${s}_Affine.txt
done
done
done
done
done

