#!sh/bin/
for sub in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for sub in 1
do
	#fsl_sub matlab -nodesktop -nosplash -r "RSA_neural_z($sub,1);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "RSA_neural($sub,2);quit;"
for ETR in 1 2 3 4
do
    for RTR in 1 2 3 4
    do
    fsl_sub matlab -nodesktop -nosplash -r "RSA_neural_TR($sub,$ETR,$RTR);quit;"
    done
done
done
