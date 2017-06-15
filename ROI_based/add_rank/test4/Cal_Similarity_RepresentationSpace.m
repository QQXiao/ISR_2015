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
%% Method one: calculated similarity for each subject and each other subject
allsub=[subs subs];nasub=length(allsub);
%1=set1; 2=set2
allln=[ones(1,nsub) 2*ones(1,nsub)];
allmem=[ones(1,nsub) 2*ones(1,nsub)];
allERS=[ones(1,nsub) 2*ones(1,nsub)];
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
%%%%%%%%%
for t=1:1000
    rs_ln1_matrix=[]; rs_ln2_matrix=[]; rs_mem1_matrix=[]; rs_mem2_matrix=[];
    for s=subs;
        data_ln_1=[]; data_mem_1=[]; data_ln_2=[]; data_mem_2=[];
        %load data
        load(sprintf('%s/sub%02d_%s.mat',datadir,s,roi_name{roi}));
        %data for all subjects
        data_ln_1=squeeze(all_data_ln1(:,:,t));
        data_ln_2=squeeze(all_data_ln2(:,:,t));
        data_mem_1=squeeze(all_data_mem1(:,:,t));
        data_mem_2=squeeze(all_data_mem2(:,:,t));
        %calculate the correlation between data from two sets
        c_ln1=corr(data_ln_1',data_ln_2');
        c_ln2=corr(data_ln_2',data_ln_1');
        c_mem1=corr(data_mem_1',data_mem_2');
        c_mem2=corr(data_mem_2',data_mem_1');
        %get the tril of the correlation matrix as the representational
        %%space for each set
        rs_ln1=c_ln1(triu(c_ln1)==0);
        rs_ln2=c_ln2(triu(c_ln2)==0);
        rs_mem1=c_mem1(triu(c_mem1)==0);
        rs_mem2=c_mem2(triu(c_mem2)==0);
        %representation space matrix for all subs
        rs_ln1_matrix=[rs_ln1_matrix;rs_ln1'];
        rs_ln2_matrix=[rs_ln2_matrix;rs_ln2'];
        rs_mem1_matrix=[rs_mem1_matrix;rs_mem1'];
        rs_mem2_matrix=[rs_mem2_matrix;rs_mem2'];
    end %end sub  
    %%%Method 1
    %calculate correlation for RS in two data sets
    c_rs_ln=1-pdist_with_NaN([rs_ln1_matrix;rs_ln2_matrix],'correlation');
    c_rs_mem=1-pdist_with_NaN([rs_mem1_matrix;rs_mem2_matrix],'correlation');
    c_rs_ERS12=1-pdist_with_NaN([rs_ln1_matrix;rs_mem2_matrix],'correlation');
    c_rs_ERS21=1-pdist_with_NaN([rs_ln2_matrix;rs_mem1_matrix],'correlation');
    c_rs_ERS=(c_rs_ERS12+c_rs_ERS21)/2;
    %get within sub's or cross subs' correlation
    for sf=subs
        ws_ln=c_rsln(all_sub1==sf & check_sub==1 & check_ln==0);
        ws_mem=c_rs_mem(all_sub1==sf & check_sub==1 & check_mem==0);
        ws_ERS=c_rs_ERS(all_sub1==sf & check_sub==1 & check_ERS==0);
        bs_ln=c_rs_ln(all_sub1==sf & check_sub==0 & check_ln==0);
        bs_mem=c_rs_mem(all_sub1==sf & check_sub==0 & check_mem==0);
        bs_ERS=c_rs_ERS(all_sub1==sf & check_sub==0 & check_ERS==0);
        %withi sub
        cln1(sf,1,t)=ws_ln;
        cmem1(sf,1,t)=ws_mem;
        cERS1(sf,1,t)=ws_ERS;
        %cross subs
        cln1(sf,2,t)=mean(bs_ln);
        cmem1(sf,2,t)=mean(bs_mem);
        cERS1(sf,2,t)=mean(bs_ERS);
        %% rank
        Nrank_ln(sf,t)=sum(bs_ln<ws_ln);
        Nrank_mem(sf,t)=sum(bs_mem<ws_mem);
        Nrank_ERS(sf,t)=sum(bs_ERS<ws_ERS);
        %% all subs ps
        for sff=subs
            ps_ln(sf,sff,t)=cc_ln(all_sub1==sf & all_sub2==sff & check_ln==0);
            ps_mem(sf,sff,t)=cc_mem(all_sub1==sf & all_sub2==sff & check_ln==0);
            ps_ERS(sf,sff,t)=cc_ERS(all_sub1==sf & all_sub2==sff & check_ln==0);
        end
    end %end subs
    %%%Method 2
    for sn=1:length(subs);
        s=subs(sn);
        rs_ln1=[]; bs_ln1=[]; rs_ln2=[]; bs_ln2=[];
        rs_mem1=[]; bs_mem1=[]; rs_mem2=[]; bs_mem2=[];
        rs_ln1=rs_ln1_matrix(sn,:);
        bs_ln1=mean(rs_ln1_matrix(setdiff(subs,sn),:),1);
        rs_ln2=rs_ln2_matrix(sn,:);
        bs_ln2=mean(rs_ln2_matrix(setdiff(subs,sn),:),1);
        rs_mem1=rs_mem1_matrix(sn,:);
        bs_mem1=mean(rs_mem1_matrix(setdiff(subs,sn),:),1);
        rs_mem2=rs_mem2_matrix(sn,:);
        bs_mem2=mean(rs_mem2_matrix(setdiff(subs,sn),:),1);
        %
        cln2(s,1,t)=corr(rs_ln1',rs_ln2');
        cln2(s,2,t)=(corr(rs_ln1',bs_ln2')+corr(rs_ln2',bs_ln1'))/2;
        cmem2(s,1,t)=corr(rs_mem1',rs_mem2');
        cmem2(s,2,t)=(corr(rs_mem1',bs_mem2')+corr(rs_mem2',bs_mem1'))/2;
        cERS2(s,1,t)=(corr(rs_ln1',rs_mem2')+corr(rs_ln2',rs_mem1'))/2;
        cERS2(s,2,t)=(corr(rs_ln1',bs_mem2')+corr(rs_ln2',bs_mem1'))/2; 
    end %end sn
end %end t for 1000 permutation
% get average 
mean_cln1=mean(cln1,3);
mean_cmem1=mean(cmem1,3);
mean_cERS1=mean(cERS1,3);
mean_Nrank_ln=mean(Nrank_ln,2);
mean_Nrank_mem=mean(Nrank_mem,2);
mean_Nrank_ERS=mean(Nrank_ERS,2);
mean_ps_ln=mean(ps_ln,3);
mean_ps_mem=mean(ps_mem,3);
mean_ps_ERS=mean(ps_ERS,3);
mean_cln2=mean(cln2,3);
mean_cmem2=mean(cmem2,3);
mean_cERS2=mean(cERS2,3);
ln_z1=0.5*(log(1+mean_cln1)-log(1-mean_cln1));
mem_z1=0.5*(log(1+mean_cmem1)-log(1-mean_cmem1));
ERS_z1=0.5*(log(1+mean_cERS1)-log(1-mean_cERS1));
ln_z2=0.5*(log(1+mean_cln2)-log(1-mean_cln2));
mem_z2=0.5*(log(1+mean_cmem2)-log(1-mean_cmem2));
ERS_z2=0.5*(log(1+mean_cERS2)-log(1-mean_cERS2));
eval(sprintf('save %s/ln_%s.txt ln_z1 -ascii -tabs', resultdir1,roi_name{roi}));
eval(sprintf('save %s/mem_%s.txt mem_z1 -ascii -tabs', resultdir1,roi_name{roi}));
eval(sprintf('save %s/ERS_%s.txt ERS_z1 -ascii -tabs', resultdir1,roi_name{roi}));
eval(sprintf('save %s/rank_ln_%s.txt mean_Nrank_ln -ascii -tabs', resultdir1,roi_name{roi}));
eval(sprintf('save %s/rank_mem_%s.txt mean_Nrank_mem -ascii -tabs', resultdir1,roi_name{roi}));
eval(sprintf('save %s/rank_ERS_%s.txt mean_Nrank_ERS -ascii -tabs', resultdir1,roi_name{roi}));
eval(sprintf('save %s/ps_%s.mat mean_ps_ln mean_ps_mem mean_ps_ERS', resultdir,roi_name{roi}));

eval(sprintf('save %s/ln_%s.txt ln_z2 -ascii -tabs', resultdir2,roi_name{roi}));
eval(sprintf('save %s/mem_%s.txt mem_z2 -ascii -tabs', resultdir2,roi_name{roi}));
eval(sprintf('save %s/ERS_%s.txt ERS_z2 -ascii -tabs', resultdir2,roi_name{roi}));
end %function
