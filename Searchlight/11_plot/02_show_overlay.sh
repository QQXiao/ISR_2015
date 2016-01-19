basedir='/seastor/helenhelen/ISR_2015'
datadir=$basedir/Searchlight_RSM/standard_space/glm/plot/data
resultdir=$basedir/Searchlight_RSM/standard_space/glm/plot/pic

tksurfer fsaverage lh pial -overlay lh_ERS.mgh -fthresh 2.3 -colscalebarflag 1 -wide-config-overlay 
sclv_smooth 3 lh_ln.mgh
shrink 800
save_tiff /seastor/helenhelen/ISR_2015/Searchlight_RSM/standard_space/glm/plot/pic/lh_ln.tiff

tksurfer fsaverage rh pial -overlay rh_ln.mgh -fthresh 2.3 -colscalebarflag 1 -wide-config-overlay 
sclv_smooth 3 rh_ERS.mgh
shrink 800
save_tiff /seastor/helenhelen/ISR_2015/Searchlight_RSM/standard_space/glm/plot/pic/rh_ERS.tiff

tksurfer fsaverage lh pial -overlay lh_CC.mgh -fthresh 1 -wide-config-overlay 
