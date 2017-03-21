function RSA_neural(subs)
%subs=1;
%m=2;
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behav/label'];
datadir=sprintf('%s/data_singletrial/test_py/roi',basedir);
rdir=sprintf('%s/data_singletrial/test_py/r',basedir);
zdir=sprintf('%s/data_singletrial/test_py/z',basedir);
%zdir=sprintf('%s/ROI_based/ref_space/%s/sub_hipp/sub/z',basedir,methodname{m});
%rdir=sprintf('%s/ROI_based/ref_space/%s/sub_hipp/sub/r',basedir,methodname{m});
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

TN=96*2;
%%%%%%%%%
roi_name={'tVVC'};
%roi_name={'LdLOC','LAG','LHIP'};
%roi_name={'CC','VVC','dLOC','IPL','IFG','PHG','HIP'};
%roi_name={'CC','vLOC','OF','TOF','pTF','aTF',...
%'dLOC','ANG','SMG','IFG',...
%'HIP','pPHG','aPHG'}
%roi_name={'CA1','CA2','DG','CA3','subiculum','PRC','ERC','pPHG'};
%roi_name={'CC','VVC','dLOC','ANG','SMG','IFG',...
%        'CA1','CA2','DG','CA3','subiculum','ERC',...        
%	'HIP','pPHG','aPHG',...
%               'aSMG','pSMG'} 
%roi_name={'CC','VVC','dLOC','IPL','SPL','IFG','MFG','HIP','PHG',...
%'vLOC','OF','TOF','pTF','aTF','ANG','SMG','pSMG','aSMG','pPHG','aPHG',...
%'LCC','LVVC','LdLOC','LIPL','LSPL','LIFG','LMFG','LHIP','LPHG',...
%'LvLOC','LOF','LTOF','LpTF','LaTF','LANG','LSMG','LpSMG','LaSMG','LpPHG','LaPHG',...
%'RCC','RVVC','RdLOC','RIPL','RSPL','RIFG','RMFG','RHIP','RPHG',...
%'RvLOC','ROF','RTOF','RpTF','RaTF','RANG','RSMG','RpSMG','RaSMG','RpPHG','RaPHG',...
%'LITG','RITG','LpFUS','RpFUS'};
ERS_r=[]; ERS_z=[]; mem_r=[]; mem_z=[]; ln_r=[]; ln_z=[];
nERS=[]; nmem=[]; nln=[];
cnames={'py_lss','py_tmap','matlab_lss'};
for c=1:3
for s=subs
        %get idx                                              
        [idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem] = get_idx(s);
        %perpare data
        txx=[];xx=[];tmp_xx=[];u=[];
        tmp_xx=load(sprintf('%s/%s_%s.txt',datadir,cnames{c},roi_name{1}));
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
        ERS_r(:,1)=mean(cc(idx_ERS_I));
        ERS_r(:,2)=mean(cc(idx_ERS_IB_wc));
        ERS_r(:,3)=mean(cc(idx_ERS_IB_all));
        ERS_r(:,4)=mean(cc(idx_ERS_D));
        ERS_r(:,5)=mean(cc(idx_ERS_DB_wc));
        ERS_r(:,6)=mean(cc(idx_ERS_DB_all));

        mem_r(:,1)=mean(cc(idx_mem_D));
        mem_r(:,2)=mean(cc(idx_mem_DB_wc));
        mem_r(:,3)=mean(cc(idx_mem_DB_all));

        ln_r(:,1)=mean(cc(idx_ln_D));
        ln_r(:,2)=mean(cc(idx_ln_DB_wc));
        ln_r(:,3)=mean(cc(idx_ln_DB_all));
    ERS_z=0.5*(log(1+ERS_r)-log(1-ERS_r));
    mem_z=0.5*(log(1+mem_r)-log(1-mem_r));
    ln_z=0.5*(log(1+ln_r)-log(1-ln_r));
end %end sub
    eval(sprintf('save %s/ERS_%s ERS_r', rdir,cnames{c}));
    eval(sprintf('save %s/ERS_%s ERS_z', zdir,cnames{c}));
    eval(sprintf('save %s/mem_%s mem_r', rdir,cnames{c}));
    eval(sprintf('save %s/mem_%s mem_z', zdir,cnames{c}));
    eval(sprintf('save %s/ln_%s ln_r', rdir,cnames{c}));
    eval(sprintf('save %s/ln_%s ln_z', zdir,cnames{c}));

    %eval(sprintf('save %s/nERS_sub%02d nERS', rdir,s));
    %eval(sprintf('save %s/nmem_sub%02d nmem', rdir,s));
    %eval(sprintf('save %s/nln_sub%02d nln', rdir,s));
end
end %end func
