#!sh/bin/
#m=$1
#for r in $m
for ((r=7; r<=11; r++))
do
    fsl_sub -N S1_roi${r} -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace($r);quit;"
    #fsl_sub -j 3352313 -N v2_roi${r} -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace_v2($r);quit;"
  #  sleep 1800
done
