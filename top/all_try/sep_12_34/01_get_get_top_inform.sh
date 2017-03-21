#!sh/bin/
#for s in 3
for s in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for s in 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#s=$1
do
fsl_sub -q veryshort.q matlab -nodesktop -nosplash -r "get_top_inform_half_run_N_searchlight($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "get_top_inform_half_run_N_ERS($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "get_top_inform_half_run_N_sep_roi_ERS($s);quit;"
#fsl_sub -q veryshort.q matlab -nodesktop -nosplash -r "get_top_inform_half_run_N_vvc_fpc_ERS($s);quit;"
#fsl_sub -q python.q matlab -nodesktop -nosplash -r " get_top_inform_half_run_N_vvc_fpc($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r " get_top_inform_half_run_N_sep_roi($s);quit;"
done

