#!/bin/sh
outputdir=/seastor/helenhelen/ISR_2015
#for ((m=1; m<=21; m++))
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
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
	#sed -e "s/ISR05/${SUB}/g" -e "s/encoding/${c}/g" -e "s/run1/run${r}/g" -e "s/set1/set${s}/g" $outputdir/script/design/ms_singletrial.fsf > $outputdir/script/fsf/ms_single_${c}_${SUB}_run${r}_set${s}.fsf
	sed -e "s/ISR05/${SUB}/g" -e "s/encoding/${c}/g" -e "s/run1/run${r}/g" -e "s/set1/set${s}/g" $outputdir/script/design/singletrial.fsf > $outputdir/script/fsf/single_${c}_${SUB}_run${r}_set${s}.fsf
	
	#sed -e "s/ISR05/${SUB}/g"  -e "s/encoding/${c}/g" -e "s/run1/run${r}/g" -e "s/set1/set${s}/g" $outputdir/script/design/pre.fsf > $outputdir/script/fsf/pre_${c}_${SUB}_run${r}_set${s}.fsf
        #feat $outputdir/script/fsf/pre_${c}_${SUB}_run${r}_set${s}.fsf
	done
	done
	done
done
