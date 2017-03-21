basedir=/seastor/helenhelen/ISR_2015/Searchlight_RSM/standard_space/glm
mask_dir=$basedir/group/roi/mask
result_dir=$basedir/group/roi/data/ps
cd $mask_dir
masks=`ls *.nii.gz`
for c in ln_DBwc mem_DBwc ERS_ID ERS_DBwc ERS_IBwc
do
feat_file=$basedir/sub/${c}_allsub
	for rx in $masks
	do    
	r=`echo $rx | sed "s/.nii.gz//"`
	result_file=$result_dir/${r}_${c}.txt
	fslmeants -i $feat_file -o $result_file -m $mask_dir/$r
done
done
