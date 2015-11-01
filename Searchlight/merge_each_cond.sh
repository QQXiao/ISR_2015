basedir=/seastor/helenhelen/ISR_2015
datadir=$basedir/Searchlight_RSM/standard_space/TR34/each_cond
resultdir=$basedir/Searchlight_RSM/standard_space/TR34/each_cond/all

for c in ln mem
do
	for cc in D Bwc Ball
        do
	fslmerge -t $resultdir/${c}_${cc} $datadir/${c}_${cc}_sub*.nii.gz
	done
done
for c in ERS
do
for cc in D DBwc DBall I IBall IBwc
	do
        fslmerge -t $resultdir/${c}_${cc} $datadir/${c}_${cc}_sub*.nii.gz
        done
done
