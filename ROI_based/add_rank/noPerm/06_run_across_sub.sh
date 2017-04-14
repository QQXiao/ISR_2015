#!sh/bin/
#for ((r=1; r<=2; r++))
for ((r=1; r<=19; r++))
do
     fsl_sub -m abe -M water.read@gmail.com -q veryshort.q matlab -nodesktop -nosplash -r "get_representation_space($r);quit;"
     fsl_sub -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "get_representation_space_mean($r);quit;"
 done
