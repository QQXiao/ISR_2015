#/bin/sh
basedir=/seastor/helenhelen/ISR_2015
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
datadir=${basedir}/${SUB}/data/anatomy/sub_hipp/bi/
cd $datadir
#rm MISC.nii.gz head.nii.gz tail.nii.gz
rm WarpTimeSeriesImageM*
#rm core
#cp $datadir/roi_ref/add/* $datadir/roi_ref
	#for c in encoding test
	#do
	#for ((r=1;r<=2;r++))
	#do
	#for ((s=1;s<=2;s++))
	#do
	#done
	#done
	#done
done
