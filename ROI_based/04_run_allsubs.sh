#!sh/bin/
#fsl_sub matlab -nodesktop -nosplash -r "allsubs_in_one(2);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "allsubs(2);quit;"
fsl_sub matlab -nodesktop -nosplash -r "allsubs_TR_all;quit;"
#for ETR in 1 2 3 4
#do
#    for RTR in 1 2 3 4
#    do
#    fsl_sub matlab -nodesktop -nosplash -r "allsubs_TR($ETR,$RTR);quit;"
#    done
#done

