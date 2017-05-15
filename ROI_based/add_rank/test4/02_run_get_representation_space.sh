#!sh/bin/
#for ((r=1; r<=19; r++))
#for ((r=1; r<=14; r++))
for r in 6 12
do
    fsl_sub -m abe -M water.read@gmail.com -q veryshort.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace($r);quit;"
 done
