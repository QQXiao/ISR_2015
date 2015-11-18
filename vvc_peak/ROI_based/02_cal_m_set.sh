#!sh/bin/
#for c in 1 2 3 4
nt=$1
#do
  matlab2013b -nodesktop -nosplash -r "caculate_m_set_ln(4,$nt);quit;"
  #matlab2013b -nodesktop -nosplash -r "caculate_m_set_mem(3,$nt);quit;"
#done
