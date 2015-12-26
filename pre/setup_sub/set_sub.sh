#!/bin/bash
basedir=/seastor/helenhelen/ISR_2015
DATAROOT=$basedir/raw
MATLAB=matlab2013b
#cd $DATAROOT
#for i in ISR*
#do
#	dirname=`echo $i`
#	tar -zcvf ${dirname}.tar.gz ${dirname}
#done

for i in *.tar.gz

        dirname=`echo $i|sed -e "s/.tar.gz//g"`
        subid=`echo $dirname|cut -d "_" -f1`
        if [ ! -d $subid ]
        then
          mkdir -p $basedir/$subid/data
          mkdir -p $basedir/$subid/analysis
          mkdir -p $basedir/$subid/behav
          tar xf $i
          dcm2nii -n -g $dirname

bolddir=$basedir/$subid/data/bold
mkdir ${bolddir}
anatomydir=$basedir/$subid/data/anatomy
mkdir ${anatomydir}
filedmapdir=$basedir/$subid/data/filedmap
mkdir ${filedmapdir}
restdir=$basedir/$subid/data/rest
mkdir ${restdir}

cd $dirname
	 cp *learning1*.nii.gz ${bolddir}/encoding_run1_set1.nii.gz
	 cp *learning2*.nii.gz ${bolddir}/encoding_run1_set2.nii.gz
	 cp *learning3*.nii.gz ${bolddir}/encoding_run2_set1.nii.gz
	 cp *learning4*.nii.gz ${bolddir}/encoding_run2_set2.nii.gz
	 cp *test1*.nii.gz ${bolddir}/test_run1_set1.nii.gz
	 cp *test2*.nii.gz ${bolddir}/test_run1_set2.nii.gz
	 cp *test3*.nii.gz ${bolddir}/test_run2_set1.nii.gz
	 cp *test4*.nii.gz ${bolddir}/test_run2_set2.nii.gz

	coronal=`ls T2coronals0*`
	fslreorient2std $coronal ${anatomydir}/coronal.nii.gz
	
		
	for f in *grefield*
    	do
        nvols=`fslnvols $f`
        if [ "$nvols" -eq "2" ]
        then
            fslroi $f tmp.nii.gz 0 1
            mv tmp.nii.gz ${filedmapdir}/fieldmap_mag.nii.gz
	    bet ${filedmapdir}/fieldmap_mag.nii.gz ${filedmapdir}/fieldmap_mag_brain.nii.gz -R -m
        fi

        if [ "$nvols" -eq "1" ]
        then
            cp $f ${filedmapdir}/fieldmap_phase.nii.gz
        fi
    	done

	# prepare fieldmap for FEAT GLM analyses
	fsl_prepare_fieldmap SIEMENS ${filedmapdir}/fieldmap_phase ${filedmapdir}/fieldmap_mag_brain ${filedmapdir}/fieldmap_rads 2.46
	#highres structure image for whole brain
         cp $dirname/co*.nii.gz ${anatomydir}/highres.nii.gz
         fslorient -swaporient ${anatomydir}/highres.nii.gz

	 bet ${anatomydir}/highres.nii.gz ${anatomydir}/highres_brain.nii.gz -f 0.25 -R
       fi
done
