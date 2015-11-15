#!sh/bin/
basedir=/seastor/helenhelen/ISR_2015
#for m in 1 
for m in 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=ISR0${m}
       sub=sub0${m}
    else
        SUB=ISR${m}
        sub=sub${m}
    fi
    echo $SUB
datadir=$basedir/${SUB}/data/anatomy
resultdir=$basedir/${SUB}/data/anatomy/seg_hipp
mkdir $resultdir -p
fsl_sub $ASHS_ROOT/bin/ashs_main.sh -a /opt/fmritools/ASHS/atlas_upennpmc -g ${datadir}/highres_brain.nii.gz -f ${datadir}/coronal_ND.nii.gz -w $resultdir
done
