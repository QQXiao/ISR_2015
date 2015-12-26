#!/bin/bash
basedir=/seastor/helenhelen/isr
substart=$1
subend=$2
for ((m = $substart; m <= $subend; m++))
do
    if [ ${m} -lt 10 ];
    then
        SUB=isr_0${m}
    else
    SUB=isr_${m}
    fi
    echo ${SUB}
    resultdir=$basedir/${SUB}/fieldmap
#    fsl_sub bet ${resultdir}/fieldmap_mag ${resultdir}/fieldmap_mag_brain -f 0.6 -R -m
fsl_sub fsl_prepare_fieldmap SIEMENS ${resultdir}/fieldmap_phase ${resultdir}/fieldmap_mag_brain ${resultdir}/fieldmap_rads 2.46
done
