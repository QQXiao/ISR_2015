#!sh/bin/
#for c in 1 2 3 4
#do
c=$1
nt=$2
   fsl_sub matlab -nodesktop -nosplash -r "caculate_m_mean_rep($c,$nt);quit;"
#done
