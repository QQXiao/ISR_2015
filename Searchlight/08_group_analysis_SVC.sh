#!/sh/bin
basedir=/seastor/helenhelen/ISR_2015	
#for mask in MTL attention
#do
#maskdir=/seastor/helenhelen/roi/${mask}/sep
maskdir=/seastor/helenhelen/roi/ISR/final
cd $maskdir
for file in *.nii.gz
do
roi=`echo $file|sed -e "s/.nii.gz//g"`
resultdir=$basedir/Searchlight_RSM/standard_space/glm/group/svc/${roi}
mkdir -p $resultdir
cd $resultdir
for c in ln mem
do
for cc in DBwc DBall
do
ddir=$resultdir/$c/$cc
mkdir -p $ddir
cd $ddir
datadir=$basedir/Searchlight_RSM/standard_space/glm/group/$c/$cc
# thresh
easythresh $datadir/logdir/zstat1 $maskdir/$roi 2.3 0.05 $datadir/bg_image zstat1
easythresh $datadir/logdir/zstat2 $maskdir/$roi 2.3 0.05 $datadir/bg_image zstat2
done #end cc
done #end c
for c in ERS
do
for cc in ID IBwc IBall DBwc DBall
do
ddir=$resultdir/$c/$cc
mkdir -p $ddir
cd $ddir
datadir=$basedir/Searchlight_RSM/standard_space/glm/group/$c/$cc
# thresh
easythresh $datadir/logdir/zstat1 $maskdir/$roi 2.3 0.05 $datadir/bg_image zstat1
easythresh $datadir/logdir/zstat2 $maskdir/$roi 2.3 0.05 $datadir/bg_image zstat2
done #end cc
done #end c
done
