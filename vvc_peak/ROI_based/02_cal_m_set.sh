#!sh/bin/
#for c in 1 2 3 4
c=$1
nt=$2
#do
  matlab2013b -nodesktop -nosplash -r "caculate_m_set_ln($c,$nt);quit;"
  #matlab2013b -nodesktop -nosplash -r "caculate_m_set_mem($c,$nt);quit;"
#done
