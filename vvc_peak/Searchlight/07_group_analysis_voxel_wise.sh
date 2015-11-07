#!/sh/bin
basedir=/seastor/helenhelen/ISR_2015	
refdir=$basedir/group/cate_ln/cope1.gfeat
resultdir=$basedir/peak/VVC/data/top/ps/mem_ln/standard_space/group
mkdir -p $resultdir
cd $resultdir
datadir=$basedir/peak/VVC/data/top/ps/mem_ln/standard_space/sub
nt=50
for c in ln mem
do
ddir=$resultdir/${c}_voxel_wise
mkdir -p $ddir
cd $ddir
fslmerge -t allsub $datadir/${c}_sub*_${nt}.nii.gz
mv allsub.nii.gz filtered_func_data.nii.gz
cp $refdir/mask.nii.gz .
cp $refdir/bg_image.nii.gz .
cp $refdir/design.* .

# run command
flameo --cope=filtered_func_data --mask=mask --dm=design.mat --tc=design.con --cs=design.grp --runmode=ols

# thresh
easythresh logdir/zstat1 2.3 bg_image zstat1
easythresh logdir/zstat2 2.3 bg_image zstat2
done #end c
