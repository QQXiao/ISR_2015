#!sh/bin/
for ((r=1; r<=19; r++))
do
     fsl_sub -q long.q matlab -nodesktop -nosplash -r "get_representation_space_baseline($r);quit;"
 done
