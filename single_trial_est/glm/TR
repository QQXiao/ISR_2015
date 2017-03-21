#!/bin/sh
substart=$1
subend=$2
basedir=/seastor/helenhelen/ISR_2015
affinedir=$basedir/data_singletrial/transform/n2e
for ((m = $substart; m <= $subend; m++))
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
datadir=$basedir/$SUB/analysis/singletrial_glm
native_sepdir=$basedir/data_singletrial/glm/sep_native
sepdir=$basedir/data_singletrial/glm/sep
rundir=$basedir/data_singletrial/glm/run
phasedir=$basedir/data_singletrial/glm/phase
alldir=$basedir/data_singletrial/glm/all
#for c in encoding test
#do
#for r in 1 2
#do
#for s in 1 2
#do
reffile=$basedir/${SUB}/data/bold/ref.nii.gz
#step1 merge earch trial
#fsl_sub fslmerge -t ${native_sepdir}/${c}_${sub}_run${r}_set${s} ${datadir}/${c}_run${r}_set${s}_T1.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T2.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T3.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T4.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T5.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T6.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T7.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T8.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T9.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T10.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T11.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T12.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T13.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T14.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T15.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T16.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T17.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T18.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T19.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T20.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T21.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T22.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T23.feat/stats/tstat1.nii.gz ${datadir}/${c}_run${r}_set${s}_T24.feat/stats/tstat1.nii.gz
## 1.1 transform
#datafile=${native_sepdir}/${c}_${sub}_run${r}_set${s}.nii.gz
#fsl_sub WarpTimeSeriesImageMultiTransform 4 $datafile $sepdir/${c}_${sub}_run${r}_set${s}.nii.gz -R $reffile $affinedir/${sub}_${c}_run${r}_set${s}_Affine.txt
#done #s
#step2 merge each set
#fsl_sub fslmerge -t ${rundir}/${c}_${sub}_run${r} ${sepdir}/${c}_${sub}_run${r}_set*.nii.gz
#done #r
#step3 merge each run
#fsl_sub fslmerge -t ${phasedir}/${c}_${sub} ${rundir}/${c}_${sub}_run${r}*.nii.gz
#done #c
#step4 merge each pahse
fsl_sub fslmerge -t ${alldir}/${sub} ${phasedir}/*${sub}.nii.gz
done #sub
