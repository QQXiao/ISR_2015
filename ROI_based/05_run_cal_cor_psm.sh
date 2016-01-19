#!sh/bin/
    #fsl_sub matlab -nodesktop -nosplash -r "cal_cor_ps_matrix_across_roi_within_run_sep();quit;"
    #fsl_sub matlab -nodesktop -nosplash -r "cal_cor_ps_matrix_across_roi_within_run();quit;"
    #fsl_sub matlab -nodesktop -nosplash -r "cal_cor_ps_matrix_across_roi_within_run_right_trial_only();quit;"
    fsl_sub matlab -nodesktop -nosplash -r "cal_cor_ps_matrix_across_roi_within_run_sep_right_trial_only();quit;"
#fsl_sub matlab -nodesktop -nosplash -r "caculate_ps_matrix_p90_diff();quit;"
