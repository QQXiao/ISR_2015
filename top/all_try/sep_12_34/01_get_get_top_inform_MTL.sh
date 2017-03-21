#!sh/bin/
#for s in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
for s in 1
do
fsl_sub -q veryshort.q matlab -nodesktop -nosplash -r "get_top_inform_half_run_N_searchlight($s);quit;"
#fsl_sub -q veryshort.q matlab -nodesktop -nosplash -r "p_info_sep_roi($s);quit;"
done
