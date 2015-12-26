basedir='/seastor/helenhelen/ISR_2015'
roi_name=("CA1" "CA2" "DG" "CA3" "head" "tail" "MISC" "subiculum" "ERC")
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
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
		ldir=$basedir/${SUB}/data/anatomy/sub_hipp/left
		rdir=$basedir/${SUB}/data/anatomy/sub_hipp/right
		resultdir=$basedir/${SUB}/data/anatomy/sub_hipp/bi
		mkdir ${resultdir} -p
		for ((n=0; n<=8; n++))
		do
		roi=${roi_name[${n}]}
		lfile=${ldir}/${roi}.nii.gz
		rfile=${rdir}/${roi}.nii.gz
		fsl_sub fslmaths $lfile -add $rfile -bin ${resultdir}/${roi}.nii.gz
		done
done

