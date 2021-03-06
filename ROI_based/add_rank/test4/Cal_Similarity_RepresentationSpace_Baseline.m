function Cal_Similarity_RepresentationSpace_Baseline(r)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

datadir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/RS',basedir);
resultdir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/method1',basedir);
resultdir2=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/method2',basedir);

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
%%%%%%%%%
TN=96;
subs=setdiff(1:21,2);
nsub=length(subs);
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
    'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
    'fmPFC','fPMC',...
    'CA1','DG','subiculum','PRC','ERC'};
roi=r;
%%%%%%%%%
for np=1:1000
    all_sub_rs_ln1_matrix=[];all_sub_rs_ln2_matrix=[];
    all_sub_rs_mem1_matrix=[];all_sub_rs_mem2_matrix=[];
    all_subs_rs_ln1=[]; all_subs_rs_ln2=[]; all_subs_rs_mem1=[]; all_subs_rs_mem2=[];
    for s=subs;
        rs_ln1=[];rs_ln2=[];rs_mem1=[];rs_mem2=[];
        %load data
        load(sprintf('%s/BL_sub%02d_%s.mat',datadir,s,roi_name{roi}));
        rs_ln1=rs_ln1_matrix(np,:);
        rs_ln2=rs_ln2_matrix(np,:);
        rs_mem1=rs_mem1_matrix(np,:);
        rs_mem2=rs_mem2_matrix(np,:);
        %representation space matrix for all subjects
        all_sub_rs_ln1_matrix=[all_sub_rs_ln1_matrix;rs_ln1];
        all_sub_rs_ln2_matrix=[all_sub_rs_ln2_matrix;rs_ln2];
        all_sub_rs_mem1_matrix=[all_sub_rs_mem1_matrix;rs_mem1];
        all_sub_rs_mem2_matrix=[all_sub_rs_mem2_matrix;rs_mem2];
        %get representation space for all subjects for methods2: calculated mean activation across subjects as
        %the activation pattern for between subjects
        all_subs_rs_ln1(:,:,s)=rs_ln1;
        all_subs_rs_ln2(:,:,s)=rs_ln2;
        all_subs_rs_mem1(:,:,s)=rs_mem1;
        all_subs_rs_mem2(:,:,s)=rs_mem2;
    end %end sub
    clear rs_ln1_matrix rs_ln2_matrix rs_mem1_matrix rs_mem_matrix
    %%%%%%%%%%%%%%%
    %% Method one: calculated similarity for each subject and each other subject
    allsub=[subs subs];nasub=length(allsub);
    %1=set1; 2=set2
    allln=[ones(1,nsub) 2*ones(1,nsub)];
    allmem=[ones(1,nsub) 2*ones(1,nsub)];
    allERS=[ones(1,nsub) 2*ones(1,nsub)];
    %
    all_sub1=[];all_sub2=[];
    all_ln1=[];all_ln2=[];
    all_mem1=[];all_mem2=[];
    all_ERS1=[];all_ERS2=[];
    check_sub=[];
    check_ln=[];
    check_mem=[];
    check_ERS=[];
    for ss=2:nasub;
        all_sub1=[all_sub1 allsub(ss-1)*ones(1,nasub-ss+1)];
        all_sub2=[all_sub2 allsub(ss:nasub)];
        all_ln1=[all_ln1 allln(ss-1)*ones(1,nasub-ss+1)];
        all_ln2=[all_ln2 allln(ss:nasub)];
        all_mem1=[all_mem1 allmem(ss-1)*ones(1,nasub-ss+1)];
        all_mem2=[all_mem2 allmem(ss:nasub)];
        all_ERS1=[all_ERS1 allERS(ss-1)*ones(1,nasub-ss+1)];
        all_ERS2=[all_ERS2 allERS(ss:nasub)];
    end
    %whether the correlation is for same subject or not;
    %1=same;0=different;
    check_sub=[all_sub1==all_sub2];
    %whether the correlation is for same data set or not;
    %1=same;0=different;
    check_ln=[all_ln1==all_ln2];
    check_mem=[all_mem1==all_mem2];
    check_ERS=[all_ERS1==all_ERS2];
    %calculate cross subs correlation
    cc_ln=1-pdist_with_NaN([all_sub_rs_ln1_matrix;all_sub_rs_ln2_matrix],'correlation');
    cc_mem=1-pdist_with_NaN([all_sub_rs_mem1_matrix;all_sub_rs_mem2_matrix],'correlation');
    cc_ERS12=1-pdist_with_NaN([all_sub_rs_ln1_matrix;all_sub_rs_mem2_matrix],'correlation');
    cc_ERS21=1-pdist_with_NaN([all_sub_rs_ln2_matrix;all_sub_rs_mem1_matrix],'correlation');
    cc_ERS=(cc_ERS12+cc_ERS21)/2;
    %get within sub's or cross subs' correlation
    for sf=subs
        ws_ln=cc_ln(all_sub1==sf & check_sub==1 & check_ln==0);
        ws_mem=cc_mem(all_sub1==sf & check_sub==1 & check_mem==0);
        ws_ERS=cc_ERS(all_sub1==sf & check_sub==1 & check_ERS==0);
        bs_ln=cc_ln(all_sub1==sf & check_sub==0 & check_ln==0);
        bs_mem=cc_mem(all_sub1==sf & check_sub==0 & check_mem==0);
        bs_ERS=cc_ERS(all_sub1==sf & check_sub==0 & check_ERS==0);
        %withi sub
        m1_cln{sf,1,np}=ws_ln;
        m1_cmem{sf,1,np}=ws_mem;
        m1_cERS{sf,1,np}=ws_ERS;
        %cross subs
        m1_cln{sf,2,np}=bs_ln;
        m1_cmem{sf,2,np}=bs_mem;
        m1_cERS{sf,2,np}=bs_ERS;
        %% rank
        Nrank_ln(sf,np)=sum(bs_ln<ws_ln);
        Nrank_mem(sf,np)=sum(bs_mem<ws_mem);
        Nrank_ERS(sf,np)=sum(bs_ERS<ws_ERS);
    end %end subs
    %%%%%%%%%%%%%%%
    %% Method two: calculated mean activation across all other subjects as the activation pattern for between subjects
    for s=subs;
        rs_ln1=[]; bs_ln1=[]; rs_ln2=[]; bs_ln2=[];
        rs_mem1=[]; bs_mem1=[]; rs_mem2=[]; bs_mem2=[];
        rs_ln1=all_subs_rs_ln1(:,:,s);
        bs_ln1=mean(all_subs_rs_ln1(:,:,setdiff(subs,s)),3);
        rs_ln2=all_subs_rs_ln2(:,:,s);
        bs_ln2=mean(all_subs_rs_ln2(:,:,setdiff(subs,s)),3);
        rs_mem1=all_subs_rs_mem1(:,:,s);
        bs_mem1=mean(all_subs_rs_mem1(:,:,setdiff(subs,s)),3);
        rs_mem2=all_subs_rs_mem2(:,:,s);
        bs_mem2=mean(all_subs_rs_mem2(:,:,setdiff(subs,s)),3);
        %
        m2_cln(s,1,np)=corr(rs_ln1',rs_ln2');
        m2_cln(s,2,np)=(corr(rs_ln1',bs_ln2')+corr(rs_ln2',bs_ln1'))/2;
        m2_cmem(s,1,np)=corr(rs_mem1',rs_mem2');
        m2_cmem(s,2,np)=(corr(rs_mem1',bs_mem2')+corr(rs_mem2',bs_mem1'))/2;
        m2_cERS(s,1,np)=(corr(rs_ln1',rs_mem2')+corr(rs_ln2',rs_mem1'))/2;
        m2_cERS(s,2,np)=(corr(rs_ln1',bs_mem2')+corr(rs_ln2',bs_mem1'))/2;
    end
