basedir=/seastor/helenhelen/ISR_2015
#for m in ((m=5; m<=21; m++))
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=ISR0${m}
    else
        SUB=ISR${m}
    fi

for c in encoding test
do
for r in 1 2
do
for s in 1 2
do
#resultdir=$basedir/${SUB}/analysis/ms_singletrial_${c}_run${r}_set${s}
resultdir=$basedir/${SUB}/analysis/singletrial_${c}_run${r}_set${s}
refdir=$basedir/${SUB}/analysis/pre_${c}_run${r}_set${s}.feat
fsf=$basedir/script/fsf/single_${c}_${SUB}_run${r}_set${s}.fsf
mkdir $resultdir/stats -p

cp $refdir/filtered_func_data.nii.gz $resultdir
cp $refdir/mask.nii.gz $resultdir
cp $refdir/reg $resultdir/ -r
cp ${fsf} $resultdir/design.fsf
cd $resultdir
feat_model design
done
done
done
done
