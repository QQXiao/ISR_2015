basedir=/seastor/helenhelen/ISR_2015
mask_dir=$basedir/Searchlight_RSM/standard_space/glm/group/roi/mask
data_dir=$basedir/data_singletrial/glm/all_std
result_dir=$basedir/Searchlight_RSM/standard_space/glm/group/roi/data/act
mkdir $result_dir -p
cd $mask_dir
masks=`ls *.nii.gz`
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       sub=sub0${m}
       SUB=ISR0${m}
    else
        sub=sub${m}
        SUB=ISR${m}
    fi
    echo $SUB
	for rx in $masks
	do    
	roi_prefix=`echo $rx | sed "s/.nii.gz//"`
	result_file=$result_dir/${r}.txt
	fsl_sub fslmeants -i ${data_dir}/${sub}.nii.gz --showall -m ${roi_prefix} -o ${result_dir}/${sub}_${roi_prefix}.txt
	done
done
