basedir='/seastor/helenhelen/ISR_2015'
templatefile=/opt/fmritools/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz
resultdir=$basedir/data_singletrial/transform
m=$1
#for ((m=5; m<=21; m++))
#do
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
h2t_affine=$resultdir/h2t_highres/sub${SUB}_0GenericAffine.mat
highres_file=$basedir/ISR${SUB}/data/anatomy/highres_brain.nii.gz
SUBDIR=$basedir/ISR${SUB}
#h2t
fsl_sub bash ${ANTSPATH}/antsRegistrationSyN.sh -d 3 -f $templatefile -m $highres_file -o $resultdir/h2t/sub${SUB}_
#done
