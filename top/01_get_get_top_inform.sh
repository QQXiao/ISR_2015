#!sh/bin/
#for s in 17 18 19 20 21
for s in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
#fsl_sub matlab -nodesktop -nosplash -r "get_top_inform($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "get_top_inform2($s);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "get_top_inform5($s);quit;"
fsl_sub matlab -nodesktop -nosplash -r " get_top_inform_half_run($s);quit;"
done
