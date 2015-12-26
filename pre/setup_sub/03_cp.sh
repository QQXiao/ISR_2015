#!/bin/bash
basedir=/seastor/helenhelen/ISR_2015
DATAROOT=$basedir/raw
MATLAB=matlab2013b
i=$1
subid=$2
dirname=$3

cd ${DATAROOT}/$dirname
echo $subid
bolddir=$basedir/$subid/data/bold
anatomydir=$basedir/$subid/data/anatomy
filedmapdir=$basedir/$subid/data/filedmap
restdir=$basedir/$subid/data/rest
#mkdir $restdir -p

	 cp *learning1*.nii.gz ${bolddir}/encoding_run1_set1.nii.gz
	 cp *learning2*.nii.gz ${bolddir}/encoding_run1_set2.nii.gz
	 cp *learning3*.nii.gz ${bolddir}/encoding_run2_set1.nii.gz
	 cp *learning4*.nii.gz ${bolddir}/encoding_run2_set2.nii.gz
	 cp *test1*.nii.gz ${bolddir}/test_run1_set1.nii.gz
	 cp *test2*.nii.gz ${bolddir}/test_run1_set2.nii.gz
	 cp *test3*.nii.gz ${bolddir}/test_run2_set1.nii.gz
	 cp *test4*.nii.gz ${bolddir}/test_run2_set2.nii.gz
	
	restfile=`ls *rest*`
	if [ ! -d $restfile ]
	then
	echo no $subid rest file
	else
	cp *rest*.nii.gz ${restdir}/rest.nii.gz
	fi

	coronalfile=`ls *T2*.nii.gz`
	NDfile=`echo $coronalfile|cut -d " " -f1`
	Dfile=`echo $coronalfile|cut -d " " -f2`
	cp $NDfile ${anatomydir}/coronal_ND.nii.gz
	cp $Dfile ${anatomydir}/coronal.nii.gz
		
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
         cp co*.nii.gz ${anatomydir}/highres.nii.gz
         fslorient -swaporient ${anatomydir}/highres.nii.gz

	 bet ${anatomydir}/highres.nii.gz ${anatomydir}/highres_brain.nii.gz -f 0.25 -R

	#PMU
	for t in *rest*_PMU
	do
	if [ -d $n ]
	then
	cp $n ${restdir}/rest_PMU -r
	fi
	done
	
	#cp *rest*PMU ${restdir}/rest_PMU -r
	cp -r *test1_PMU ${bolddir}/test_run1_set1_PMU
	cp -r *test2_PMU ${bolddir}/test_run1_set2_PMU
	cp -r *test3_PMU ${bolddir}/test_run2_set1_PMU
	cp -r *test4_PMU ${bolddir}/test_run2_set2_PMU
	cp -r *learning1_PMU ${bolddir}/encoding_run1_set1_PMU
	cp -r *learning2_PMU ${bolddir}/encoding_run1_set2_PMU
	cp -r *learning3_PMU ${bolddir}/encoding_run2_set1_PMU
	cp -r *learning4_PMU ${bolddir}/encoding_run2_set2_PMU
