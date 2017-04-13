basedir='/seastor/helenhelen/ISR_2015'
datadir=/home/helenhelen/DQ/project/Tools/Functional_ROIs/dorsal_DMN
roidir=/seastor/helenhelen/roi/Cicero
fslmaths ${datadir}/01/1.nii -thr 1 -uthr 1 -bin ${roidir}/fmPFC.nii.gz
fslmaths ${datadir}/04/4.nii -thr 1 -uthr 1 -bin ${roidir}/fPMC.nii.gz
