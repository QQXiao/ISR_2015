#!sh/bin/
#m=$1
#for T in $m
for ((T=4; T<=1000; T++))
do
    sleep 1800
    #for r in $m
    for ((r=1; r<=6; r++))
    do
    fsl_sub -j 3352313 -N r${r}_p${T} -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace_sepT($r,$T);quit;"
    done
    sleep 1800
    for ((r=7; r<=12; r++))
    do
    fsl_sub -j 3352313 -N r${r}_p${T} -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace_sepT($r,$T);quit;"
    done
    sleep 1800
    for ((r=13; r<=19; r++))
    do
    fsl_sub -j 3352313 -N r${r}_p${T} -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "Cal_Similarity_RepresentationSpace_sepT($r,$T);quit;"
    done
done
