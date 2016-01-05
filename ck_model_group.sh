#/bin/sh
outputdir="/seastor/helenhelen/ISR_2015"
substart=$1
subend=$2
word=$3

for ((m = $substart; m <= $subend; m++))
do
    if [ ${m} -lt 10 ];
    then
       SUB=ISR0${m}
    else
        SUB=ISR${m}
    fi
    #echo $SUB

modeldir=$outputdir/$SUB/analysis/singletrial_glm
#for model in SME cate attraction
#for model in cate
#do
for c in encoding test
do
for r in 1 2
do
for s in 1 2
do
for ((t = 1; t <= 24; t++))
do
#echo ${c}_group${g}_run${r}
logdir=$modeldir/${c}_run${r}_set${s}_T${t}.feat
eval a=`find $logdir/rep*html | xargs grep -ri $word -l`
echo $a
done #t
done #s
done #r
done #c
done #sub
