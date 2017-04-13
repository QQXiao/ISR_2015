#!sh/bin/
for ((r=1; r<=19; r++))
do
     fsl_sub -q short.q matlab -nodesktop -nosplash -r "get_representation_space($r);quit;"
     fsl_sub -q verylong.q matlab -nodesktop -nosplash -r "get_representation_space_baseline($r);quit;"
 done
