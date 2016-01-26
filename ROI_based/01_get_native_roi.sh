basedir='/seastor/helenhelen/ISR_2015'
affinedir=$basedir/data_singletrial/transform/t2e
roidir=/seastor/helenhelen/roi/ISR/single
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
resultdir=$basedir/ISR${SUB}/roi_ref
mkdir -p $resultdir
reffile=$basedir/ISR${SUB}/data/bold/ref.nii.gz
cd $roidir
for roi in *PHG.nii.gz
do
roi_prefix=`basename $roi | sed -e "s/.nii.gz//"`
fsl_sub WarpImageMultiTransform 3 ${roi} $resultdir/${roi_prefix}.nii.gz -R $reffile $affinedir/sub${SUB}_Affine.txt
done
done
