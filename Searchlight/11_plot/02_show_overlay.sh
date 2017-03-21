basedir='/seastor/helenhelen/ISR_2015'
datadir=$basedir/Searchlight_RSM/standard_space/glm/plot/z3.1/data
resultdir=$basedir/Searchlight_RSM/standard_space/glm/plot/z3.1/pic
cd $datadir

#tksurfer fsaverage lh pial -overlay lh_ERS_s.mgh -fthresh 2.3 -colscalebarflag 1 -wide-config-overlay
#tksurfer fsaverage rh pial -overlay rh_ERS_s.mgh -fthresh 2.3 -colscalebarflag 1 -wide-config-overlay
for s in ln rh
    do
        for cond in ln ERS mem ln_mem mem_ln
        do
            tksurfer fsaverage ${s} pial -overlay ${s}_${cond}.mgh -fthresh 2.3 -colscalebarflag 1 -wide-config-overlay
            sclv_smooth 3 ${s}_${cond}.mgh
            shrink 800
            save_tiff $resultdir/${s}_${cond}.tiff
        done
done


#tksurfer fsaverage rh pial -overlay rh_ln.mgh -fthresh 2.3 -colscalebarflag 1 -wide-config-overlay
#sclv_smooth 3 rh_ERS.mgh
#shrink 800
#save_tiff /seastor/helenhelen/ISR_2015/Searchlight_RSM/standard_space/glm/plot/pic/rh_ERS.tiff

#tksurfer fsaverage lh pial -overlay lh_CC.mgh -fthresh 1 -wide-config-overlay


#tksurfer fsaverage lh pial -overlay lh_ln_mem.mgh -fthresh 2.3 -colscalebarflag 1 -wide-config-overlay
#tksurfer fsaverage lh pial -overlay lh_mem_ln.mgh -fthresh 2.3 -colscalebarflag 1 -wide-config-overlay
#sclv_smooth 3 lh_ln_mem.mgh
#shrink 800
#save_tiff /seastor/helenhelen/ISR_2015/Searchlight_RSM/standard_space/glm/plot/pic/lh_ln_mem.tiff


#tksurfer fsaverage rh pial -overlay rh_ln_mem.mgh -fthresh 2.3 -colscalebarflag 1 -wide-config-overlay
#tksurfer fsaverage rh pial -overlay rh_mem_ln.mgh -fthresh 2.3 -colscalebarflag 1 -wide-config-overlay
#sclv_smooth 3 rh_ln_mem.mgh
#shrink 800
#save_tiff /seastor/helenhelen/ISR_2015/Searchlight_RSM/standard_space/glm/plot/pic/rh_ln_mem.tiff
