#!sh/bin/
#for c in 1 2 3 4
for c in 4
do
   fsl_sub matlab -nodesktop -nosplash -r "caculate_set($c);quit;"
done
