#!sh/bin/
for s in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for s in 3
do
fsl_sub matlab -nodesktop -nosplash -r "caculate_ps_half_run_MTL($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "caculate_ps_half_run_e($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "caculate_ps_half_run($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "caculate_ps_half_run_e_sep_roi($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "caculate_ps_half_run_sep_roi($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "caculate_ps_trials_e_sep_roi($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "caculate_ps_odd_even_trials_e($s);quit;"
done
