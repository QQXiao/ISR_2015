function Cal_Similarity_RepresentationSpace(r)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

datadir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/data_two_sets',basedir);
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
rs_ln1_matrix=[];rs_mem1_matrix=[];rs_ln2_matrix=[];rs_mem2_matrix=[];
all_subs_data_ln1=[]; all_subs_data_ln2=[]; all_subs_data_mem1=[]; all_subs_data_mem2=[];
for s=subs;
    rs_ln1=[]; rs_ln2=[]; rs_mem1=[]; rs_mem2=[];
    %load data
    load(sprintf('%s/sub%02d_%s.mat',datadir,s,roi_name{roi}));
    %get data for all subjects for methods2: calculated mean activation across subjects as
    %the activation pattern for between subjects
    all_subs_data_ln1(:,:,s)=mean_data_ln1;
    all_subs_data_ln2(:,:,s)=mean_data_ln2;
    all_subs_data_mem1(:,:,s)=mean_data_mem1;
    all_subs_data_mem2(:,:,s)=mean_data_mem2;
    %calculate the correlation between data from two sets
    c_ln1=corr(mean_data_ln1',mean_data_ln2');
    c_ln2=corr(mean_data_ln2',mean_data_ln1');
    c_mem1=corr(mean_data_mem1',mean_data_mem2');
    c_mem2=corr(mean_data_mem2',mean_data_mem1');
    %get the tril of the correlation matrix as the representational
    %%space for each set
    rs_ln1=c_ln1(triu(c_ln1)==0);
    rs_ln2=c_ln2(triu(c_ln2)==0);
    rs_mem1=c_mem1(triu(c_mem1)==0);
    rs_mem2=c_mem2(triu(c_mem2)==0);
    %representation space matrix for all subjects
    rs_ln1_matrix=[rs_ln1_matrix;rs_ln1'];
    rs_ln2_matrix=[rs_ln2_matrix;rs_ln2'];
    rs_mem1_matrix=[rs_mem1_matrix;rs_mem1'];
    rs_mem2_matrix=[rs_mem2_matrix;rs_mem2'];
end %end sub
clear mean_data_ln1 mean_data_ln2 mean_data_mem1 mean_data_mem2
%%%%%%%%%%%%%%%
%% Method one: calculated similarity for each subject and each other subject
allsub=[subs subs];nasub=length(allsub);
%1=set1; 2=set2
allln=[ones(1,nsub) 2*ones(1,nsub)];
allmem=[ones(1,nsub) 2*ones(1,nsub)];
allERS12=[ones(1,nsub) 2*ones(1,nsub)];
allERS21=[2*ones(1,nsub) 1*ones(1,nsub)];
%
all_sub1=[];all_sub2=[];
all_ln1=[];all_ln2=[];
all_mem1=[];all_mem2=[];
all_ERS12_1=[];all_ERS12_2=[];
all_ERS21_1=[];all_ERS21_2=[];
check_sub=[];
check_ln=[];
check_mem=[];
check_ERS12=[];
check_ERS21=[];
for ss=2:nasub;
    all_sub1=[all_sub1 allsub(ss-1)*ones(1,nasub-ss+1)];
    all_sub2=[all_sub2 allsub(ss:nasub)];
    all_ln1=[all_ln1 allln(ss-1)*ones(1,nasub-ss+1)];
    all_ln2=[all_ln2 allln(ss:nasub)];
    all_mem1=[all_mem1 allmem(ss-1)*ones(1,nasub-ss+1)];
    all_mem2=[all_mem2 allmem(ss:nasub)];
    all_ERS12_1=[all_ERS12_1 allERS12(ss-1)*ones(1,nasub-ss+1)];
    all_ERS12_2=[all_ERS12_2 allERS12(ss:nasub)];
    all_ERS21_1=[all_ERS21_1 allERS21(ss-1)*ones(1,nasub-ss+1)];
    all_ERS21_2=[all_ERS21_2 allERS21(ss:nasub)];
end
%whether the correlation is for same subject or not;
%1=same;0=different;
check_sub=[all_sub1==all_sub2];
%whether the correlation is for same data set or not;
%1=same;0=different;
check_ln=[all_ln1==all_ln2];
check_mem=[all_mem1==all_mem2];
check_ERS12=[all_ERS12_1==all_ERS12_2];
check_ERS21=[all_ERS21_1==all_ERS21_2];
%calculate cross subs correlation
cc_ln=1-pdist_with_NaN([rs_ln1_matrix;rs_ln2_matrix],'correlation');
cc_mem=1-pdist_with_NaN([rs_mem1_matrix;rs_mem2_matrix],'correlation');
cc_ERS12=1-pdist_with_NaN([rs_ln1_matrix;rs_mem2_matrix],'correlation');
cc_ERS21=1-pdist_with_NaN([rs_ln2_matrix;rs_mem1_matrix],'correlation');
%get within sub's or cross subs' correlation
for sf=subs
    ws_ln=cc_ln(all_sub1==sf & check_sub==1 & check_ln==0);
    ws_mem=cc_mem(all_sub1==sf & check_sub==1 & check_mem==0);
    ws_ERS12=cc_ERS12(all_sub1==sf & check_sub==1 & check_ERS12==0);
    ws_ERS21=cc_ERS21(all_sub1==sf & check_sub==1 & check_ERS21==0);
    bs_ln=cc_ln(all_sub1==sf & check_sub==0 & check_ln==0);
    bs_mem=cc_mem(all_sub1==sf & check_sub==0 & check_mem==0);
    bs_ERS12=cc_ERS12(all_sub1==sf & check_sub==0 & check_ERS12==0);
    bs_ERS21=cc_ERS21(all_sub1==sf & check_sub==0 & check_ERS21==0);
    %withi sub
    cln(sf,1)=ws_ln;
    cmem(sf,1)=ws_mem;
    cERS12(sf,1)=ws_ERS12;
    cERS21(sf,1)=ws_ERS21;
    %cross subs
    cln(sf,2)=mean(bs_ln);
    cmem(sf,2)=mean(bs_mem);
    cERS12(sf,2)=mean(bs_ERS12);
    cERS21(sf,2)=mean(bs_ERS21);
    %% rank
    Nrank_ln(sf)=sum(bs_ln<ws_ln);
    Nrank_mem(sf)=sum(bs_mem<ws_mem);
    Nrank_ERS12(sf)=sum(bs_ERS12<ws_ERS12);
    Nrank_ERS21(sf)=sum(bs_ERS21<ws_ERS21);
    %% all subs
    for sff=subs
        ps_ln(sf,sff)=cc_ln(all_sub1==sf & all_sub2==sff & check_ln==0);
        ps_mem(sf,sff)=cc_mem(all_sub1==sf & all_sub2==sff & check_ln==0);
        ps_ERS12(sf,sff)=cc_ERS12(all_sub1==sf & all_sub2==sff & check_ln==0);
        ps_ERS21(sf,sff)=cc_ERS12(all_sub1==sf & all_sub2==sff & check_ln==0);
    end    
end %end subs
ln_z=0.5*(log(1+cln)-log(1-cln));
mem_z=0.5*(log(1+cmem)-log(1-cmem));
ERS12_z=0.5*(log(1+cERS12)-log(1-cERS12));
ERS21_z=0.5*(log(1+cERS21)-log(1-cERS21));
ps_ln_z=0.5*(log(1+ps_ln)-log(1-ps_ln));
ps_mem_z=0.5*(log(1+ps_mem)-log(1-ps_mem));
ps_ERS12_z=0.5*(log(1+ps_ERS12)-log(1-ps_ERS12));
ps_ERS21_z=0.5*(log(1+ps_ERS21)-log(1-ps_ERS21));
eval(sprintf('save %s/ln_%s.txt ln_z -ascii -tabs', resultdir,roi_name{roi}));
eval(sprintf('save %s/mem_%s.txt mem_z -ascii -tabs', resultdir,roi_name{roi}));
eval(sprintf('save %s/ERS12_%s.txt ERS12_z -ascii -tabs', resultdir,roi_name{roi}));
eval(sprintf('save %s/ERS21_%s.txt ERS21_z -ascii -tabs', resultdir,roi_name{roi}));
eval(sprintf('save %s/rank_ln_%s.txt Nrank_ln -ascii -tabs', resultdir,roi_name{roi}));
eval(sprintf('save %s/rank_mem_%s.txt Nrank_mem -ascii -tabs', resultdir,roi_name{roi}));
eval(sprintf('save %s/rank_ERS12_%s.txt Nrank_ERS12 -ascii -tabs', resultdir,roi_name{roi}));
eval(sprintf('save %s/rank_ERS21_%s.txt Nrank_ERS21 -ascii -tabs', resultdir,roi_name{roi}));
eval(sprintf('save %s/ps_%s.mat ps_ln_z ps_mem_z ps_ERS12_z ps_ERS21_z', resultdir,roi_name{roi}));
end %function
