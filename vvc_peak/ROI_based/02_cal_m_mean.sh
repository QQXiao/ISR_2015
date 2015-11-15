#!sh/bin/
#for c in 1 2 3 4
#do
c=$1
nt=$2
   matlab2013b -nodesktop -nosplash -r "caculate_m_mean_rep_mem($c,$nt);quit;"
   #matlab2013b -nodesktop -nosplash -r "caculate_m_mean_rep_ln($c,$nt);quit;"
#done
