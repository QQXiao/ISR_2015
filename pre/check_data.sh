#!/bin/bash
basedir=/seastor/helenhelen/ISR_2015
logfile=~/DQ/project/ISR_2015/pre/check_data.txt
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=ISR0${m}
    else
        SUB=ISR${m}
    fi
echo $SUB >> $logfile
file_anatomy=${basedir}/${SUB}/data/anatomy
file_bold=${basedir}/${SUB}/data/bold
file_filedmap=${basedir}/${SUB}/data/filedmap
file_rest=${basedir}/${SUB}/data/rest
if [ ! -f $file_filedmap/fieldmap_phase.nii.gz ]
then
echo $SUB no fieldmap_phase.nii.gz >> $logfile
fi
if [ ! -f $file_filedmap/fieldmap_mag.nii.gz ]
then
echo $SUB no fieldmap_mag.nii.gz >> $logfile
fi
if [ ! -f ${file_anatomy}/highres.nii.gz ]
then
echo $SUB no highres.nii.gz >> $logfile
else
nhighres=`fslinfo ${file_anatomy}/highres.nii.gz | grep -w dim4 | awk '{print $2}'`
echo $SUB highres $nhighres
fi

if [ ! -f ${file_anatomy}/coronal_ND.nii.gz ]
then
echo $SUB no coronal_ND.nii.gz >> $logfile
else
ncoronal=`fslinfo ${file_anatomy}/coronal_ND.nii.gz | grep -w dim4 | awk '{print $2}'`
echo $SUB coronal $ncoronal
if [ $ncoronal -ne 60 ] >> $logfile
then
echo $SUB coronal $ncoronal 
fi
fi

if [ ! -f ${file_rest}/rest.nii.gz ]
then
echo $SUB no rest.nii.gz >> $logfile
else
nrest=`fslinfo ${file_rest}/rest.nii.gz | grep -w dim4 | awk '{print $2}'`
echo $SUB rest $nrest
if [ $nrest -ne 240 ]
then
echo $SUB rest $nrest >> $logfile
fi
fi

for c in encoding test
do
for r in 1 2
do
for s in 1 2
do
if [ ! -f ${file_bold}/${c}_run${r}_set${s}.nii.gz ]
then
echo $SUB no ${c}_run${r}_set${s}.nii.gz >> $logfile
else
nbold=`fslinfo ${file_bold}/${c}_run${r}_set${s}.nii.gz | grep -w dim4 | awk '{print $2}'`
echo $SUB ${c}_run${r}_set${s}.nii.gz $nbold
if [ $nbold -ne 192 ]
then
echo $SUB ${c}_run${r}_set${s}.nii.gz $nbold >> $logfile
fi
fi
done
done
done

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> $logfile
done
