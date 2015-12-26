basedir='/seastor/helenhelen/ISR_2015'
templatefile=/opt/fmritools/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz
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
# n2h
e2h_affine=$resultdir/e2h/sub${SUB}
fsl_sub ANTS 3 -m MI[$highres_file,$ref_file,1,32] -o ${e2h_affine}_ --rigid-affine true -i 0

