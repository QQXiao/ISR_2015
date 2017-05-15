#!sh/bin/
for ((r=1; r<=19; r++))
do
    fsl_sub -m abe -M water.read@gmail.com -q veryshort.q matlab -nodesktop -nosplash -r "Get_RepresentationSpace($r);quit;"
 done
