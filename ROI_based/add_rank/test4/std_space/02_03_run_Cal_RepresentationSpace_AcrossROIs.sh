#!sh/bin/
for r1 in 1 2
do
    for ((r2=1; r2<=12; r2++))
    do
    fsl_sub -m abe -M water.read@gmail.com -q veryshort.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace_AcrossROIs($r1,$r2);quit;"
    done
done
