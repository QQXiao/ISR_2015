function Cal_RepresentationSpace_AcrossROIs(r1,r2)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

datadir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/data_two_sets',basedir);
resultdir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/method1/AcrossROIs',basedir);

%%%%%%%%%
TN=96;
subs=setdiff(1:21,2);
nsub=length(subs);
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
    'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
    'fmPFC','fPMC'...
    'CA1','DG','subiculum','PRC','ERC'};
%roi_name={'fmPFC','fPMC'};
nroi=length(roi_name);
roi1=r1;
roi2=r2;
rs_ln1_matrix=[];rs_mem1_matrix=[];rs_ln2_matrix=[];rs_mem2_matrix=[];
all_subs_data_ln1=[]; all_subs_data_ln2=[]; all_subs_data_mem1=[]; all_subs_data_mem2=[];
for s=subs;
    rs_ln1=[]; rs_ln2=[]; rs_mem1=[]; rs_mem2=[];
    %%load activation data
    load(sprintf('%s/sub%02d_%s.mat',datadir,s,roi_name{roi1}));
    data_ln1_roi1=mean_data_ln1;
    data_ln2_roi1=mean_data_ln2;
    data_mem1_roi1=mean_data_mem1;
    data_mem2_roi1=mean_data_mem2;
    load(sprintf('%s/sub%02d_%s.mat',datadir,s,roi_name{roi2}));
    data_ln1_roi2=mean_data_ln1;
    data_ln2_roi2=mean_data_ln2;
    data_mem1_roi2=mean_data_mem1;
    data_mem2_roi2=mean_data_mem2;
    %%calculate the correlation between data from two sets across ROIs
    c_ln1=corr(data_ln1_roi1',data_ln2_roi2');
    c_ln2=corr(data_ln2_roi2',data_ln1_roi1');
    c_mem1=corr(data_mem1_roi1',data_mem2_roi2');
    c_mem2=corr(data_mem2_roi2',data_mem1_roi1');
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
end %end subs
clear mean_data_ln1 mean_data_ln2 mean_data_mem1 mean_data_mem2
%%set sublist
allsub=[subs subs];nasub=length(allsub);
%1=set1; 2=set2
allln=[ones(1,nsub) 2*ones(1,nsub)];
allmem=[ones(1,nsub) 2*ones(1,nsub)];
allERS12=[ones(1,nsub) 2*ones(1,nsub)];
allERS21=[2*ones(1,nsub) 1*ones(1,nsub)];
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
end %end subs
ln_z=0.5*(log(1+cln)-log(1-cln));
mem_z=0.5*(log(1+cmem)-log(1-cmem));
ERS12_z=0.5*(log(1+cERS12)-log(1-cERS12));
ERS21_z=0.5*(log(1+cERS21)-log(1-cERS21));
eval(sprintf('save %s/ln_%s_%s.txt ln_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/mem_%s_%s.txt mem_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/ERS12_%s_%s.txt ERS12_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/ERS21_%s_%s.txt ERS21_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/rank_ln_%s_%s.txt Nrank_ln -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/rank_mem_%s_%s.txt Nrank_mem -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/rank_ERS12_%s_%s.txt Nrank_ERS12 -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/rank_ERS21_%s_%s.txt Nrank_ERS21 -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
end %function
    
        
    
    
