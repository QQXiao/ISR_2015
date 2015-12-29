#for sub in 1
for sub in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
for c in 1 2
do
for r in 1 2
do
for s in 1 2
do
  	#fsl_sub matlab -nodesktop -nosplash -r "run_single_ER_ms($sub,$c,$r,$s);quit;"
  	fsl_sub matlab -nodesktop -nosplash -r "run_single_ER($sub,$c,$r,$s);quit;"
done
done
done
done
