function [ws_ln_m1,ws_mem_m1,ws_ERS_m1,ps_ln,ps_mem,ps_ERS,...
bs_ln_m1,bs_mem_m1,bs_ERS_m1,...
ws_ln_m2,ws_mem_m2,ws_ERS_m2,bs_ln_m2,bs_mem_m2,bs_ERS_m2] = ...
Cal_RS_similarity(rs_ln1_matrix,rs_ln2_matrix,rs_mem1_matrix,rs_mem2_matrix,subs,Cond_Name,all_sub1,all_sub2,check_set)
%% Method one: calculated similarity for each subject and each other subjects
%%%%%%%%%
%calculate correlation for RS in two data sets
c_rs_ln=1-pdist_with_NaN([rs_ln1_matrix;rs_ln2_matrix],'correlation');
c_rs_mem=1-pdist_with_NaN([rs_mem1_matrix;rs_mem2_matrix],'correlation');
c_rs_ERS12=1-pdist_with_NaN([rs_ln1_matrix;rs_mem2_matrix],'correlation');
c_rs_ERS21=1-pdist_with_NaN([rs_ln2_matrix;rs_mem1_matrix],'correlation');
c_rs_ERS=(c_rs_ERS12+c_rs_ERS21)/2;
%get within sub's or cross subs' correlation
for sf=subs
    for c=1:length(Cond_Name)
        eval(sprintf('ws_%s_m1(sf)=Pick_Similarity(c_rs_%s,all_sub1==sf,all_sub2==sf,check_set==0);',Cond_Name{c},Cond_Name{c}));
        eval(sprintf('bs_%s_m1(sf)=mean(Pick_Similarity(c_rs_%s,all_sub1==sf,all_sub2~=sf,check_set==0));',Cond_Name{c},Cond_Name{c}));
        %% all subs ps
        for sff=subs
            eval(sprintf('ps_%s(sf,sff)=Pick_Similarity(c_rs_%s,all_sub1==sf,all_sub2==sff,check_set==0);',Cond_Name{c},Cond_Name{c}));
        end
    end    
end %end subs
%%%Method 2: using average across 19 other subjects as the
%%%representational space for calculating between subjects similarity
for sn=1:length(subs);
    s=subs(sn);
    rs_ln1=[]; bs_ln1=[]; rs_ln2=[]; bs_ln2=[];
    rs_mem1=[]; bs_mem1=[]; rs_mem2=[]; bs_mem2=[];
    rs_ln1=rs_ln1_matrix(sn,:);
    bs_ln1=mean(rs_ln1_matrix(setdiff(1:20,sn),:),1);
    rs_ln2=rs_ln2_matrix(sn,:);
    bs_ln2=mean(rs_ln2_matrix(setdiff(1:20,sn),:),1);
    rs_mem1=rs_mem1_matrix(sn,:);
    bs_mem1=mean(rs_mem1_matrix(setdiff(1:20,sn),:),1);
    rs_mem2=rs_mem2_matrix(sn,:);
    bs_mem2=mean(rs_mem2_matrix(setdiff(1:20,sn),:),1);
    %
    ws_ln_m2(s)=corr(rs_ln1',rs_ln2');
    bs_ln_m2(s)=(corr(rs_ln1',bs_ln2')+corr(rs_ln2',bs_ln1'))/2;
    ws_mem_m2(s)=corr(rs_mem1',rs_mem2');
    bs_mem_m2(s)=(corr(rs_mem1',bs_mem2')+corr(rs_mem2',bs_mem1'))/2;
    ws_ERS_m2(s)=(corr(rs_ln1',rs_mem2')+corr(rs_ln2',rs_mem1'))/2;
    bs_ERS_m2(s)=(corr(rs_ln1',bs_mem2')+corr(rs_ln2',bs_mem1'))/2;
end %end sn  
end %function
