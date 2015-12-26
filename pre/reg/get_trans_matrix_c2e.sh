basedir='/seastor/helenhelen/ISR_2015'
resultdir=$basedir/data_singletrial/transform
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
#for ((m=5; m<=21; m++))
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
highres_file=$basedir/ISR${SUB}/data/anatomy/highres_brain.nii.gz
coronal_file=$basedir/ISR${SUB}/data/anatomy/coronal_ND.nii.gz
ref_file=$basedir/ISR${SUB}/data/bold/ref.nii.gz
SUBDIR=$basedir/ISR${SUB}
h2e_affine=$resultdir/h2e/sub${SUB}_
c2h_affine=$resultdir/c2h/sub${SUB}_
c2e_affine=$resultdir/c2e/sub${SUB}_
# calculate coronal_mean to ORIG transforms
fsl_sub ANTS 3 -m MI[${highres_file},${coronal_file},1,32] -o ${c2h_affine} --rigid-affine true -i 0
#fsl_sub ComposeMultiTransform 3 ${c2e_affine} -R ${h2e_affine} ${h2e_affine} ${c2h_affine}
done
