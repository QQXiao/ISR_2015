#!sh/bin/
for ((r=1; r<=19; r++))
do
    fsl_sub -m abe -M water.read@gmail.com -q veryshort.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace_AcrossROIs($r);quit;"
 done
