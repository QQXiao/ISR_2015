#!sh/bin/
for ((r=1; r<=19; r++))
do
    for subs in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
    do
        fsl_sub -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "Cal_EquivalentInRepresentationSpace($r,$subs);quit;"
    sleep 120
    done
 done
