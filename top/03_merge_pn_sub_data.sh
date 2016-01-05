#!sh/bin/
   #fsl_sub matlab -nodesktop -nosplash -r "merge_pn_sub_data();quit;"
   #fsl_sub matlab -nodesktop -nosplash -r "merge_pn_sub_data_half_run();quit;"
   fsl_sub matlab -nodesktop -nosplash -r "merge_pn_sub_data_half_run_mean();quit;"
