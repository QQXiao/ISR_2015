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
#do
i=$1
        dirname=`echo $i|sed -e "s/.tar.gz//g"`
        subid=`echo $dirname|cut -d "_" -f1`
        if [ ! -d $subid ]
        then
          mkdir -p $basedir/$subid/data
          mkdir -p $basedir/$subid/analysis
          mkdir -p $basedir/$subid/behav
          tar xf $i
	fi
#done
