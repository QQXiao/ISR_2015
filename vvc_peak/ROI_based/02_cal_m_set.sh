#!sh/bin/
#for c in 1 2 3 4
c=$1
nt=$2
#do
   fsl_sub matlab2013b -nodesktop -nosplash -r "caculate_m_set($c,$nt);quit;"
#done
