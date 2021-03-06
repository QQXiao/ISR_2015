function Cal_Similarity_RepresentationSpace_AcrossROIs(r1,r2)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

datadir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/RS',basedir);
resultdir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/method1/AcrossROIs',basedir);
resultdir2=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/method2/AcrossROIs',basedir);
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
rs_ln1_matrix_roi1=[];rs_mem1_matrix_roi1=[];rs_ln2_matrix_roi1=[];rs_mem2_matrix_roi1=[];
rs_ln1_matrix_roi2=[];rs_mem1_matrix_roi2=[];rs_ln2_matrix_roi2=[];rs_mem2_matrix_roi2=[];
all_subs_rs_ln1=[]; all_subs_rs_ln2=[]; all_subs_rs_mem1=[]; all_subs_rs_mem2=[];
for s=subs;
    %%load representational space data from ROI1
    load(sprintf('%s/sub%02d_%s.mat',datadir,s,roi_name{roi1}));
    %get representation space for all subjects for methods2: calculated mean activation across subjects as
    %the activation pattern for between subjects
    rs_ln1_matrix_roi1=[rs_ln1_matrix_roi1;mean_rs_ln1];
    rs_ln2_matrix_roi1=[rs_ln2_matrix_roi1;mean_rs_ln2];
    rs_mem1_matrix_roi1=[rs_mem1_matrix_roi1;mean_rs_mem1];
    rs_mem2_matrix_roi1=[rs_mem2_matrix_roi1;mean_rs_mem2];
    %%load representational space data from ROI2
    load(sprintf('%s/sub%02d_%s.mat',datadir,s,roi_name{roi1}));
    %get representation space for all subjects for methods2: calculated mean activation across subjects as
    %the activation pattern for between subjects
    rs_ln1_matrix_roi2=[rs_ln1_matrix_roi2;mean_rs_ln1];
    rs_ln2_matrix_roi2=[rs_ln2_matrix_roi2;mean_rs_ln2];
    rs_mem1_matrix_roi2=[rs_mem1_matrix_roi2;mean_rs_mem1];
    rs_mem2_matrix_roi2=[rs_mem2_matrix_roi2;mean_rs_mem2];
end %end subs
clear mean_rs_ln1 mean_rs_ln2 mean_rs_mem1 mean_rs_mem2
%%set sublist
allsub=[subs subs subs subs];nasub=length(allsub);
%1=set1; 2=set2
allln=[ones(1,nsub) 2*ones(1,nsub) ones(1,nsub) 2*ones(1,nsub)];
allmem=[ones(1,nsub) 2*ones(1,nsub) ones(1,nsub) 2*ones(1,nsub)];
allERS=[ones(1,nsub) 2*ones(1,nsub) ones(1,nsub) 2*ones(1,nsub)];
allroi=[ones(1,2*nsub) 2*ones(1,2*nsub)];
all_sub1=[];all_sub2=[];
all_ln1=[];all_ln2=[];
all_roi1=[];all_roi2=[];
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
    all_roi1=[all_roi1 allroi(ss-1)*ones(1,nasub-ss+1)];
    all_roi2=[all_roi2 allroi(ss:nasub)];
end
%whether the correlation is for same subject or not;
%1=same;0=different;
check_sub=[all_sub1==all_sub2];
%1=same;0=different;
check_roi=[all_roi1==all_roi2];
%whether the correlation is for same data set or not;
%1=same;0=different;
check_ln=[all_ln1==all_ln2];
check_mem=[all_mem1==all_mem2];
check_ERS=[all_ERS1==all_ERS2];
%calculate cross subs correlation
cc_ln=1-pdist_with_NaN([rs_ln1_matrix_roi1;rs_ln2_matrix_roi1;rs_ln1_matrix_roi2;rs_ln2_matrix_roi2],'correlation');
cc_mem=1-pdist_with_NaN([rs_mem1_matrix_roi1;rs_mem2_matrix_roi1;rs_mem1_matrix_roi2;rs_mem2_matrix_roi2],'correlation');
cc_ERS12=1-pdist_with_NaN([rs_ln1_matrix_roi1;rs_mem2_matrix_roi1;rs_ln1_matrix_roi2;rs_mem2_matrix_roi2],'correlation');
cc_ERS21=1-pdist_with_NaN([rs_ln2_matrix_roi1;rs_mem1_matrix_roi1;rs_ln2_matrix_roi2;rs_mem1_matrix_roi2],'correlation');
cc_ERS=(cc_ERS12+cc_ERS21)/2;
%get within sub's or cross subs' correlation
for sf=subs
    ws_ln=cc_ln(all_sub1==sf & check_sub==1 & check_ln==0 & check_roi==0);
    ws_mem=cc_mem(all_sub1==sf & check_sub==1 & check_mem==0 & check_roi==0);
    ws_ERS=cc_ERS(all_sub1==sf & check_sub==1 & check_ERS==0 & check_roi==0);
    bs_ln=cc_ln(all_sub1==sf & check_sub==0 & check_ln==0 & check_roi==0);
    bs_mem=cc_mem(all_sub1==sf & check_sub==0 & check_mem==0 & check_roi==0);
    bs_ERS=cc_ERS(all_sub1==sf & check_sub==0 & check_ERS==0 & check_roi==0);
    %withi sub
    cln(sf,1)=mean(ws_ln);
    cmem(sf,1)=mean(ws_mem);
    cERS(sf,1)=mean(ws_ERS);
    %cross subs
    cln(sf,2)=mean(bs_ln);
    cmem(sf,2)=mean(bs_mem);
    cERS(sf,2)=mean(bs_ERS);
    %% all subs
    for sff=subs
        ps_ln(sf,sff)=mean(cc_ln(all_sub1==sf & all_sub2==sff & check_ln==0));
        ps_mem(sf,sff)=mean(cc_mem(all_sub1==sf & all_sub2==sff & check_ln==0));
        ps_ERS(sf,sff)=mean(cc_ERS(all_sub1==sf & all_sub2==sff & check_ln==0));
    end
    %% rank
    Nrank_ln(sf)=sum(ps_ln(sf,setdiff(subs,sf))<ps_ln(sf,sf));
    Nrank_mem(sf)=sum(ps_mem(sf,setdiff(subs,sf))<ps_mem(sf,sf));
    Nrank_ERS(sf)=sum(ps_ERS(sf,setdiff(subs,sf))<ps_ERS(sf,sf));
end %end subs
ln_z=0.5*(log(1+cln)-log(1-cln));
mem_z=0.5*(log(1+cmem)-log(1-cmem));
ERS_z=0.5*(log(1+cERS)-log(1-cERS));
ps_ln_z=0.5*(log(1+ps_ln)-log(1-ps_ln));
ps_mem_z=0.5*(log(1+ps_mem)-log(1-ps_mem));
ps_ERS_z=0.5*(log(1+ps_ERS)-log(1-ps_ERS));
eval(sprintf('save %s/ln_%s_%s.txt ln_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/mem_%s_%s.txt mem_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/ERS_%s_%s.txt ERS_z -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/rank_ln_%s_%s.txt Nrank_ln -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/rank_mem_%s_%s.txt Nrank_mem -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/rank_ERS_%s_%s.txt Nrank_ERS -ascii -tabs', resultdir,roi_name{roi1},roi_name{roi2}));
eval(sprintf('save %s/ps_%s_%s.mat ps_ln_z ps_mem_z ps_ERS_z', resultdir,roi_name{roi1},roi_name{roi2}));
end %function




