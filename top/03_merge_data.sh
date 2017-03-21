#!sh/bin/
#1=p_based;2=p_based/sep_roi
   #fsl_sub matlab -nodesktop -nosplash -r "merge_data_sub_sep_roi_N();quit;"
   #fsl_sub -q verylong.q matlab -nodesktop -nosplash -r "merge_data_sub();quit;"
   #fsl_sub -q panda.q matlab -nodesktop -nosplash -r "merge_data_mean();quit;"
   fsl_sub matlab -nodesktop -nosplash -r "merge_data_mean_sep_roi_N();quit;"
