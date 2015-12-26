ANTSPATH=/opt/fmritools/ANTs/antsbin/bin/
basedir='/seastor/helenhelen/ISR_2015'
resultdir=$basedir/data_singletrial/transform
#m=$1
#for ((m=5; m<=21; m++))
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
e2t_affine=$resultdir/e2t/sub${SUB}_Affine.txt

e2h_affine=$resultdir/e2h/sub${SUB}_Affine.txt
h2t_affine=$resultdir/h2t/sub${SUB}_0GenericAffine.mat
fsl_sub ComposeMultiTransform 3 $resultdir/e2t/sub${SUB}_Affine.txt -R ${h2t_affine} ${h2t_affine} ${e2h_affine}
done
