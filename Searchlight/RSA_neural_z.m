function RSA_neural(subs,m)
%subs=1;
%m=2;
methodsname={'LSS','TR34','ms_LSS'};
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
xlength =  112;
ylength =  112;
zlength =  64;
radius  =  2;     % the cubic size is (2*radius+1) by (2*radius+1) by (2*radius+1)
step    =  1;     % compute accuracy map for every STEP voxels in each dimension
epsilon =  1e-6;
TN=96*2
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behav/label'];
datadir=sprintf('%s/data_singletrial/%s/ref_space/all',basedir,methodsname{m});
rdir=sprintf('%s/Searchlight_RSM/ref_space/%s/zscore/r',basedir,methodsname{m});
addpath /seastor/helenhelen/scripts/NIFTI
%%%%%%%%%
for s=subs
ERS_r=zeros(xlength,ylength,zlength,6);
mem_r=zeros(xlength,ylength,zlength,3);
ln_r=zeros(xlength,ylength,zlength,3);
        %perpare data
        load(sprintf('%s/encoding_sub%02d.mat',labeldir,s));
        list_subln=subln;
        list_subln(:,Msub)=s;
        list_subln(:,Mphase)=1;
        load(sprintf('%s/test_sub%02d.mat',labeldir,s));
        list_submem=submem;
        list_submem(:,Msub)=s;
        list_submem(:,Mphase)=2;
        for nn=1:96
        p=list_subln(nn,MpID);w=list_subln(nn,MwID);
        list_subln(nn,Mmem)=list_submem(list_submem(:,MpID)==p & list_submem(:,MwID)==w,Mmem);
        end
        all_label=[list_subln;list_submem];

        all_idx=1:TN*(TN-1)/2; %% all paired correlation idx;
        all_pID1=[]; all_pID2=[]; all_wID1=[]; all_wID2=[]; all_Rcate=[]; all_mem1=[]; all_mem2=[]; all_phase1=[]; all_phase2=[]; all_cate1=[];  all_cate2=[]; check_run=[]; check_set=[]; check_cate=[];
        for k=2:TN
        all_pID1=[all_pID1 all_label(k-1,MpID)*ones(1,TN-k+1)];
        all_pID2=[all_pID2 all_label(k:TN,MpID)'];
        all_wID1=[all_wID1 all_label(k-1,MwID)*ones(1,TN-k+1)];
        all_wID2=[all_wID2 all_label(k:TN,MwID)'];
        all_mem1=[all_mem1 all_label(k-1,Mmem)*ones(1,TN-k+1)];
        all_mem2=[all_mem2 all_label(k:TN,Mmem)'];
        all_phase1=[all_phase1 all_label(k-1,Mphase)*ones(1,TN-k+1)];
        all_phase2=[all_phase2 all_label(k:TN,Mphase)'];
        all_cate1=[all_cate1 all_label(k-1,Mcat2)*ones(1,TN-k+1)];
        all_cate2=[all_cate2 all_label(k:TN,Mcat2)'];
        
	%1=same run;0=diff run 
        check_run=[check_run (all_label(k:TN,Mrun)==all_label(k-1,Mrun))'];

        %1=same set;0=diff set 
        check_set=[check_set (all_label(k:TN,Mset)==all_label(k-1,Mset))'];

        %1=same category;0=diff categories
        check_cate=[check_cate (all_label(k:TN,Mcat2)==all_label(k-1,Mcat2))'];
        end
        %% get indexes
        % ERS
        idx_ERS_I=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1==all_pID2 & all_wID1==all_wID2);%identity pair: p+c+
	idx_ERS_IB_all=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==1);
	idx_ERS_IB_wc=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==1 & check_cate==1);
        idx_ERS_D=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1==all_pID2 & all_wID1~=all_wID2);%%same face different words: p+c-
        idx_ERS_DB_all=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0);
        idx_ERS_DB_wc=find(all_phase1==1 & all_phase2==2 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0 & check_cate==1);
        %mem
        idx_mem_D=find(all_phase1==2 & all_phase2==2 & all_mem1 ==1 & all_mem1==1 & all_pID1==all_pID2 & all_wID1~=all_wID2);%%same face different words: p+c-
        idx_mem_DB_all=find(all_phase1==2 & all_phase2==2 & all_mem1==1 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0);
        idx_mem_DB_wc=find(all_phase1==2 & all_phase2==2 & all_mem1==1 & all_mem2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0 & check_cate==1);
        %ln
        idx_ln_D=find(all_phase1==1 & all_phase2==1 & all_pID1==all_pID2 & all_wID1~=all_wID2);%%same face different words: p+c-
  idx_ln_DB_all=find(all_phase1==1 & all_phase2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0);
  idx_ln_DB_wc=find(all_phase1==1 & all_phase2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0 & check_cate==1);
        
	%get fMRI data
        data_file=sprintf('%s/sub%02d.nii.gz',datadir,s);
        data_all=load_nii_zip(data_file);
        data=data_all.img;

        %%analysis
        for k=radius+1:step:xlength-radius
            for j=radius+1:step:ylength-radius
                for i=radius+1:step:zlength-radius
                    data_ball = data(k-radius:k+radius,j-radius:j+radius,i-radius:i+radius,:); % define small cubic for memory data
                    a=size(data_ball);
                    b=a(1)*a(2)*a(3);
                    v_data = reshape(data_ball,b,TN);
                    %bb=reshape(v_data,b*TN,1);
                    if sum(std(v_data(:,:))==0)>epsilon
                    ERS_r(k,j,i,:)=10;
                    mem_r(k,j,i,:)=10;
                    ln_r(k,j,i,:)=10;
                    else
                    xx=v_data';
                    	zxx=zscore(xx);
			cc=1-pdist(zxx(:,:),'correlation');
                    ERS_r(k,j,i,1)=mean(cc(idx_ERS_I));
                    ERS_r(k,j,i,2)=mean(cc(idx_ERS_IB_wc));
                    ERS_r(k,j,i,3)=mean(cc(idx_ERS_IB_all));
                    ERS_r(k,j,i,4)=mean(cc(idx_ERS_D));
                    ERS_r(k,j,i,5)=mean(cc(idx_ERS_DB_wc));
                    ERS_r(k,j,i,6)=mean(cc(idx_ERS_DB_all));

                    mem_r(k,j,i,1)=mean(cc(idx_mem_D));
                    mem_r(k,j,i,2)=mean(cc(idx_mem_DB_wc));
                    mem_r(k,j,i,3)=mean(cc(idx_mem_DB_all));

                    ln_r(k,j,i,1)=mean(cc(idx_ln_D));
                    ln_r(k,j,i,2)=mean(cc(idx_ln_DB_wc));
                    ln_r(k,j,i,3)=mean(cc(idx_ln_DB_all));
                    end %end if
                end %end i
            end %end j
        end %end k



cd (rdir)
       filename=sprintf('ERS_sub%02d.nii',s);
       data_all.img=squeeze(ERS_r(:,:,:,:));
       data_all.hdr.dime.dim(5)=6; % dimension chagne to 6
       save_untouch_nii(data_all, filename);
       system(sprintf('gzip -f %s',filename));

        filename=sprintf('mem_sub%02d.nii',s);
        data_all.img=squeeze(mem_r(:,:,:,:));
        data_all.hdr.dime.dim(5)=3; % dimension chagne to 3
        save_untouch_nii(data_all, filename);
        system(sprintf('gzip -f %s',filename));

        filename=sprintf('ln_sub%02d.nii',s);
        data_all.img=squeeze(ln_r(:,:,:,:));
        data_all.hdr.dime.dim(5)=3; % dimension chagne to 3
        save_untouch_nii(data_all, filename);
        system(sprintf('gzip -f %s',filename));
end %end sub
end %end func
