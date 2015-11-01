#!/sh/bin
basedir=/seastor/helenhelen/ISR_2015	
refdir=$basedir/group/cate_ln/cope1.gfeat
resultdir=$basedir/Searchlight_RSM/standard_space/TR34/SVC
mkdir -p $resultdir
cd $resultdir
datadir=$basedir/Searchlight_RSM/standard_space/TR34/group
for c in ln mem
do
for cc in DBwc DBall
do
rdir=$resultdir/$c/$cc
ddir=$datadir/$c/$cc
mkdir -p $rdir
cd $rdir
cp $refdir/mask.nii.gz .
cp $refdir/bg_image.nii.gz .
cp $refdir/design.* .
# thresh
easythresh $ddir/logdir/zstat1 mask 1.64 0.05 bg_image zstat1
easythresh $ddir/logdir/zstat2 mask 1.64 0.05 bg_image zstat2
done
done
