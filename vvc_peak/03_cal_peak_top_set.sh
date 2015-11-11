#!sh/bin/
#for c in 1 2 3 4
#do
c=$1
nt=$2
   #fsl_sub matlab2013b -nodesktop -nosplash -r "caculate_peak_up_set2($c,$nt);quit;"
   fsl_sub matlab2013b -nodesktop -nosplash -r "caculate_peak_up_set($c,$nt);quit;"
#done
