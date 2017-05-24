#!sh/bin/
for ((r=1; r<=19; r++))
do
    fsl_sub -m abe -M water.read@gmail.com -q veryshort.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace_Baseline($r);quit;"
    sleep 100
done
