#!/sh/bin
basedir=/seastor/helenhelen/ISR_2015	
refdir=$basedir/group/cate_ln/cope1.gfeat
resultdir=$basedir/Searchlight_RSM/standard_space/glm/z3.1
mkdir -p $resultdir
cd $resultdir
datadir=$basedir/Searchlight_RSM/standard_space/glm/group
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
easythresh $ddir/logdir/zstat1 mask 3.1 0.05 bg_image zstat1
easythresh $ddir/logdir/zstat2 mask 3.1 0.05 bg_image zstat2
done
done
for c in ERS                                                  
do                                                            
for cc in ID IBwc IBall DBwc DBall                            
do 
rdir=$resultdir/$c/$cc
ddir=$datadir/$c/$cc
mkdir -p $rdir
cd $rdir
cp $refdir/mask.nii.gz .
cp $refdir/bg_image.nii.gz .
cp $refdir/design.* .
# thresh
easythresh $ddir/logdir/zstat1 mask 3.1 0.05 bg_image zstat1
easythresh $ddir/logdir/zstat2 mask 3.1 0.05 bg_image zstat2
done
done
