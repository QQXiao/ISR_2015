basedir='/seastor/helenhelen/ISR_2015'
resultdir=$basedir/data_singletrial/transform/n2e
#m=$1
#for m in 1
for m in 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for ((m=5; m<=21; m++))
do
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
SUBDIR=$basedir/ISR${SUB}
refdir=${SUBDIR}/data/bold
refdatadir=${SUBDIR}/analysis
dimx=`fslval ${refdatadir}/pre_encoding_run2_set1.feat/filtered_func_data.nii.gz dim1`
dimy=`fslval ${refdatadir}/pre_encoding_run2_set1.feat/filtered_func_data.nii.gz dim2`
dimz=`fslval ${refdatadir}/pre_encoding_run2_set1.feat/filtered_func_data.nii.gz dim3`
fslroi ${refdatadir}/pre_encoding_run2_set1.feat/filtered_func_data.nii.gz ${refdir}/ref.nii.gz 0 $dimx 0 $dimy 0 $dimz 0 1
refvol=`ls ${refdir}/ref.nii.gz`
for c in encoding test
do
for s in 1 2
do
for r in 1 2
do
funcfile=${refdatadir}/pre_${c}_run${r}_set${s}.feat/filtered_func_data.nii.gz
funcfile1=${refdir}/${c}_run${r}_set${s}.vol1.nii.gz
    dimx=`fslval $funcfile dim1`
    dimy=`fslval $funcfile dim2`
    dimz=`fslval $funcfile dim3`
    fslroi $funcfile $funcfile1 0 $dimx 0 $dimy 0 $dimz 0 1

n2e_affine=$resultdir/sub${SUB}_${c}_run${r}_set${s}
fsl_sub ANTS 3 -m MI[$refvol,$funcfile1,1,32] -o ${n2e_affine}_ --rigid-affine true -i 0
done
done
done
done
