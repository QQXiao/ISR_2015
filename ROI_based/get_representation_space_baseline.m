function get_representation_space(r)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

datadir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
labeldir=[basedir,'/behav/label'];
resultdir=sprintf('%s/ROI_based/subs_within_between',basedir);

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
TN=96;%96 trials in encoding and retrieval, respectively;
subs=setdiff(1:21,2);
nsub=length(subs);
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
    'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
    'mPFC','PCC'...
    'CA1','DG','subiculum','PRC','ERC'};
nroi=length(roi_name);
roi=r;
for np=1:1000
    ln1_matrix=[];mem1_matrix=[];
    ln2_matrix=[];mem2_matrix=[];
    for s=subs;
        load(sprintf('%s/encoding_sub%02d.mat',labeldir,s));
        load(sprintf('%s/test_sub%02d.mat',labeldir,s));
        for nn=1:TN
            p=subln(nn,MpID);w=subln(nn,MwID);
            subln(nn,Mmem)=submem(submem(:,MpID)==p & submem(:,MwID)==w,Mmem);
        end
        m_ln=subln(:,MpID);
        m_mem=submem(:,MpID);
        %shuffling PID;
        t_m_ln=m_ln(randperm(TN),:);
        t_m_mem=m_mem(randperm(TN),:);
        subln(:,MpID)=t_m_ln;
        submem(:,MpID)=t_m_mem;
        m_ln=subln(:,MpID);
        m_mem=submem(:,MpID);
        list_ln=sortrows(subln,[Mset MpID]);
        list_ln(:,Msub)=s;
        list_ln(:,Mphase)=1;
        list_mem=sortrows(submem,[Mset MpID]);
        list_mem(:,Msub)=s;
        list_mem(:,Mphase)=2;  
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
        %%mix data from two repetitions
        nt=a(1);
        c=unique(randperm(nt,nt/2));
        c_ln11=ttyy1(ismember([1:nt],c),:);
        c_ln12=ttyy1(~ismember([1:nt],c),:);
        c_ln21=ttyy2(~ismember([1:nt],c),:);
        c_ln22=ttyy2(ismember([1:nt],c),:);
        aln_1=[c_ln11;c_ln21];
        taln_1=sortrows(aln_1,a(2));
        data_ln_1=taln_1(:,[1:end-1]);
        aln_2=[c_ln12;c_ln22];
        taln_2=sortrows(aln_2,a(2));
        data_ln_2=taln_2(:,[1:end-1]);
        %%apply the mixation to memory data
        c=unique(randperm(nt,nt/2));
        c_mem11=ttzz1(ismember([1:nt],c),:);
        c_mem12=ttzz1(~ismember([1:nt],c),:);
        c_mem21=ttzz2(~ismember([1:nt],c),:);
        c_mem22=ttzz2(ismember([1:nt],c),:);
        amem_1=[c_mem11;c_mem21];
        tamem_1=sortrows(amem_1,a(2));
        data_mem_1=tamem_1(:,[1:end-1]);
        amem_2=[c_mem12;c_mem22];
        tamem_2=sortrows(amem_2,a(2));
        data_mem_2=tamem_2(:,[1:end-1]);
        %%calculate the correlation between two presentations' matrix
        c_ln1=corr(data_ln_1',data_ln_2');
        c_ln2=corr(data_ln_2',data_ln_1');
        c_mem1=corr(data_mem_1',data_mem_2');
        c_mem2=corr(data_mem_2',data_mem_1');  
        %%get the tril of the correlation matrix as the representational
        %%space for each rep
        tc_ln1=c_ln1(triu(c_ln1)==0);
        tc_ln2=c_ln2(triu(c_ln2)==0);
        tc_mem1=c_mem1(triu(c_mem1)==0);
        tc_mem2=c_mem2(triu(c_mem2)==0);        
        %%
        ln1_matrix=[ln1_matrix;tc_ln1'];
        ln2_matrix=[ln2_matrix;tc_ln2'];
        mem1_matrix=[mem1_matrix;tc_mem1'];
        mem2_matrix=[mem2_matrix;tc_mem2'];
    end %end sub
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

    cc_ln=1-pdist_with_NaN([ln1_matrix;ln2_matrix],'correlation');
    cc_mem=1-pdist_with_NaN([mem1_matrix;mem2_matrix],'correlation');
    cc_ERS12=1-pdist_with_NaN([ln1_matrix;mem2_matrix],'correlation');
    cc_ERS21=1-pdist_with_NaN([ln2_matrix;mem1_matrix],'correlation');

    for sf=subs
        cln(sf,1,np)=cc_ln(all_sub1==sf & check_sub==1 & check_ln==0);
        cmem(sf,1,np)=cc_mem(all_sub1==sf & check_sub==1 & check_mem==0);
        cERS12(sf,1,np)=cc_ERS12(all_sub1==sf & check_sub==1 & check_ERS12==0);
        cERS21(sf,1,np)=cc_ERS21(all_sub1==sf & check_sub==1 & check_ERS21==0);

        cln(sf,2,np)=mean(cc_ln(all_sub1==sf & check_sub==0 & check_ln==0));
        cmem(sf,2,np)=mean(cc_mem(all_sub1==sf & check_sub==0 & check_mem==0));
        cERS12(sf,2,np)=mean(cc_ERS12(all_sub1==sf & check_sub==0 & check_ERS12==0));
        cERS21(sf,2,np)=mean(cc_ERS21(all_sub1==sf & check_sub==0 & check_ERS21==0));
    end
end %end perm
    ln_z=0.5*(log(1+cln)-log(1-cln));
    mem_z=0.5*(log(1+cmem)-log(1-cmem));
    ERS12_z=0.5*(log(1+cERS12)-log(1-cERS12));
    ERS21_z=0.5*(log(1+cERS21)-log(1-cERS21));
    eval(sprintf('save %s/BL_ln_%s.mat ln_z', resultdir,roi_name{roi}));
    eval(sprintf('save %s/BL_mem_%s.mat mem_z', resultdir,roi_name{roi}));
    eval(sprintf('save %s/BL_ERS12_%s.mat ERS12_z', resultdir,roi_name{roi}));
    eval(sprintf('save %s/BL_ERS21_%s.mat ERS21_z', resultdir,roi_name{roi}));
end %function
