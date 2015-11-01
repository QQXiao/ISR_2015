#!sh/bin/
#for c in 1 2 3 4
for c in 4
do
   fsl_sub matlab -nodesktop -nosplash -r "get_peak_up_top($c);quit;"
done
