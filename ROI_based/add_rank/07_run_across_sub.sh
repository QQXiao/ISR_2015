#!sh/bin/
for ((r=1; r<=7; r++))
do
     fsl_sub -q verylong.q matlab -nodesktop -nosplash -r "get_representation_space_baseline($r);quit;"
 done
for ((r=8; r<=19; r++))
do
     fsl_sub -q veryshort.q matlab -nodesktop -nosplash -r "get_representation_space_baseline($r);quit;"
 done
