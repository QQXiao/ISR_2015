#!sh/bin/
for sub in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
fsl_sub -q verylong.q matlab -nodesktop -nosplash -r "RSA_neural_z_item($sub);quit;"
fsl_sub matlab -nodesktop -nosplash -r "RSA_neural_z_item_ERS($sub);quit;"
    #fsl_sub matlab -nodesktop -nosplash -r "RSA_neural_item_include_right_wrong_no_top($sub);quit;"
    #fsl_sub matlab -nodesktop -nosplash -r "RSA_neural_item_include_right_wrong_h($sub);quit;"
done
