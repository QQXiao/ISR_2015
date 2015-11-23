function [idx_mem_D,idx_mem_DB_wc,idx_mem_DB_all,idx_ln_D,idx_ln_DB_wc,idx_ln_DB_all,list_pid]=get_idx_item(s,t)
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behav/label'];
%data structure
Mtrial=1; % trial number
MpID=2;  % material id_pic
MwID=3;  % material id_word
Mcat1=4; % 1=structure,2=nature
Mcat2=5; % 1=structure-foreign,2=structure-local,3=nature-water,4=nature-land

Mres=6; %% 1=structure-foreign,2=structure-local,3=nature-water,4=nature-land
MRT=7; % reaction time;

Monset=8; % designed onset time
MAonset=9; % actually onset time
Mrun=10;
Mset=11;
MAonset_r=12; % actually onset time for response 1;category;
Mscore=13;%right or wrong for identity
%%added information
Mposit=14;
Mmem=15;
Msub=16;
Mphase=17;
TN=96*2;
Mp=18;
%%%%%%%%%

%perpare data
        load(sprintf('%s/encoding_sub%02d.mat',labeldir,s));
        list_subln=subln;
        list_subln(:,Msub)=s;
        list_subln(:,Mphase)=1;
        m_ln=list_subln(:,MpID);
        load(sprintf('%s/test_sub%02d.mat',labeldir,s));
        list_submem=submem;
        list_submem(:,Msub)=s;
        list_submem(:,Mphase)=2;
        m_mem=list_submem(:,MpID);
        for nn=1:96
        p=list_subln(nn,MpID);w=list_subln(nn,MwID);
        list_subln(nn,Mmem)=list_submem(list_submem(:,MpID)==p & list_submem(:,MwID)==w,Mmem);
        end
        all_label=[list_subln;list_submem];
        list_pid=all_label(:,MpID);
        all_label(:,Mp)=1:192;
        all_idx=1:TN*(TN-1)/2; %% all paired correlation idx;
        ln_all_pID1=[]; ln_all_pID2=[]; ln_all_wID1=[]; ln_all_wID2=[]; ln_all_Rcate=[]; ln_all_mem1=[]; ln_all_mem2=[]; ln_all_cate1=[]; ln_all_cate2=[]; ln_check_run=[]; ln_check_set=[]; ln_check_cate=[];
        mem_all_pID1=[]; mem_all_pID2=[]; mem_all_wID1=[]; mem_all_wID2=[]; mem_all_Rcate=[]; mem_all_mem1=[]; mem_all_mem2=[]; mem_all_cate1=[]; mem_all_cate2=[]; mem_check_run=[]; mem_check_set=[]; mem_check_cate=[];
        for k=2:TN
        ln_all_pID1=[ln_all_pID1 list_subln(k-1,MpID)*ones(1,TN-k+1)];
        ln_all_pID2=[ln_all_pID2 list_subln(k:TN,MpID)'];
        ln_all_wID1=[ln_all_wID1 list_subln(k-1,MwID)*ones(1,TN-k+1)];
        ln_all_wID2=[ln_all_wID2 list_subln(k:TN,MwID)'];
        ln_all_mem1=[ln_all_mem1 list_subln(k-1,Mmem)*ones(1,TN-k+1)];
        ln_all_mem2=[ln_all_mem2 list_subln(k:TN,Mmem)'];
        ln_all_cate1=[ln_all_cate1 list_subln(k-1,Mcat2)*ones(1,TN-k+1)];
        ln_all_cate2=[ln_all_cate2 list_subln(k:TN,Mcat2)'];
        %1=same run;0=diff run
        ln_check_run=[ln_check_run (list_subln(k:TN,Mrun)==list_subln(k-1,Mrun))'];
        %1=same set;0=diff set
        ln_check_set=[ln_check_set (list_subln(k:TN,Mset)==list_subln(k-1,Mset))'];
        %1=same category;0=diff categories
        ln_check_cate=[ln_check_cate (list_subln(k:TN,Mcat2)==list_subln(k-1,Mcat2))'];

        mem_all_pID1=[mem_all_pID1 list_submem(k-1,MpID)*ones(1,TN-k+1)];
        mem_all_pID2=[mem_all_pID2 list_submem(k:TN,MpID)'];
        mem_all_wID1=[mem_all_wID1 list_submem(k-1,MwID)*ones(1,TN-k+1)];
        mem_all_wID2=[mem_all_wID2 list_submem(k:TN,MwID)'];
        mem_all_mem1=[mem_all_mem1 list_submem(k-1,Mmem)*ones(1,TN-k+1)];
        mem_all_mem2=[mem_all_mem2 list_submem(k:TN,Mmem)'];
        mem_all_cate1=[mem_all_cate1 list_submem(k-1,Mcat2)*ones(1,TN-k+1)];
        mem_all_cate2=[mem_all_cate2 list_submem(k:TN,Mcat2)'];
        %1=same run;0=diff run
        mem_check_run=[mem_check_run (list_submem(k:TN,Mrun)==list_submem(k-1,Mrun))'];
        %1=same set;0=diff set
        mem_check_set=[mem_check_set (list_submem(k:TN,Mset)==list_submem(k-1,Mset))'];
        %1=same category;0=diff categories
        mem_check_cate=[mem_check_cate (list_submem(k:TN,Mcat2)==list_submem(k-1,Mcat2))'];
        end
        %% get indexes
        %mem
        idx_mem_D=find(mem_all_pID1==t & mem_all_mem1 ==1 & mem_all_mem2==1 & mem_all_pID1==mem_all_pID2 & mem_all_wID1~=mem_all_wID2);%%same face different words: p+c-
        idx_mem_DB_all=find(mem_all_pID1==t & mem_all_mem1==1 & mem_all_mem2==1 & mem_all_pID1~=mem_all_pID2 & mem_check_run==1 & mem_check_set==0);
        idx_mem_DB_wc=find(mem_all_pID1==t & mem_all_mem1==1 & mem_all_mem2==1 & mem_all_pID1~=mem_all_pID2 & mem_check_run==1 & mem_check_set==0 & mem_check_cate==1);
        %ln
        idx_ln_D=find(ln_all_pID1==t & ln_all_pID1==ln_all_pID2 & ln_all_wID1~=ln_all_wID2);%%same face different words: p+c-
        idx_ln_DB_all=find(ln_all_pID1==t & ln_all_pID1~=ln_all_pID2 & ln_check_run==1 & ln_check_set==0);
        idx_ln_DB_wc=find(ln_all_pID1==t & ln_all_pID1~=ln_all_pID2 & ln_check_run==1 & ln_check_set==0 & ln_check_cate==1);
end %end func
