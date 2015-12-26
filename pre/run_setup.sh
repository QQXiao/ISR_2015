#!/bin/bash
basedir=/seastor/helenhelen/ISR_2015
DATAROOT=$basedir/raw/all
MATLAB=matlab2013b
scriptdir=~/DQ/project/ISR_2015/pre/setup_sub
cd $DATAROOT
#for i in ISR*
#do
#	dirname=`echo $i`
#	tar -zcvf ${dirname}.tar.gz ${dirname}
#done

for i in *.tar.gz
do
        dirname=`echo $i|sed -e "s/.tar.gz//g"`
        subid=`echo $dirname|cut -d "_" -f1`
#          mkdir -p $basedir/$subid/data
#          mkdir -p $basedir/$subid/analysis
#          mkdir -p $basedir/$subid/behav
#bolddir=$basedir/$subid/data/bold
#mkdir ${bolddir} -p
#anatomydir=$basedir/$subid/data/anatomy
#mkdir ${anatomydir} -p
#filedmapdir=$basedir/$subid/data/filedmap
#mkdir ${filedmapdir} -p
#restdir=$basedir/$subid/data/rest
#mkdir ${restdir} -p
#fsl_sub bash ${scriptdir}/01_untar.sh $i
#fsl_sub bash ${scriptdir}/02_dicom2nii.sh $i
#fsl_sub bash ${scriptdir}/03_cp.sh $i $subid $dirname
bash ${scriptdir}/tm.sh $i $subid $dirname
done
