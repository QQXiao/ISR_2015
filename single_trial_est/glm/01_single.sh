#!/bin/sh
basedir=/seastor/helenhelen/ISR_2015
designdir=/home/helenhelen/DQ/project/gitrepo/ISR_2015/single_trial_est/glm
fsfdir=/home/helenhelen/DQ/project/gitrepo/ISR_2015/single_trial_est/glm/fsf
#for ((m=1; m<=21; m++))
#for m in 1
for m in 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=ISR0${m}
    else
        SUB=ISR${m}
    fi
    echo $SUB
	for c in encoding test
	do
	for ((r=1;r<=2;r++))
	do
	for ((s=1;s<=2;s++))
	do
	for ((t=1;t<=24;t++))
	do
	#sed -e "s/ISR01/${SUB}/g"  -e "s/encoding/${c}/g" -e "s/run1/run${r}/g" -e "s/set1/set${s}/g" -e "s/T1/T${t}/g" $designdir/design.fsf > $fsfdir/single_${c}_${SUB}_run${r}_set${s}_T${t}.fsf
        feat $fsfdir/single_${c}_${SUB}_run${r}_set${s}_T${t}.fsf
	done
	done
	done
	done
done
