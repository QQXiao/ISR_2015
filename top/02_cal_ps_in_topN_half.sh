#!sh/bin/
for s in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for s in 20
do
#fsl_sub -q verylong.q matlab -nodesktop -nosplash -r "caculate_ps_P_half_run($s);quit;"
fsl_sub -q verylong.q matlab -nodesktop -nosplash -r "caculate_ps_N_half_run_sep_roi_ERS($s);quit;"
done
