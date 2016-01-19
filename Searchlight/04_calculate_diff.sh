basedir=/seastor/helenhelen/ISR_2015
datadir=$basedir/Searchlight_RSM/ref_space/glm/each_cond
resultdir=$basedir/Searchlight_RSM/ref_space/glm/diff
mkdir -p $resultdir

cd $datadir
#for ((m=5; m<=21; m++))
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       s=0${m}
    else
        s=${m}
    fi

        for c in mem ln
        do
	fsl_sub fslmaths ${c}_D_sub${s} -sub ${c}_Bwc_sub${s} $resultdir/${c}_DBwc_sub${s} 
	fsl_sub fslmaths ${c}_D_sub${s} -sub ${c}_Ball_sub${s} $resultdir/${c}_DBall_sub${s} 
	done
	for c in ERS
	do
	fsl_sub fslmaths ${c}_I_sub${s} -sub ${c}_D_sub${s} $resultdir/${c}_ID_sub${s} 
	fsl_sub fslmaths ${c}_I_sub${s} -sub ${c}_IBwc_sub${s} $resultdir/${c}_IBwc_sub${s} 
	fsl_sub fslmaths ${c}_I_sub${s} -sub ${c}_IBall_sub${s} $resultdir/${c}_IBall_sub${s} 
	fsl_sub fslmaths ${c}_D_sub${s} -sub ${c}_DBwc_sub${s} $resultdir/${c}_DBwc_sub${s} 
	fsl_sub fslmaths ${c}_D_sub${s} -sub ${c}_DBall_sub${s} $resultdir/${c}_DBall_sub${s} 
	done
done
