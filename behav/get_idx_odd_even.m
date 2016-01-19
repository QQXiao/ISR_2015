function [idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]=get_idx(s,nh)
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
TN=96;
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
        %all_label=[list_subln;list_submem];
	all_label=[list_subln((nh:2:end),:);list_submem((nh:2:end),:)];
        all_idx=1:TN*(TN-1)/2; %% all paired correlation idx;
        all_pID1=[]; all_pID2=[]; all_wID1=[]; all_wID2=[]; all_Rcate=[]; all_mem1=[]; all_mem2=[]; all_phase1=[]; all_phase2=[]; all_cate1=[];  all_cate2=[]; check_run=[]; check_set=[]; check_cate=[];
       for k=2:TN
        all_pID1=[all_pID1 all_label(k-1,MpID)*ones(1,TN-k+1)];
        all_pID2=[all_pID2 all_label(k:TN,MpID)'];
        all_wID1=[all_wID1 all_label(k-1,MwID)*ones(1,TN-k+1)];
        all_wID2=[all_wID2 all_label(k:TN,MwID)'];
        all_mem1=[all_mem1 all_label(k-1,Mmem)*ones(1,TN-k+1)];
        all_mem2=[all_mem2 all_label(k:TN,Mmem)'];
        all_phase1=[all_phase1 all_label(k-1,Mphase)*ones(1,TN-k+1)];
        all_phase2=[all_phase2 all_label(k:TN,Mphase)'];
        all_cate1=[all_cate1 all_label(k-1,Mcat2)*ones(1,TN-k+1)];
        all_cate2=[all_cate2 all_label(k:TN,Mcat2)'];

        %1=same run;0=diff run 
        check_run=[check_run (all_label(k:TN,Mrun)==all_label(k-1,Mrun))'];

        %1=same set;0=diff set 
        check_set=[check_set (all_label(k:TN,Mset)==all_label(k-1,Mset))'];

        %1=same category;0=diff categories
        check_cate=[check_cate (all_label(k:TN,Mcat2)==all_label(k-1,Mcat2))'];
        end
        %% get indexes
        % ERS
        idx_ERS_I=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1==all_pID2 & all_wID1==all_wID2);%identity pair: p+c+
        idx_ERS_IB_all=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==1);
        idx_ERS_IB_wc=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==1 & check_cate==1);
        idx_ERS_D=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1==all_pID2 & all_wID1~=all_wID2);%%same face different words: p+c-        
	idx_ERS_DB_all=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0);
        idx_ERS_DB_wc=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0 & check_cate==1);
        %mem
        idx_mem_D=find(all_phase1==2 & all_phase2==2 & all_mem1 ==1 & all_mem2==1 & all_pID1==all_pID2 & all_wID1~=all_wID2);%%same face different words: p+c-
        idx_mem_DB_all=find(all_phase1==2 & all_phase2==2 & all_mem1==1 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0);
        idx_mem_DB_wc=find(all_phase1==2 & all_phase2==2 & all_mem1==1 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0 & check_cate==1);
        %ln
        idx_ln_D=find(all_phase1==1 & all_phase2==1 & all_pID1==all_pID2 & all_wID1~=all_wID2);%%same face different words: p+c-
  	idx_ln_DB_all=find(all_phase1==1 & all_phase2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0);
  	idx_ln_DB_wc=find(all_phase1==1 & all_phase2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0 & check_cate==1);
end %end func
