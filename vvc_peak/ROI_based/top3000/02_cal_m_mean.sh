#!sh/bin/
#for c in 1 2 3 4
#do
nt=$1
   matlab2013b -nodesktop -nosplash -r "caculate_m_mean_rep_mem(3,$nt);quit;"
   #matlab2013b -nodesktop -nosplash -r "caculate_m_mean_rep_ln(4,$nt);quit;"
#done
