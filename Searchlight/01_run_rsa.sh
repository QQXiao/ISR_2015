#!sh/bin/
for sub in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for ((sub=5; sub<=21; sub++))
do
   #matlab2013b -nodesktop -nosplash -r "RSA_neural($sub,2);quit;"
   fsl_sub matlab -nodesktop -nosplash -r "RSA_neural_z_run($sub);quit;"
done
