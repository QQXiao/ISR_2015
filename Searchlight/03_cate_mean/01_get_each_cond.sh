#substar=$1
#subend=$2
#for ((sub = $substar; sub <= $subend; sub++))
for sub in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
  matlab2013b -nodesktop -nosplash -r "get_each_cond($sub,2);quit;"
done
