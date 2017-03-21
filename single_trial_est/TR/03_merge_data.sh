basedir=/seastor/helenhelen/ISR_2015
#resultdir=$basedir/data_singletrial/ms_LSS/ref_space
resultdir=$basedir/data_singletrial/TR/ref_space

#substart=$1
#subend=$2
#for ((m = $substart; m <= $subend; m++))
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
#merege file
for t in 1 2 3 4
do
for c in encoding test
do
#for r in 1 2
#do
#fsl_sub fslmerge -t $resultdir/run/${c}_sub${SUB}_run${r}_${t}TR $resultdir/sep/${c}_sub${SUB}_run${r}_set*_${t}TR.nii.gz
#done #g
fsl_sub fslmerge -t $resultdir/set/${c}_sub${SUB}_${t}TR $resultdir/run/${c}_sub${SUB}_run*_${t}TR.nii.gz
done #c
done #t
done #sub
