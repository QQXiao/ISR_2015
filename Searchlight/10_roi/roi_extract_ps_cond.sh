basedir=/seastor/helenhelen/ISR_2015/Searchlight_RSM/standard_space/glm
mask_dir=$basedir/group/roi/mask
result_dir=$basedir/group/roi/data/ps/each_cond
mkdir -p $result_dir
cd $mask_dir
masks=`ls *.nii.gz`
for c in ln_D ln_Bwc mem_D mem_Bwc ERS_I ERS_D ERS_DBwc
do
feat_file=$basedir/each_cond/${c}_all
	for rx in $masks
	do    
	r=`echo $rx | sed "s/.nii.gz//"`
	result_file=$result_dir/${r}_${c}.txt
	fslmeants -i $feat_file -o $result_file -m $mask_dir/$r
done
done
