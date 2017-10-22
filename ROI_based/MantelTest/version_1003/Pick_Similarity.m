function [ps] = Pick_Similarity(Corr_Matrix,all_sub1,all_sub2,check_set)
ps=Corr_Matrix(all_sub1 & all_sub2 & check_set);
end %function
