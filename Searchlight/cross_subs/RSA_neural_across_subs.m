function RSA_neural()
%subs=1;
%m=2;
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
xlength =  91;
ylength =  109;
zlength =  91;
radius  =  2;     % the cubic size is (2*radius+1) by (2*radius+1) by (2*radius+1)
step    =  1;     % compute accuracy map for every STEP voxels in each dimension
epsilon =  1e-6;
TN=96*2;
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behav/label'];
datadir=sprintf('%s/data_singletrial/glm/all_std',basedir);
rdir=sprintf('%s/Searchlight_RSM/standard_space/glm/across_subs/r',basedir);
mkdir(rdir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

%%%%%%%%%
subs=setdiff(1:21,2);
nsub=length(subs);

ws_ERS12=zeros(xlength,ylength,zlength,20);
ws_ERS21=zeros(xlength,ylength,zlength,20);
ws_mem=zeros(xlength,ylength,zlength,20);
ws_ln=zeros(xlength,ylength,zlength,20);
bs_ERS12=zeros(xlength,ylength,zlength,20);
bs_ERS21=zeros(xlength,ylength,zlength,20);
bs_mem=zeros(xlength,ylength,zlength,20);
bs_ln=zeros(xlength,ylength,zlength,20);


%%analysis
for k=radius+1:step:xlength-radius
    for j=radius+1:step:ylength-radius
        for i=radius+1:step:zlength-radius
            ln1_matrix=[];mem1_matrix=[];
            ln2_matrix=[];mem2_matrix=[];
            
            s=1;  
            %get fMRI data
            data_file=sprintf('%s/sub%02d.nii.gz',datadir,s);
            data_all=load_nii_zip(data_file);
            data=data_all.img;

            data_ball = data(k-radius:k+radius,j-radius:j+radius,i-radius:i+radius,:); % define small cubic for memory data
            a=size(data_ball);
            b=a(1)*a(2)*a(3);
            u=[];
            v_data = reshape(data_ball,b,TN);
            u=sum(v_data==0)/192;
            %bb=reshape(v_data,b*TN,1);
            if sum(std(v_data(:,:))==0)>epsilon | u>=0.125
            ERS_r(k,j,i,:)=10;
            mem_r(k,j,i,:)=10;
            ln_r(k,j,i,:)=10;
            else 
            for ns=length(subs)
                 s=subs(ns);
               [idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,...
                idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,...
                m_ln,m_mem]= get_idx(s); 
                load(sprintf('%s/encoding_sub%02d.mat',labeldir,s));
        load(sprintf('%s/test_sub%02d.mat',labeldir,s));
        list_ln=sortrows(subln,[Mset MpID]);
        list_ln(:,Msub)=s;
        list_ln(:,Mphase)=1;
        list_mem=sortrows(submem,[Mset MpID]);
        list_mem(:,Msub)=s;
        list_mem(:,Mphase)=2;
        for nn=1:96
            p=list_ln(nn,MpID);w=list_ln(nn,MwID);
            list_ln(nn,Mmem)=list_mem(list_mem(:,MpID)==p & list_mem(:,MwID)==w,Mmem);
        end
        all_label=[list_ln;list_mem];
        for r=1:TN
            for c=1:TN
            all_pIDr(r,c)=all_label(r,MpID);
            all_pIDc(r,c)=all_label(c,MpID);
            all_memr(r,c)=all_label(r,Mmem);
            all_memc(r,c)=all_label(c,Mmem);
            all_runr(r,c)=all_label(r,Mrun);
            all_runc(r,c)=all_label(c,Mrun);
            all_phaser(r,c)=all_label(r,Mphase);
            all_phasec(r,c)=all_label(c,Mphase);
            all_setr(r,c)=all_label(r,Mset);
            all_setc(r,c)=all_label(c,Mset);  
            end
        end
        %1=same run;0=diff run
        check_run=all_runr==all_runc;
        %1=same set;0=diff set
        check_set=all_setr==all_setc;  
        
        idx_ln1=find(all_phaser==1 & all_phasec==1 & all_setr==1  & all_pIDr~=all_pIDc ...
        & check_set==0);
        idx_ln2=find(all_phaser==1 & all_phasec==1 & all_setr==2  & all_pIDr~=all_pIDc ...
        & check_set==0);
        idx_mem1=find(all_phaser==2 & all_phasec==2 & all_setr==1 & all_pIDr~=all_pIDc ...
        & check_set==0);
        idx_mem2=find(all_phaser==2 & all_phasec==2 & all_setr==2 & all_pIDr~=all_pIDc ...
        & check_set==0);
              %get fMRI data
                data_file=sprintf('%s/sub%02d.nii.gz',datadir,s);
                data_all=load_nii_zip(data_file);
                data=data_all.img;

                data_ball = data(k-radius:k+radius,j-radius:j+radius,i-radius:i+radius,:); % define small cubic for memory data
                a=size(data_ball);
                b=a(1)*a(2)*a(3);
                v_data = reshape(data_ball,b,TN);
                
                xx=v_data';
                data_ln=xx(1:96,:);
                data_mem=xx(97:end,:);
                yy1=data_ln([1:24 49:72],:);p_ln_1=m_ln([1:24 49:72],:);

                yy2=data_ln([25:48 73:96],:);p_ln_2=m_ln([25:48 73:96],:);
                zz1=data_mem([1:24 49:72],:);p_mem_1=m_mem([1:24 49:72],:);
                zz2=data_mem([25:48 73:96],:);p_mem_2=m_mem([25:48 73:96],:);

                tyy1=[yy1,p_ln_1];a=size(tyy1);ttyy1=sortrows(tyy1,a(2));data_ln_1=ttyy1(:,[1:end-1]);
                tyy2=[yy2,p_ln_2];a=size(tyy2);ttyy2=sortrows(tyy2,a(2));data_ln_2=ttyy2(:,[1:end-1]);
                data_ln_all=[data_ln_1;data_ln_2];

                tzz1=[zz1,p_mem_1];a=size(tzz1);ttzz1=sortrows(tzz1,a(2));data_mem_1=ttzz1(:,[1:end-1]);
                tzz2=[zz2,p_mem_2];a=size(tzz2);ttzz2=sortrows(tzz2,a(2));data_mem_2=ttzz2(:,[1:end-1]);
                data_mem_all=[data_mem_1;data_mem_2];

                data_all=[data_ln_all;data_mem_all];
                cc_all=1-pdist(data_all(:,:),'correlation');
                tcc=squareform(cc_all);
                tcc(all_memr==0 | all_memc==0)=NaN;
                tmln1=[];tmln2=[];
                tmmem1=[];tmmem2=[];

                tln1=tcc(idx_ln1);
                size_ln=size(tln1);
                for nr=1:size_ln(1);
                    tmln1=[tmln1 tln1(nr,:)];
                end
                tln2=tcc(idx_ln2);
                size_ln=size(tln2);
                for nr=1:size_ln(1);
                    tmln2=[tmln2 tln2(nr,:)];
                end
                tmem1=tcc(idx_mem1);
                size_mem=size(tmem1);
                for nr=1:size_mem(1);
                    tmmem1=[tmmem1 tmem1(nr,:)];
                end
                tmem2=tcc(idx_mem2);
                size_mem=size(tmem2);
                for nr=1:size_mem(1);
                    tmmem2=[tmmem2 tmem2(nr,:)];
                end

                ln1_matrix=[ln1_matrix;tmln1];
                ln2_matrix=[ln2_matrix;tmln2];
                mem1_matrix=[mem1_matrix;tmmem1];
                mem2_matrix=[mem2_matrix;tmmem2];
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
                ws_ln(k,j,i,sf)=cc_ln(all_sub1==sf & check_sub==1 & check_ln==0);
                ws_mem(k,j,i,sf)=cc_mem(all_sub1==sf & check_sub==1 & check_mem==0);
                ws_ERS12(k,j,i,sf)=cc_ERS12(all_sub1==sf & check_sub==1 & check_ERS12==0);
                ws_ERS21(k,j,i,sf)=cc_ERS21(all_sub1==sf & check_sub==1 & check_ERS21==0);

                bs_ln(k,j,i,sf)=mean(cc_ln(all_sub1==sf & check_sub==0 & check_ln==0));
                bs_mem(k,j,i,sf)=mean(cc_mem(all_sub1==sf & check_sub==0 & check_mem==0));
                bs_ERS12(k,j,i,sf)=mean(cc_ERS12(all_sub1==sf & check_sub==0 & check_ERS12==0));
                bs_ERS21(k,j,i,sf)=mean(cc_ERS21(all_sub1==sf & check_sub==0 & check_ERS21==0));
            end
            end %end if
        end %end i
    end %end j
end %end k

cd (rdir)
filename=sprintf('ws_ERS12.nii');
data_all.img=squeeze(ws_ERS12(:,:,:,:));
data_all.hdr.dime.dim(5)=20; % dimension chagne to 6
save_untouch_nii(data_all, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('ws_ERS21.nii');
data_all.img=squeeze(ws_ERS21(:,:,:,:));
data_all.hdr.dime.dim(5)=20; % dimension chagne to 6
save_untouch_nii(data_all, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('ws_mem.nii');
data_all.img=squeeze(ws_mem(:,:,:,:));
data_all.hdr.dime.dim(5)=20; % dimension chagne to 3
save_untouch_nii(data_all, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('ws_ln.nii');
data_all.img=squeeze(ws_ln(:,:,:,:));
data_all.hdr.dime.dim(5)=20; % dimension chagne to 3
save_untouch_nii(data_all, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('bs_ERS12.nii');
data_all.img=squeeze(bs_ERS12(:,:,:,:));
data_all.hdr.dime.dim(5)=20; % dimension chagne to 6
save_untouch_nii(data_all, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('bs_ERS21.nii');
data_all.img=squeeze(bs_ERS21(:,:,:,:));
data_all.hdr.dime.dim(5)=20; % dimension chagne to 6
save_untouch_nii(data_all, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('bs_mem.nii');
data_all.img=squeeze(bs_mem(:,:,:,:));
data_all.hdr.dime.dim(5)=20; % dimension chagne to 3
save_untouch_nii(data_all, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('bs_ln.nii');
data_all.img=squeeze(bs_ln(:,:,:,:));
data_all.hdr.dime.dim(5)=20; % dimension chagne to 3
save_untouch_nii(data_all, filename);
system(sprintf('gzip -f %s',filename));
end %end func
