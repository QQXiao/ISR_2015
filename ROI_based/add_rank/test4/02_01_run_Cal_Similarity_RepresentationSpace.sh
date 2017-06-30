#!sh/bin/
m=$1
for r in $m
#for ((r=1; r<=19; r++))
#for r in 17
#for r in 1 7 13
do
    #fsl_sub -N roi$r -m abe -M water.read@gmail.com -q short.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace($r);quit;"
    fsl_sub -j 3352313 -N roi$r -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace($r);quit;"
    #sleep 100
done
