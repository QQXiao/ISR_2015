basedir='/seastor/helenhelen/ISR_2015'
resultdir=$basedir/Searchlight_RSM/standard_space/glm/plot/data
for c in ln mem ERS
do
datadir=$basedir/Searchlight_RSM/standard_space/glm/group/${c}/DBwc
mri_vol2surf --mni152reg --mov $datadir/thresh_zstat1.nii.gz --o ${resultdir}/lh_${c}.mgh --hemi lh
mri_vol2surf --mni152reg --mov $datadir/thresh_zstat1.nii.gz --o ${resultdir}/rh_${c}.mgh --hemi rh
done

