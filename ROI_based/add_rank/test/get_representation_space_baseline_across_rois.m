function get_representation_space_baseline_across_rois(r)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

datadir=sprintf('%s/ROI_based/subs_within_between/add_rank/test3',basedir);
resultdir=sprintf('%s/ROI_based/subs_within_between/add_rank/test3/crossRoi',basedir);

%%%%%%%%%
TN=96;%96 trials in encoding and retrieval, respectively;
subs=setdiff(1:21,2);
nsub=length(subs);
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
    'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
    'fmPFC','fPMC'...
    'CA1','DG','subiculum','PRC','ERC'};
%roi_name={'fmPFC','fPMC'};
nroi=length(roi_name);
roi=r;
%%load representational space    
load(sprintf('%s/BL_all_ln1_%s.mat', datadir,roi_name{roi1}));
all_ln1_roi1=all_ln1_data;
load(sprintf('%s/BL_all_ln2_%s.mat', datadir,roi_name{roi1}));
all_ln2_roi1=all_ln2_data;
load(sprintf('%s/BL_all_mem1_%s.mat', datadir,roi_name{roi1}));
all_mem1_roi1=all_mem1_data;
load(sprintf('%s/BL_all_mem2_%s.mat', datadir,roi_name{roi1}));
all_mem2_roi1=all_mem2_data;
load(sprintf('%s/BL_all_ln1_%s.mat', datadir,roi_name{roi2}));
all_ln1_roi2=all_ln1_data;
load(sprintf('%s/BL_all_ln2_%s.mat', datadir,roi_name{roi2}));
all_ln2_roi2=all_ln2_data;
load(sprintf('%s/BL_all_mem1_%s.mat', datadir,roi_name{roi2}));
all_mem1_roi2=all_mem1_data;
load(sprintf('%s/BL_all_mem2_%s.mat', datadir,roi_name{roi2}));
all_mem2_roi2=all_mem2_data;
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

for np=1:1000
    ln1_roi1=[];ln1_roi2=[];
    ln2_roi1=[];ln2_roi2=[];
    mem1_roi1=[];mem1_roi2=[];
    mem2_roi1=[];mem2_roi2=[];
    %get data for each permutation
    ln1_roi1=all_ln1_roi1{np};
    ln2_roi1=all_ln2_roi1{np};
    mem1_roi1=all_mem1_roi1{np};
    mem2_roi1=all_mem2_roi1{np};
    ln1_roi2=all_ln1_roi2{np};
    ln2_roi2=all_ln2_roi2{np};
    mem1_roi2=all_mem1_roi2{np};
    mem2_roi2=all_mem2_roi2{np};
    %calculate cross subs cross roi correlation 
    cc_ln1=1-pdist_with_NaN([ln1_roi1;ln2_roi2],'correlation');
    cc_ln2=1-pdist_with_NaN([ln2_roi1;ln1_roi2],'correlation');
    cc_ln=(cc_ln1+cc_ln2)/2;
    cc_mem1=1-pdist_with_NaN([mem1_roi1;mem2_roi2],'correlation');
    cc_mem2=1-pdist_with_NaN([mem2_roi1;mem1_roi2],'correlation');
    cc_mem=(cc_mem1+cc_mem2)/2;
    cc_ERS121=1-pdist_with_NaN([ln1_roi1;mem2_roi2],'correlation');
    cc_ERS122=1-pdist_with_NaN([ln2_roi2;mem1_roi1],'correlation');
    cc_ERS12=(cc_ERS121+cc_ERS122)/2;
    cc_ERS211=1-pdist_with_NaN([ln2_roi1;mem1_roi2],'correlation');
    cc_ERS212=1-pdist_with_NaN([ln1_roi2;mem2_roi1],'correlation');
    cc_ERS21=(cc_ERS211+cc_ERS212)/2;
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
        cln(sf,1,np)=ws_ln;
        cmem(sf,1,np)=ws_mem;
        cERS12(sf,1,np)=ws_ERS12;
        cERS21(sf,1,np)=ws_ERS21;
        %cross subs
        cln(sf,2,np)=mean(bs_ln);
        cmem(sf,2,np)=mean(bs_mem);
        cERS12(sf,2,np)=mean(bs_ERS12);
        cERS21(sf,2,np)=mean(bs_ERS21);
        %% rank
        Nrank_ln(sf,np)=sum(bs_ln<ws_ln);
        Nrank_mem(sf,np)=sum(bs_mem<ws_mem);
        Nrank_ERS12(sf,np)=sum(bs_ERS12<ws_ERS12);
        Nrank_ERS21(sf,np)=sum(bs_ERS21<ws_ERS21);
    end %end subs
    ln=mean(cln,3);mem=mean(cmem,3);
    ERS12=mean(cERS12,3);ERS21=mean(cERS21,3);
    ln_z=0.5*(log(1+ln)-log(1-ln));
    mem_z=0.5*(log(1+mem)-log(1-mem));
    ERS12_z=0.5*(log(1+ERS12)-log(1-ERS12));
    ERS21_z=0.5*(log(1+ERS21)-log(1-ERS21));
    aln_z=0.5*(log(1+cln)-log(1-cln));
    amem_z=0.5*(log(1+cmem)-log(1-cmem));
    aERS12_z=0.5*(log(1+cERS12)-log(1-cERS12));
    aERS21_z=0.5*(log(1+cERS21)-log(1-cERS21));
    eval(sprintf('save %s/BL_ln_%s_%s.txt ln_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
    eval(sprintf('save %s/BL_mem_%s_%s.txt mem_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
    eval(sprintf('save %s/BL_ERS12_%s_%s.txt ERS12_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
    eval(sprintf('save %s/BL_ERS21_%s_%s.txt ERS21_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
    eval(sprintf('save %s/BL_rank_ln_%s_%s.txt Nrank_ln -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
    eval(sprintf('save %s/BL_rank_mem_%s_%s.txt Nrank_mem -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
    eval(sprintf('save %s/BL_rank_ERS12_%s_%s.txt Nrank_ERS12 -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
    eval(sprintf('save %s/BL_rank_ERS21_%s_%s.txt Nrank_ERS21 -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));

    eval(sprintf('save %s/BL_aln_%s_%s.mat aln_z', resultdir,roi_name{roi1},roi_name{roi2}));
    eval(sprintf('save %s/BL_amem_%s_%s.mat amem_z', resultdir,roi_name{roi1},roi_name{roi2}));
    eval(sprintf('save %s/BL_aERS12_%s_%s.mat aERS12_z', resultdir,roi_name{roi1},roi_name{roi2}));
    eval(sprintf('save %s/BL_aERS21_%s_%s.mat aERS21_z', resultdir,roi_name{roi1},roi_name{roi2}));
end %function
