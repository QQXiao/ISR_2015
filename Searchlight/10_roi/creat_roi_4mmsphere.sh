# !/bin/sh
# create an image with a spherical ROI given voxel-based coordinates in FSL. 
# USAGE: makeroi.sh <voxel-based XYZ coordinates (in quotes)> <output filename> [options]
#  options: -r <sphere radius> default=6mm
#           -t <template> default=FSL's avg152T1_brain

# maskimg=/mnt/hgfs/wind_d/cup/fsl_analysis/group/cope1.gfeat/cope1.feat/stats/zstat1.nii.gz
# fslmaths $maskimg -thr 2.3 -bin risk_norisk__mask_th2.3

#maskimg=/mnt/hgfs/wind_d/cup/fsl_analysis/group/cope2.gfeat/cope1.feat/stats/zstat1.nii.gz
#fslmaths $maskimg -thr 2.3 -bin win_loss__mask_th2.3


creat_roi()
{
template=/opt/fmritools/fsl-5.0.9-centos5_64/data/standard/avg152T1_brain
sphere_radius=$size # size
tempoutfile=tmp_roicoord_image # this will be deleted after we create the sphere
#maskimg=allrev_NR_mask_th2.3

# first create an image with a single voxel at the center of the ROI sphere
echo "creating initial image with voxel at sphere center:"
echo "avwmaths $template -roi  ${vox[0]} 1 ${vox[1]} 1 ${vox[2]} 1 0 1 $tempoutfile"
fslmaths $template -roi  ${vox[0]} 1 ${vox[1]} 1 ${vox[2]} 1 0 1 $tempoutfile

# convolve to make a sphere
echo "convolving image to get sphere:"
echo "avwconv -i $tempoutfile -s $sphere_radius -o $tempoutfile\_tmp"
#fslmaths -i $tempoutfile -s $sphere_radius -o $tempoutfile\_tmp

fslmaths $tempoutfile -fmean -kernel sphere $size -fmean $tempoutfile\_tmp

# convert to abs value then binary (0/1s)
echo "converting ROI image to binary (0/1s)..."

fslmaths $tempoutfile\_tmp -abs $tempoutfile\_abs
fslmaths $tempoutfile\_abs -bin $tempoutfile\_tmp

# mask with the activagtion map
# echo "masking with the activation map"
# fslmaths $tempoutfile\_tmp -mul $maskimg ../roi/roi\_$outputfile\_$size\mm

fslmaths $tempoutfile\_tmp -mul 1 ${outputfile}_${size}mm

# clean up
rm -f tmp*
}

#Left_IFG; for memory cluster_z1_1
basedir=/seastor/helenhelen/ISR_2015
resultdir=$basedir/Searchlight_RSM/standard_space/glm/group
outputfile=${resultdir}/roi/mask/VVC_18_-84_-8
vox=(36 21 32)
size=6
#maskimg=risk_norisk__mask_th2.3
creat_roi

#Left_IFG; for memory cluster_z1_1
outputfile=${resultdir}/roi/mask/IPL_-50_-48_46
vox=(70 39 59)
size=6
#maskimg=risk_norisk__mask_th2.3
creat_roi

#Left_ITG; for memory cluster_z1_2
#outputfile=../mask/ITG_-48_-54_-12
#vox=(69 36 30)
#size=4
#maskimg=risk_norisk__mask_th2.3
#creat_roi

#precuneous; for var1 cluster_z1_1
#outputfile=../mask/precuneous_47.6_58.4_40.5
#vox=(53 38 47)
#size=4
#maskimg=risk_norisk__mask_th2.3
#creat_roi

#subcallosal; for var2 cluster_z1_1
#outputfile=../mask/subcallosal_44_71.1_26.9
#vox=(50 70 28)
#size=4
#maskimg=risk_norisk__mask_th2.3
#creat_roi

#Left_occipital; for var3 cluster_z1_1
#outputfile=../mask/oiccipital_53.4_50.8_43.1
#vox=(70 29 40)
#size=4
#maskimg=risk_norisk__mask_th2.3
#creat_roi

