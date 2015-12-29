#!/bin/bash
basedir=/seastor/helenhelen/ISR_2015
substart=$1
subend=$2
for ((m = $substart; m <= $subend; m++))
do
    if [ ${m} -lt 10 ];
    then
        SUB=ISR0${m}
    else
    SUB=ISR${m}
    fi
    echo ${SUB}
    fmapdir=${basedir}/${SUB}/data/filedmap
    BOLDdir=$basedir/${SUB}/data/bold
    resultdir=$basedir/${SUB}/data/bold/filed_map_unwaredepi
   mkdir -p $resultdir
	 for c in encoding  test
    do
        for r in 1 2
        do
            for s in 1 2
            do
            echo ${SUB}_${c}_run${r}_set${s}
            BOLDfile=$BOLDdir/${c}_run${r}_set${s}.nii.gz
           fsl_sub fugue -i ${BOLDfile} --dwell=.00056 --loadfmap=${fmapdir}/fieldmap_rads.nii.gz -u ${resultdir}/${c}_run${r}_set${s}.nii.gz --unwarpdir=y-
           #fsl_sub fugue -i ${BOLDfile} --dwell=.00056 --loadfmap=${fmapdir}/try_rads.nii.gz -u ${resultdir}/try_${c}_run${r}_set${s}_y.nii.gz --unwarpdir=y
           #fsl_sub fugue -i ${BOLDfile} --dwell=.00056 --loadfmap=${fmapdir}/try_rads.nii.gz -u ${resultdir}/try_${c}_run${r}_set${s}_y-.nii.gz --unwarpdir=y-
            done #done s
        done #done r
    done #done c
done #done sub
