#/bin/sh
basedir=/seastor/helenhelen/ISR_2015
substart=$1
subend=$2
for ((m=substart; m<=subend; m++))
#for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=ISR0${m}
    else
        SUB=ISR${m}
    fi
    echo $SUB
#datadir=${basedir}/${SUB}/data/anatomy/sub_hipp/bi/
#datadir=${basedir}/${SUB}/behav
#rm $datadir/encoding*t?.txt
#rm $datadir/test*t?.txt
#cd $datadir
#rm MISC.nii.gz head.nii.gz tail.nii.gz
#rm WarpTimeSeriesImageM*
#rm core
#cp $datadir/roi_ref/add/* $datadir/roi_ref
	for c in encoding test
	do
	for ((r=1;r<=2;r++))
	do
	for ((s=1;s<=2;s++))
	do
	for ((t=1;t<=24;t++))
	do
	datadir=${basedir}/${SUB}/analysis/singletrial_glm/${c}_run${r}_set${s}_T${t}.feat
	cd ${datadir}
	rm report* logs mc *.txt custom_timing_files design* example_func* mean_func* filtered* mask* -r
	#rm $datadir -r
	done
	done
	done
	done
done
