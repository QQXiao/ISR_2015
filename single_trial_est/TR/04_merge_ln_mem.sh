basedir=/seastor/helenhelen/ISR_2015
datadir=$basedir/data_singletrial/TR/ref_space/set
resultdir=$basedir/data_singletrial/TR/ref_space/all
mkdir $resultdir -p
#substart=$1
#subend=$2
#for m in 1 2 3 4 6 7 9 10 13 14 17 20 21 22 23 27 30 35 36 37 38 39 41
#for ((m=5; m<=21; m++))
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21

do
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
#merege file
fsl_sub fslmerge -t $resultdir/sub${SUB} $datadir/*_sub${SUB}.nii.gz
#echo $resultdir/sub${SUB}
done #sub
