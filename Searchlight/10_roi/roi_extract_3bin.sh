basedir=/seastor/helenhelen/ISR_2015/Searchlight_RSM/standard_space/glm
mask_dir=$basedir/group/roi/mask
result_dir=$basedir/group/roi/data
cd $mask_dir
masks=`ls *.nii.gz`
for c in ln mem
do
for cc in D Bwc
do
feat_file=$basedir/each_cond/allsub_${c}_${cc}
	for rx in $masks
	do    
	r=`echo $rx | sed "s/.nii.gz//"`
	result_file=$result_dir/${r}_${c}_${cc}.txt
	fslmeants -i $feat_file -o $result_file -m $mask_dir/$r
	done   
done
done
