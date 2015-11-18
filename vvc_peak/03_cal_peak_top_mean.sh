#!sh/bin/
#for c in 1 2 3 4
#do
c=$1
nt=$2
   matlab2013b -nodesktop -nosplash -r "caculate_peak_up_mean_rep($c,$nt);quit;"
#done
