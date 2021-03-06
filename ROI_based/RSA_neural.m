function RSA_neural(subs,m)
%subs=1;
%m=2;
methodname={'LSS','TR','ms_LSS','glm'};
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behav/label'];
datadir=sprintf('%s/ROI_based/ref_space/%s/raw',basedir,methodname{m});
%rdir=sprintf('%s/ROI_based/ref_space/%s/tVVC/sub/r',basedir,methodname{m});
zdir=sprintf('%s/ROI_based/ref_space/%s/tVVC/sub/z',basedir,methodname{m});
%zdir=sprintf('%s/ROI_based/ref_space/%s/sub_hipp/sub/z',basedir,methodname{m});
%rdir=sprintf('%s/ROI_based/ref_space/%s/sub_hipp/sub/r',basedir,methodname{m});
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

TN=96*2;
%%%%%%%%%
%roi_name={'tLVVC','tRVVC'};
%roi_name={'mPFC','PCC','LSFG','RSFG','LMFG','RMFG'};
%roi_name={'CC','VVC','dLOC','IPL','IFG','PHG','HIP'};
%roi_name={'CC','vLOC','OF','TOF','pTF','aTF',...
%'dLOC','ANG','SMG','IFG',...
%'HIP','pPHG','aPHG'}
%roi_name={'CA1','CA2','DG','CA3','subiculum','PRC','ERC','pPHG'};
%roi_name={'CC','VVC','dLOC','ANG','SMG','IFG',...
%        'CA1','CA2','DG','CA3','subiculum','ERC',...
%	'HIP','pPHG','aPHG',...
%               'aSMG','pSMG'}
roi_name={'CC','VVC','dLOC','IPL','SPL','IFG','MFG','HIP','PHG',...
'vLOC','OF','TOF','pTF','aTF','ANG','SMG','pSMG','aSMG','pPHG','aPHG',...
'mPFC','PCC','LSFG','RSFG','LMFG','RMFG','tLVVC','tRVVC',...
'LCC','LVVC','LdLOC','LIPL','LSPL','LIFG','LMFG','LHIP','LPHG',...
'LvLOC','LOF','LTOF','LpTF','LaTF','LANG','LSMG','LpSMG','LaSMG','LpPHG','LaPHG',...
'RCC','RVVC','RdLOC','RIPL','RSPL','RIFG','RMFG','RHIP','RPHG',...
'RvLOC','ROF','RTOF','RpTF','RaTF','RANG','RSMG','RpSMG','RaSMG','RpPHG','RaPHG',...
'LITG','RITG','LpFUS','RpFUS',...
'CA1','CA2','DG','CA3','subiculum','PRC','ERC'};
ERS_r=[]; ERS_z=[]; mem_r=[]; mem_z=[]; ln_r=[]; ln_z=[];
nERS=[]; nmem=[]; nln=[];
for s=subs
        %get idx
        [idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem] = get_idx(s);
        %perpare data
	for roi=1:length(roi_name);
        txx=[];xx=[];tmp_xx=[];u=[];
        tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
        %txx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
        txx=tmp_xx(4:end,:);
	%data_all=xx;
	size_all=size(txx,2);
	for j=1:size_all
	%u(j)=sum(txx(:,j)==0)/192;
	a=txx(:,j);
	ta=a';
	b = diff([0 a'==0 0]);
	res = find(b==-1) - find(b==1);
	u(j)=sum(res>=6);
	end
	txx(:,find(u>=1))=[];
	xx=txx;
        ln=xx(1:96,:);
        mem=xx(97:end,:);
	data_all=[ln;mem];
        cc=1-pdist(data_all(:,:),'correlation');
        ERS_r(roi,1)=mean(cc(idx_ERS_I));
        ERS_r(roi,2)=mean(cc(idx_ERS_IB_wc));
        ERS_r(roi,3)=mean(cc(idx_ERS_IB_all));
        ERS_r(roi,4)=mean(cc(idx_ERS_D));
        ERS_r(roi,5)=mean(cc(idx_ERS_DB_wc));
        ERS_r(roi,6)=mean(cc(idx_ERS_DB_all));

        mem_r(roi,1)=mean(cc(idx_mem_D));
        mem_r(roi,2)=mean(cc(idx_mem_DB_wc));
        mem_r(roi,3)=mean(cc(idx_mem_DB_all));

        ln_r(roi,1)=mean(cc(idx_ln_D));
        ln_r(roi,2)=mean(cc(idx_ln_DB_wc));
        ln_r(roi,3)=mean(cc(idx_ln_DB_all));
    end %end roi
    ERS_z=0.5*(log(1+ERS_r)-log(1-ERS_r));
    mem_z=0.5*(log(1+mem_r)-log(1-mem_r));
    ln_z=0.5*(log(1+ln_r)-log(1-ln_r));
end %end sub
    %eval(sprintf('save %s/ERS_sub%02d ERS_r', rdir,s));
    eval(sprintf('save %s/ERS_sub%02d ERS_z', zdir,s));
    %eval(sprintf('save %s/mem_sub%02d mem_r', rdir,s));
    eval(sprintf('save %s/mem_sub%02d mem_z', zdir,s));
    %eval(sprintf('save %s/ln_sub%02d ln_r', rdir,s));
    eval(sprintf('save %s/ln_sub%02d ln_z', zdir,s));

    %eval(sprintf('save %s/nERS_sub%02d nERS', rdir,s));
    %eval(sprintf('save %s/nmem_sub%02d nmem', rdir,s));
    %eval(sprintf('save %s/nln_sub%02d nln', rdir,s));
end %end func
