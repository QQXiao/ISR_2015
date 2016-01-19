#!sh/bin/
basedir=/seastor/helenhelen/ISR_2015
maskdir=/seastor/helenhelen/roi/ISR/final
resultdir=$basedir/Searchlight_RSM/standard_space/glm/roi/mask

for c in ln mem ERS
do
datadir=$basedir/Searchlight_RSM/standard_space/glm/group/${c}/DBwc
datafile=${datadir}/cluster_mask_zstat1.nii.gz
	for roi in $maskdir/*.nii.gz
        do
	roi_prefix=`basename $roi | sed -e "s/.nii.gz//"` 
	fslmaths $datafile -mul $roi -bin ${resultdir}/${c}_${roi_prefix} 
	done
done

