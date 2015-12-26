#!/bin/bash
basedir=/seastor/helenhelen/ISR_2015
DATAROOT=$basedir/raw
MATLAB=matlab2013b
cd $DATAROOT
#for i in ISR*
#do
#	dirname=`echo $i`
#	tar -zcvf ${dirname}.tar.gz ${dirname}
#done

#for i in *.tar.gz
i=$1
        dirname=`echo $i|sed -e "s/.tar.gz//g"`
        subid=`echo $dirname|cut -d "_" -f1`
        fsl_sub dcm2nii -n -g $dirname
