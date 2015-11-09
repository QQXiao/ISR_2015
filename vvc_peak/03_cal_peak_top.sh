#!sh/bin/
#for c in 1 2 3 4
for c in 5
do
   fsl_sub matlab -nodesktop -nosplash -r "caculate_peak_up_set($c);quit;"
done
