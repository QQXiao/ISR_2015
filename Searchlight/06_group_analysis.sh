#!/sh/bin
basedir=/seastor/helenhelen/ISR_2015	
refdir=$basedir/group/cate_ln/cope1.gfeat
resultdir=$basedir/Searchlight_RSM/standard_space/glm/group
mkdir -p $resultdir
cd $resultdir
datadir=$basedir/Searchlight_RSM/standard_space/glm/sub
for c in ln mem
do
for cc in DBwc DBall
do
ddir=$resultdir/$c/$cc
mkdir -p $ddir
cd $ddir
fslmerge -t allsub $datadir/${c}_${cc}_sub*.nii.gz
mv allsub.nii.gz filtered_func_data.nii.gz
cp $refdir/mask.nii.gz .
cp $refdir/bg_image.nii.gz .
cp $refdir/design.* .

# run command
flameo --cope=filtered_func_data --mask=mask --dm=design.mat --tc=design.con --cs=design.grp --runmode=ols

# thresh
easythresh logdir/zstat1 mask 2.3 0.05 bg_image zstat1
easythresh logdir/zstat2 mask 2.3 0.05 bg_image zstat2
done #end cc
done #end c
for c in ERS
do
for cc in ID IBwc IBall DBwc DBall
do
ddir=$resultdir/$c/$cc
mkdir -p $ddir
cd $ddir
fslmerge -t allsub $datadir/${c}_${cc}_sub*.nii.gz
mv allsub.nii.gz filtered_func_data.nii.gz
cp $refdir/mask.nii.gz .
cp $refdir/bg_image.nii.gz .
cp $refdir/design.* .

# run command
flameo --cope=filtered_func_data --mask=mask --dm=design.mat --tc=design.con --cs=design.grp --runmode=ols

# thresh
easythresh logdir/zstat1 mask 2.3 0.05 bg_image zstat1
easythresh logdir/zstat2 mask 2.3 0.05 bg_image zstat2
done #end cc
done #end c
