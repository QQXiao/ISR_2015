function caculate_m_set()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

datadir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
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
%datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);
%%%%%%%%%
TN=192;
subs=setdiff(1:21,2);
%nt=200;
%roi_name={'CC','VVC','dLOC','IPL','SPL','IFG','MFG','HIP','PHG'};
%roi_name={'vLOC','OF','TOF','pTF','aTF','ANG','SMG','pSMG','aSMG','pPHG','aPHG'};
%roi_name={'LVVC','LdLOC','LIPL','LIFG','RVVC','RdLOC','RIPL','RIFG'};
%roi_name={'LVVC','LIPL','LIFG','RVVC','RIPL','RIFG'};
%roi_name={'LVVC','LANG','LSMG','LIFG','RVVC','RANG','RSMG','RIFG'};
%roi_name={'LVVC','LPHG','LANG','LSMG','LIFG','RVVC','RPHG','RANG','RSMG','RIFG'};
%roi_name={'tLVVC','LANG','LSMG','LIFG','tRVVC','RANG','RSMG','RIFG'};
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','tRVVC','RANG','RSMG','RIFG','RMFG'};
nroi=length(roi_name);
resultdir=sprintf('%s/ROI_based/ps_matrix_all_roi/glm/new_vvc_%droi_right_trial_only',basedir,nroi);
mkdir(resultdir);
for s=subs;
cc_ln_ln=[];
cc_mem_mem=[];
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);
load(sprintf('%s/encoding_sub%02d.mat',labeldir,s));
load(sprintf('%s/test_sub%02d.mat',labeldir,s));
list_ln=sortrows(subln,[Mrun Mset MpID]);
list_ln(:,Msub)=s;
list_ln(:,Mphase)=1;
list_mem=sortrows(submem,[Mrun Mset MpID]);
list_mem(:,Msub)=s;
list_mem(:,Mphase)=2;
        for nn=1:96
        p=list_ln(nn,MpID);w=list_ln(nn,MwID);
        list_ln(nn,Mmem)=list_mem(list_mem(:,MpID)==p & list_mem(:,MwID)==w,Mmem);
        end
