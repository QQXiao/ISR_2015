basedir='/seastor/helenhelen/ISR_2015'
affinedir=$basedir/data_singletrial/transform/c2e
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=ISR0${m}
       sub=sub0${m}
    else
        SUB=ISR${m}
        sub=sub${m}
    fi
    echo $SUB
	reffile=$basedir/${SUB}/data/bold/ref.nii.gz
	datadir=$basedir/${SUB}/data/anatomy/sub_hipp/bi
	resultdir=$basedir/${SUB}/roi_ref/sub_hipp
	mkdir ${resultdir} -p
	cd $datadir
	for i in *.nii.gz
	do
	#roiname=`echo $i|sed -e "s/.nii.gz//g"`
	fsl_sub WarpTimeSeriesImageMultiTransform 4 ${i} $resultdir/${i} -R $reffile $affinedir/${sub}_Affine.txt
	done
done