end %end permutation
% m1_ln_z=0.5*(log(1+m1_cln)-log(1-m1_cln));
% m1_mem_z=0.5*(log(1+m1_cmem)-log(1-m1_cmem));
% m1_ERS12_z=0.5*(log(1+m1_cERS12)-log(1-m1_cERS12));
% m1_ERS21_z=0.5*(log(1+m1_cERS21)-log(1-m1_cERS21));
eval(sprintf('save %s/BL_ln_%s.mat m1_cln', resultdir,roi_name{roi}));
eval(sprintf('save %s/BL_mem_%s.mat m1_cmem', resultdir,roi_name{roi}));
eval(sprintf('save %s/BL_ERS_%s.mat m1_cERS', resultdir,roi_name{roi}));
eval(sprintf('save %s/BL_rank_ln_%s.mat Nrank_ln', resultdir,roi_name{roi}));
eval(sprintf('save %s/BL_rank_mem_%s.mat Nrank_mem', resultdir,roi_name{roi}));
eval(sprintf('save %s/BL_rank_ERS_%s.mat Nrank_ERS', resultdir,roi_name{roi}));
% m2_ln_z=0.5*(log(1+m2_cln)-log(1-m2_cln));
% m2_mem_z=0.5*(log(1+m2_cmem)-log(1-m2_cmem));
% m2_ERS12_z=0.5*(log(1+m2_cERS12)-log(1-m2_cERS12));
% m2_ERS21_z=0.5*(log(1+m2_cERS21)-log(1-m2_cERS21));
eval(sprintf('save %s/BL_ln_%s.mat m2_cln', resultdir2,roi_name{roi}));
eval(sprintf('save %s/BL_mem_%s.mat m2_cmem', resultdir2,roi_name{roi}));
eval(sprintf('save %s/BL_ERS_%s.mat m2_cERS', resultdir2,roi_name{roi}));
end %function
