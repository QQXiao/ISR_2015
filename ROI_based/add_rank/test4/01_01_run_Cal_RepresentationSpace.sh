#!sh/bin/
#for ((r=1; r<=19; r++))
#rstart=$1
#rend=$2
#for ((r=rstart; r<=rend; r++))
for r in 1 7 13
do
    #substart=$3
    #subend=$4
    #for ((subs=substart; subs<=subend; subs++))
    #for subs in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
    for subs in 13 14 16
    do
        fsl_sub -m abe -M water.read@gmail.com -q verylong.q matlab -nodesktop -nosplash -r "Cal_RepresentationSpace($r,$subs);quit;"
    sleep 120
    done
 done
