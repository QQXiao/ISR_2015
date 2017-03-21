basedir='/seastor/helenhelen/ISR_2015'
resultdir=$basedir/Searchlight_RSM/standard_space/glm/plot/z3.1/data
mkdir -p $resultdir
for c in ln mem ERS
do
datadir=$basedir/Searchlight_RSM/standard_space/glm/group/${c}/DBwc
mri_vol2surf --mni152reg --mov $datadir/thresh_zstat1.nii.gz --o ${resultdir}/lh_${c}.mgh --hemi lh
mri_vol2surf --mni152reg --mov $datadir/thresh_zstat1.nii.gz --o ${resultdir}/rh_${c}.mgh --hemi rh
done
#datadir=$basedir/Searchlight_RSM/standard_space/glm/group/ERS/IBwc2
#mri_vol2surf --mni152reg --mov $datadir/thresh_zstat1.nii.gz --o ${resultdir}/lh_ERS_s.mgh --hemi lh
#mri_vol2surf --mni152reg --mov $datadir/thresh_zstat1.nii.gz --o ${resultdir}/rh_ERS_s.mgh --hemi rh

#for roi in sVVC LANG LSMG LIFG RVVC RANG RSMG RIFG
#do
#mri_vol2surf --mni152reg --mov L${roi}.nii.gz --o ${resultdir}/lh_${roi}.mgh --hemi lh
#mri_vol2surf --mni152reg --mov R${roi}.nii.gz --o ${resultdir}/rh_${roi}.mgh --hemi rh
#done
