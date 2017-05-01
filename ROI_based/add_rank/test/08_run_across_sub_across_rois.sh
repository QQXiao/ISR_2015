#!sh/bin/
for ((r1=1; r1<=19; r1++))
do
    for ((r2=1; r2<=19; r2++))
    do
     fsl_sub -m abe -M water.read@gmail.com -q veryshort.q matlab -nodesktop -nosplash -r "get_representation_space_across_rois($r1,$r2);quit;"
     fsl_sub -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "get_representation_space_baseline_across_rois($r1,$r2);quit;"
    done
 done
