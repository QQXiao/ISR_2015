function Cal_Similarity_RepresentationSpace(r)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
datadir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
resultdir1=sprintf('%s/ROI_based/subs_within_between/MantelTest/noAver/method1',basedir);
labeldir=[basedir,'/behav/label'];
mkdir(resultdir1);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%trial index for method 1
allsub=[subs subs];nasub=length(allsub);
%1=set1; 2=set2
allset=[ones(1,nsub) 2*ones(1,nsub)];
all_sub1=[];all_sub2=[];
all_set1=[];all_set2=[];
check_sub=[];
check_set=[];
for ss=2:nasub;
all_sub1=[all_sub1 allsub(ss-1)*ones(1,nasub-ss+1)];
all_sub2=[all_sub2 allsub(ss:nasub)];
all_set1=[all_set1 allset(ss-1)*ones(1,nasub-ss+1)];
all_set2=[all_set2 allset(ss:nasub)];
end
%whether the correlation is for same subject or not;
%1=same;0=different;
check_sub=[all_sub1==all_sub2];
%whether the correlation is for same data set or not;
%1=same;0=different;
check_set=[all_set1==all_set2];
Cond_Name={'ln','mem','ERS'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PART1: simarity for within subjects representational similarity
for t=1:1000 %permutation for 1000 times for shuffering trials in set1 and set2
    rs_ln1_matrix=[];rs_mem1_matrix=[];rs_ln2_matrix=[];rs_mem2_matrix=[];
    b_rs_ln1_matrix=[];b_rs_mem1_matrix=[];b_rs_ln2_matrix=[];b_rs_mem2_matrix=[];
    for ts=1:length(subs);
        s=subs(ts);
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
        %calculate the correlation between data from two sets
        c_ln=corr(data_ln_1',data_ln_2');
        c_ln2=c_ln';
        c_mem=corr(data_mem_1',data_mem_2');
        c_mem2=c_mem';
        %get the tril of the correlation matrix as the representational
        %%space for each set
        rs_ln1=c_ln(triu(c_ln)==0);
        rs_ln2=c_ln2(triu(c_ln2)==0);
        rs_mem1=c_mem(triu(c_mem)==0);
        rs_mem2=c_mem2(triu(c_mem2)==0);
        %representation space matrix for all subs
        rs_ln1_matrix=[rs_ln1_matrix;rs_ln1'];
        rs_ln2_matrix=[rs_ln2_matrix;rs_ln2'];
        rs_mem1_matrix=[rs_mem1_matrix;rs_mem1'];
        rs_mem2_matrix=[rs_mem2_matrix;rs_mem2'];
        %representation space matrix for all subs and all permutations
        all_rs_ln1_matrix(ts,t,:)=rs_ln1;
        all_rs_ln2_matrix(ts,t,:)=rs_ln2;
        all_rs_mem1_matrix(ts,t,:)=rs_mem1;
        all_rs_mem2_matrix(ts,t,:)=rs_mem2;
        %for baseline
        lenln=length(c_ln);
        perm=randperm(lenln);
        b_c_ln1=c_ln(perm, perm);
        b_c_ln2=b_c_ln1';
        b_c_mem1=c_mem(perm, perm);
        b_c_mem2=b_c_mem1';
        b_rs_ln1=b_c_ln1(triu(b_c_ln1)==0);
        b_rs_ln2=b_c_ln2(triu(b_c_ln2)==0);
        b_rs_mem1=b_c_mem1(triu(b_c_mem1)==0);
        b_rs_mem2=b_c_mem2(triu(b_c_mem2)==0);
        %representation space matrix for all subs
        b_rs_ln1_matrix=[b_rs_ln1_matrix;b_rs_ln1'];
        b_rs_ln2_matrix=[b_rs_ln2_matrix;b_rs_ln2'];
        b_rs_mem1_matrix=[b_rs_mem1_matrix;b_rs_mem1'];
        b_rs_mem2_matrix=[b_rs_mem2_matrix;b_rs_mem2'];
        %representation space matrix for all subs and all permutations
        b_all_rs_ln1_matrix(ts,t,:)=b_rs_ln1;
        b_all_rs_ln2_matrix(ts,t,:)=b_rs_ln2;
        b_all_rs_mem1_matrix(ts,t,:)=b_rs_mem1;
        b_all_rs_mem2_matrix(ts,t,:)=b_rs_mem2;
    end %end subs (ts)
    %%%%%%%%%
    % calculate within subject similarity for representational space
    %%%%%%%%%
    [ws_ln_m1,ws_mem_m1,ws_ERS_m1,ps_ln,ps_mem,ps_ERS,...
    bs_ln_m1,bs_mem_m1,bs_ERS_m1,...
    ws_ln_m2,ws_mem_m2,ws_ERS_m2,bs_ln_m2,bs_mem_m2,bs_ERS_m2] = ...
    Cal_RS_similarity(rs_ln1_matrix,rs_ln2_matrix,rs_mem1_matrix,rs_mem2_matrix,subs,Cond_Name,all_sub1,all_sub2,check_set);
    %get within sub's or cross subs' correlation
    for c=1:length(Cond_Name)
        eval(sprintf('all_c%s1(:,1,t) = ws_%s_m1;',Cond_Name{c},Cond_Name{c}));
        eval(sprintf('all_c%s2(:,1,t) = ws_%s_m2;',Cond_Name{c},Cond_Name{c}));
        eval(sprintf('all_c%s1(:,2,t) = bs_%s_m1;',Cond_Name{c},Cond_Name{c}));
        eval(sprintf('all_c%s2(:,2,t) = bs_%s_m2;',Cond_Name{c},Cond_Name{c}));
        for sf=subs
            for sff=subs
                eval(sprintf('all_ps_%s(sf,sff,t) = ps_%s(sf,sff);',Cond_Name{c},Cond_Name{c}));
            end
        eval(sprintf('all_Nrank_%s(sf,t)=sum(all_ps_%s(sf,sf)>all_ps_%s(sf,setdiff(subs,[2 sf])));',Cond_Name{c},Cond_Name{c},Cond_Name{c}));
        end
    end %end cond
end %end t for 1000 permutations
%get mean across 1000 permutations
for c=1:length(Cond_Name)
    eval(sprintf('c%s1=mean(all_c%s1,3);',Cond_Name{c},Cond_Name{c}));
    eval(sprintf('c%s2=mean(all_c%s2,3);',Cond_Name{c},Cond_Name{c}));
    eval(sprintf('fps_%s=mean(all_ps_%s,3);',Cond_Name{c},Cond_Name{c}));
    eval(sprintf('Nrank_%s=mean(all_Nrank_%s,2);',Cond_Name{c},Cond_Name{c}));
end
%clear no use matrix
clear aln_* amem_* taln_* tamem_* data_* ln1* ln2* mem1* mem2* xx txx ttyy* ttzz* tyy* tzz* yy* zz*
clear c_ln* c_mem* all_cln* all_cmem*  all_ps*

%get z
for c=1:length(Cond_Name)
    eval(sprintf('%s_z1=0.5*(log(1+c%s1)-log(1-c%s1))',Cond_Name{c},Cond_Name{c},Cond_Name{c}));
    eval(sprintf('%s_z2=0.5*(log(1+c%s2)-log(1-c%s2))',Cond_Name{c},Cond_Name{c},Cond_Name{c}));
    eval(sprintf('ps_%s=0.5*(log(1+fps_%s)-log(1-fps_%s))',Cond_Name{c},Cond_Name{c},Cond_Name{c}));
    eval(sprintf('save %s/%s_%s.txt %s_z1 -ascii -tabs', resultdir1,Cond_Name{c},roi_name{roi},Cond_Name{c}));
    eval(sprintf('save %s/rank_%s_%s.txt Nrank_%s -ascii -tabs', resultdir1,Cond_Name{c},roi_name{roi},Cond_Name{c}));
end
eval(sprintf('save %s/ps_%s.mat ps_ln ps_mem ps_ERS', resultdir1,roi_name{roi}));
end %function
