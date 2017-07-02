#!sh/bin/
m=$1
n=$2
for T in $m
#for ((T=1; T<=1000; T++))
do
    for r in $n
    do
    fsl_sub -j 3352313 -N r${r}_p${T} -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace_sepT($r,$T);quit;"
    done
done
