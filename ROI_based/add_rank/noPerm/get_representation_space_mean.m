function get_representation_space(r)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

datadir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
labeldir=[basedir,'/behav/label'];
resultdir=sprintf('%s/ROI_based/subs_within_between/noPerm_mean',basedir);

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
    'fmPFC','fPMC'...
    'CA1','DG','subiculum','PRC','ERC'};
%roi_name={'fmPFC','fPMC'};
nroi=length(roi_name);
roi=r;
    ln1_matrix=[];mem1_matrix=[];
    ln2_matrix=[];mem2_matrix=[];
    sdata=[];
    for s=subs;
        load(sprintf('%s/encoding_sub%02d.mat',labeldir,s));
        load(sprintf('%s/test_sub%02d.mat',labeldir,s));
        m_ln=subln(:,MpID);
        m_mem=submem(:,MpID);
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
        %get memory performance for sorted behavioral list for later get
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
        taln_1=ttyy1;taln_2=ttyy2;
        tamem_1=ttzz1;tamem_2=ttzz2;
        data_ln_1=taln_1(:,[1:end-1]);
        data_ln_2=taln_2(:,[1:end-1]);
        tamem_1=sortrows(ttzz1,a(2));
        tamem_2=sortrows(ttzz2,a(2));
        data_mem_1=tamem_1(:,[1:end-1]);
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
    for st=1:length(subs);
        s=subs(st);
        os=setdiff([1:length(subs)],st);
        s_ln1_matrix=ln1_matrix(st,:);
        s_ln2_matrix=ln2_matrix(st,:);
        m_ln1_matrix=mean(ln1_matrix(os,:));
        m_ln2_matrix=mean(ln2_matrix(os,:));
        s_mem1_matrix=mem1_matrix(st,:);
        s_mem2_matrix=mem2_matrix(st,:);
        m_mem1_matrix=mean(mem1_matrix(os,:));
        m_mem2_matrix=mean(mem2_matrix(os,:));
        cln(s,1)=corr(s_ln1_matrix',s_ln2_matrix');
        cln(s,2)=corr(s_ln1_matrix',m_ln2_matrix');
        cmem(s,1)=corr(s_mem1_matrix',s_mem2_matrix');
        cmem(s,2)=corr(s_mem1_matrix',m_mem2_matrix');
        cERS12(s,1)=corr(s_ln1_matrix',s_mem2_matrix');
        cERS12(s,2)=corr(s_ln1_matrix',m_mem2_matrix');
        cERS21(s,1)=corr(s_ln2_matrix',s_mem1_matrix');
        cERS21(s,2)=corr(s_ln2_matrix',m_mem1_matrix');
    end
    ln=cln;mem=cmem;ERS12=cERS12;ERS21=cERS21;
    ln_z=0.5*(log(1+ln)-log(1-ln));
    mem_z=0.5*(log(1+mem)-log(1-mem));
    ERS12_z=0.5*(log(1+ERS12)-log(1-ERS12));
    ERS21_z=0.5*(log(1+ERS21)-log(1-ERS21));
    eval(sprintf('save %s/ln_%s.txt ln_z -ascii -tabs', resultdir,roi_name{roi}));
    eval(sprintf('save %s/mem_%s.txt mem_z -ascii -tabs', resultdir,roi_name{roi}));
    eval(sprintf('save %s/ERS12_%s.txt ERS12_z -ascii -tabs', resultdir,roi_name{roi}));
    eval(sprintf('save %s/ERS21_%s.txt ERS21_z -ascii -tabs', resultdir,roi_name{roi}));
end %function
