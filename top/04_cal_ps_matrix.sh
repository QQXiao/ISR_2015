#!sh/bin/
n=$1
for s in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
   fsl_sub matlab -nodesktop -nosplash -r "caculate_ps_matrix_pn($s,$n);quit;"
done

