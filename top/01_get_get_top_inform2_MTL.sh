#!sh/bin/
for s in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
for 1 in 1 2 3 4 5 6
do
fsl_sub matlab -nodesktop -nosplash -r " get_top_inform_half_run_MTL($s,$r);quit;"
done
done