all_label=[list_ln;list_mem];
all_idx=1:TN*(TN-1)/2;
all_pID1=[]; all_pID2=[]; all_mem1=[]; all_mem2=[]; all_phase1=[]; all_phase2=[]; check_run=[]; check_set=[];
for k=2:TN
        all_pID1=[all_pID1 all_label(k-1,MpID)*ones(1,TN-k+1)];
        all_pID2=[all_pID2 all_label(k:TN,MpID)'];
        all_mem1=[all_mem1 all_label(k-1,Mmem)*ones(1,TN-k+1)];
        all_mem2=[all_mem2 all_label(k:TN,Mmem)'];
        all_phase1=[all_phase1 all_label(k-1,Mphase)*ones(1,TN-k+1)];
        all_phase2=[all_phase2 all_label(k:TN,Mphase)'];
        %1=same run;0=diff run
        check_run=[check_run (all_label(k:TN,Mrun)==all_label(k-1,Mrun))'];
        %1=same set;0=diff set
        check_set=[check_set (all_label(k:TN,Mset)==all_label(k-1,Mset))'];
end
idx_ln=find(all_phase1==1 & all_phase2==1 & all_pID1~=all_pID2 & check_run==1 & check_set==0 & all_mem1==1 & all_mem2==1);
idx_mem=find(all_phase1==2 & all_phase2==2 & all_pID1~=all_pID2 & check_run==1 & check_set==0 & all_mem1==1 & all_mem2==1);
        %get fMRI data
        for roi=1:length(roi_name);
                xx=[];tmp_xx=[];u=[];
                tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
                %xx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
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
        	data_ln=xx(1:96,:);
         	data_mem=xx(97:end,:);
                    yy11=data_ln([1:24],:);yy12=data_ln([25:48],:);yy21=data_ln([49:72],:);yy22=data_ln([73:96],:);
                    p_ln_11=m_ln([1:24],:);p_ln_12=m_ln([25:48],:);p_ln_21=m_ln([49:72],:);p_ln_22=m_ln([73:96],:);
                    zz11=data_mem([1:24],:);zz12=data_mem([25:48],:);zz21=data_mem([49:72],:);zz22=data_mem([73:96],:);
                    p_mem_11=m_mem([1:24],:);p_mem_12=m_mem([25:48],:);p_mem_21=m_mem([49:72],:);p_mem_22=m_mem([73:96],:);

        	    tyy11=[yy11,p_ln_11];a=size(tyy11);ttyy11=sortrows(tyy11,a(2));data_ln_11=ttyy11(:,[1:end-1]);
        	    tyy12=[yy12,p_ln_12];a=size(tyy12);ttyy12=sortrows(tyy12,a(2));data_ln_12=ttyy12(:,[1:end-1]);
        	    tyy21=[yy21,p_ln_21];a=size(tyy21);ttyy21=sortrows(tyy21,a(2));data_ln_21=ttyy21(:,[1:end-1]);
        	    tyy22=[yy22,p_ln_22];a=size(tyy22);ttyy22=sortrows(tyy22,a(2));data_ln_22=ttyy22(:,[1:end-1]);
                    data_ln_all=[data_ln_11;data_ln_12;data_ln_21;data_ln_22];

        	    tzz11=[zz11,p_mem_11];a=size(tzz11);ttzz11=sortrows(tzz11,a(2));data_mem_11=ttzz11(:,[1:end-1]);
        	    tzz12=[zz12,p_mem_12];a=size(tzz12);ttzz12=sortrows(tzz12,a(2));data_mem_12=ttzz12(:,[1:end-1]);
        	    tzz21=[zz21,p_mem_21];a=size(tzz21);ttzz21=sortrows(tzz21,a(2));data_mem_21=ttzz21(:,[1:end-1]);
        	    tzz22=[zz22,p_mem_22];a=size(tzz22);ttzz22=sortrows(tzz22,a(2));data_mem_22=ttzz22(:,[1:end-1]);
                    data_mem_all=[data_mem_11;data_mem_12;data_mem_21;data_mem_22];

		    data_all=[data_ln_all;data_mem_all];
		    cc_all=1-pdist(data_all(:,:),'correlation');
                    %tcc_all=squareform(cc_all);

		    cc_ln_ln(roi,:)=cc_all(idx_ln);
		    cc_mem_mem(roi,:)=cc_all(idx_mem);
        end %roi
cc_a_roi_ln_ln(s,:)=1-pdist(cc_ln_ln(:,:),'correlation');
cc_a_roi_mem_mem(s,:)=1-pdist(cc_mem_mem(:,:),'correlation');

cor_matrix_all=[cc_ln_ln;cc_mem_mem];
cc_cor_matrix_all=1-pdist(cor_matrix_all(:,:),'correlation');
ttlm=squareform(cc_cor_matrix_all);
tlm=ttlm([1:nroi],[(nroi+1):(2*nroi)]);
cc_a_roi_ln_mem(s,:)=tlm(:);
end %end sub
cc_a_roi_ln_ln=cc_a_roi_ln_ln(subs,:,:);
cc_a_roi_mem_mem=cc_a_roi_mem_mem(subs,:,:);
cc_a_roi_ln_mem=cc_a_roi_ln_mem(subs,:,:);
c_ln_mem_subs=0.5*(log(1+cc_a_roi_ln_mem)-log(1-cc_a_roi_ln_mem));
c_ln_ln=squareform(squeeze(mean(cc_a_roi_ln_ln,1)));
c_mem_mem=squareform(squeeze(mean(cc_a_roi_mem_mem,1)));
%c_ln_ln=0.5*(log(1+tc_ln_ln)-log(1-tc_ln_ln));
%c_mem_mem=0.5*(log(1+tc_mem_mem)-log(1-tc_mem_mem));
tc_ln_mem=reshape(mean(cc_a_roi_ln_mem),nroi,nroi);
c_ln_mem=0.5*(log(1+tc_ln_mem)-log(1-tc_ln_mem));

eval(sprintf('save %s/a_roi_corr_ln_ln.txt c_ln_ln -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_mem_mem.txt c_mem_mem -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_ln_mem.txt c_ln_mem -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_ln_mem_subs.txt c_ln_mem_subs -ascii -tabs', resultdir));
end %function
