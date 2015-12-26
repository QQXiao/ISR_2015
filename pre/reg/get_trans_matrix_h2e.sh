basedir='/seastor/helenhelen/ISR_2015'
resultdir=$basedir/data_singletrial/transform
m=$1
#for ((m=5; m<=21; m++))
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
highres_file=$basedir/ISR${SUB}/data/anatomy/highres_brain.nii.gz
ref_file=$basedir/ISR${SUB}/data/bold/ref.nii.gz
SUBDIR=$basedir/ISR${SUB}
h2e_affine=$resultdir/h2e/sub${SUB}
fsl_sub ANTS 3 -m MI[$ref_file,$highres_file,1,32] -o ${h2e_affine}_ --rigid-affine true -i 0
