basedir=/seastor/helenhelen/ISR_2015
datadir=$basedir/Searchlight_RSM/ref_space/glm/diff
resultdir=$basedir/Searchlight_RSM/ref_space/glm/diff
mkdir -p $resultdir

cd $datadir
#for ((m=5; m<=21; m++))
for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       s=0${m}
    else
        s=${m}
    fi
fslmaths ln_DBwc_sub${s} -sub mem_DBwc_sub${s} $resultdir/ln_mem_DBwc_sub${s} 
fslmaths mem_DBwc_sub${s} -sub ln_DBwc_sub${s} $resultdir/mem_ln_DBwc_sub${s} 
done
