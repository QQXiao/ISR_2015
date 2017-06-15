function Cal_RepresentationSpace(r,subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

datadir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
resultdir=sprintf('%s/ROI_based/subs_within_between/add_rank/test/RS',basedir);
resultdir2=sprintf('%s/ROI_based/subs_within_between/add_rank/test/data_two_sets',basedir);
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
%%%%%%%%%
TN=96;
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
    'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
    'fmPFC','fPMC',...
    'CA1','DG','subiculum','PRC','ERC'};
%roi_name={'LSFG','RSFG'};
roi=r;
s=subs;

load(sprintf('%s/encoding_sub%02d.mat',labeldir,s));
load(sprintf('%s/test_sub%02d.mat',labeldir,s));
%get original sequece for pID
m_ln=subln(:,MpID);
m_mem=submem(:,MpID);
%sort data matrix according to set and pID
list_ln=sortrows(subln,[Mset MpID]);
list_ln(:,Msub)=s;
list_ln(:,Mphase)=1;
list_mem=sortrows(submem,[Mset MpID]);
list_mem(:,Msub)=s;
list_mem(:,Mphase)=2;
for nn=1:TN
    p=list_ln(nn,MpID);w=list_ln(nn,MwID);
    list_ln(nn,Mmem)=list_mem(list_mem(:,MpID)==p & list_mem(:,MwID)==w,Mmem);
end
%get memory performance for sorted behavioral list for later git
%rid of forgotten items.
memp_ln1=list_ln([1:(TN/2)],Mmem);
memp_ln2=list_ln([(TN/2+1):TN],Mmem);
memp_mem1=list_mem([1:(TN/2)],Mmem);
memp_mem2=list_mem([(TN/2+1):TN],Mmem);
%get fMRI data
xx=[];tmp_xx=[];u=[];
tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
txx=tmp_xx(4:end,:);
size_all=size(txx,2);
for j=1:size_all
    a=txx(:,j);
    ta=a';
    b = diff([0 a'==0 0]);
    res = find(b==-1) - find(b==1);
    u(j)=sum(res>=6);
end
txx(:,find(u>=1))=[];
xx=txx;
%%analysis
data_ln=xx(1:TN,:);
data_mem=xx((TN+1):end,:);
yy1=data_ln([1:(TN/2)],:);p_ln_1=m_ln([1:(TN/2)],:);
yy2=data_ln([(TN/2+1):TN],:);p_ln_2=m_ln([(TN/2+1):TN],:);
zz1=data_mem([1:(TN/2)],:);p_mem_1=m_mem([1:(TN/2)],:);
zz2=data_mem([(TN/2+1):TN],:);p_mem_2=m_mem([(TN/2+1):TN],:);
%%sort fMRI data acording to pic ID, for each repeat respectively
tyy1=[yy1,p_ln_1];a=size(tyy1);ttyy1=sortrows(tyy1,a(2));
tyy2=[yy2,p_ln_2];a=size(tyy2);ttyy2=sortrows(tyy2,a(2));
tzz1=[zz1,p_mem_1];a=size(tzz1);ttzz1=sortrows(tzz1,a(2));
tzz2=[zz2,p_mem_2];a=size(tzz2);ttzz2=sortrows(tzz2,a(2));
%%set forgotten items to NaN
ttyy1(memp_ln1==0,:)=NaN;
ttyy2(memp_ln2==0,:)=NaN;
ttzz1(memp_mem1==0,:)=NaN;
ttzz2(memp_mem2==0,:)=NaN;

rs_ln1_matrix=[];rs_mem1_matrix=[];rs_ln2_matrix=[];rs_mem2_matrix=[];
for np=1:1000 %permutation for 1000 times
    rs_ln1=[]; rs_ln2=[]; rs_mem1=[]; rs_mem2=[];
    %%mix data from two repetitions
    nt=a(1);
    c=unique(randperm(nt,nt/2));
    ln11=ttyy1(ismember([1:nt],c),:);
    ln12=ttyy1(~ismember([1:nt],c),:);
    ln21=ttyy2(~ismember([1:nt],c),:);
    ln22=ttyy2(ismember([1:nt],c),:);
    aln_1=[ln11;ln21];
    taln_1=sortrows(aln_1,a(2));
    data_ln_1=taln_1(:,[1:end-1]);
    aln_2=[ln12;ln22];
    taln_2=sortrows(aln_2,a(2));
    data_ln_2=taln_2(:,[1:end-1]);
    %%apply the mixation to memory data
    c=unique(randperm(nt,nt/2));
    mem11=ttzz1(ismember([1:nt],c),:);
    mem12=ttzz1(~ismember([1:nt],c),:);
    mem21=ttzz2(~ismember([1:nt],c),:);
    mem22=ttzz2(ismember([1:nt],c),:);
    amem_1=[mem11;mem21];
    tamem_1=sortrows(amem_1,a(2));
    data_mem_1=tamem_1(:,[1:end-1]);
    amem_2=[mem12;mem22];
    tamem_2=sortrows(amem_2,a(2));
    data_mem_2=tamem_2(:,[1:end-1]);
    all_data_ln1(:,:,np)=data_ln_1;
    all_data_ln2(:,:,np)=data_ln_2;
    all_data_mem1(:,:,np)=data_mem_1;
    all_data_mem2(:,:,np)=data_mem_2;
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
    %representation space matrix for all permutation
    rs_ln1_matrix=[rs_ln1_matrix;rs_ln1'];
    rs_ln2_matrix=[rs_ln2_matrix;rs_ln2'];
    rs_mem1_matrix=[rs_mem1_matrix;rs_mem1'];
    rs_mem2_matrix=[rs_mem2_matrix;rs_mem2'];
end % end permutation
mean_rs_ln1=mean(rs_ln1_matrix,1);
mean_rs_ln2=mean(rs_ln2_matrix,1);
mean_rs_mem1=mean(rs_mem1_matrix,1);
mean_rs_mem2=mean(rs_mem2_matrix,1);
eval(sprintf('save -v7.3 %s/sub%02d_%s.mat mean_rs_ln1 mean_rs_ln2 mean_rs_mem1 mean_rs_mem2', resultdir,s,roi_name{roi}));
eval(sprintf('save -v7.3 %s/sub%02d_%s.mat all_data_ln1 all_data_ln2 all_data_mem1 all_data_mem2', resultdir2,s,roi_name{roi}));
end %function
