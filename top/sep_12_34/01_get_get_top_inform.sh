#!sh/bin/
#for s in 1 3 4 5 6 7 8 9 10 11
#for s in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
for s in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
#fsl_sub matlab -nodesktop -nosplash -r "get_top_inform($s);quit;"
#matlab -nodesktop -nosplash -r " get_top_inform_half_run_common($s);quit;"
fsl_sub matlab -nodesktop -nosplash -r " get_top_inform_half_run($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r " get_top_inform_half_run_e($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r " get_top_inform_odd_even_trials($s);quit;"
done

