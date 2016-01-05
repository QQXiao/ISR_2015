function RSA_neural_z(subs)
%subs=1;
%m=2;
methodname={'LSS','TR34','ms_LSS'};
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behav/label'];
datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);
rdir=sprintf('%s/ROI_based/ref_space/zscore/final/sub/r',basedir);
zdir=sprintf('%s/ROI_based/ref_space/zscore/final/sub/z',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/ISR_2015/behav

TN=96*2;
%%%%%%%%%
roi_name={'VVC','dLOC','IPL','PHG','HIP'};
%roi_name={'CA1','CA2','DG','CA3','subiculum','ERC'};
%roi_name={'CC','VVC','dLOC','ANG','SMG','IFG',...                                                       
%                'HIP','pPHG','aPHG',...
%		'aSMG','pSMG'}                                                                        
%roi_name={'LIFG','RIFG','LIPL','RIPL','LFUS','RFUS','LITG','RITG',...
%            'LdLOC','RdLOC','LvLOC','RvLOC','LMTG','RMTG','LHIP','RHIP',...
%            'LAMG','RAMG','LPHG','RPHG','LaPHG','RaPHG','LpPHG','RpPHG',...
%            'LaSMG','RaSMG','LpSMG','RpSMG','LANG','RANG','LSPL','RSPL',...
%            'LFFA','RFFA',...
%            'PCC','Precuneous','LFOC','LPreCG','RFOC','RPreCG'}; %38 rois in total
ERS_r=[]; ERS_z=[]; mem_r=[]; mem_z=[]; ln_r=[]; ln_z=[];
nERS=[]; nmem=[]; nln=[];
for s=subs
        %get idx                                              
        [idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem] = get_idx(s);        
	%perpare data
	for roi=1:length(roi_name);
        xx=[];tmp_xx=[];
        tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
        xx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
        %data_all=xx;
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
    eval(sprintf('save %s/ERS_sub%02d_ISR ERS_r', rdir,s));
    eval(sprintf('save %s/ERS_sub%02d_ISR ERS_z', zdir,s));
    eval(sprintf('save %s/mem_sub%02d_ISR mem_r', rdir,s));
    eval(sprintf('save %s/mem_sub%02d_ISR mem_z', zdir,s));
    eval(sprintf('save %s/ln_sub%02d_ISR ln_r', rdir,s));
    eval(sprintf('save %s/ln_sub%02d_ISR ln_z', zdir,s));
end %end func
