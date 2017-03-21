function RSA_neural(subs,ETR,RTR)
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behav/label'];
datadir=sprintf('%s/ROI_based/ref_space/TR/raw',basedir);
zdir=sprintf('%s/ROI_based/ref_space/TR/tVVC/sub/z',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

TN=96*2;
%%%%%%%%%
ERS_r=[]; ERS_z=[]; mem_r=[]; mem_z=[]; ln_r=[]; ln_z=[];
nERS=[]; nmem=[]; nln=[];
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
'mPFC','PCC'};
for s=subs
    %get idx
    [idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,...
    idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,...
    idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem] = get_idx(s);
    %perpare data
    for roi=1:length(roi_name);
        txx=[];xx=[];
        etmp=[];te=[];
        rtmp=[];tr=[];
        u=[];
        etmp=load(sprintf('%s/encoding_sub%02d_%s_%dTR.txt',...
        datadir,s,roi_name{roi},ETR));
        rtmp=load(sprintf('%s/test_sub%02d_%s_%dTR.txt',...
        datadir,s,roi_name{roi},RTR));
        te=etmp(4:end,:);
        tr=rtmp(4:end,:);
        txx=[te;tr];
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
    eval(sprintf('save %s/ERS_sub%02d_E%dR%d ERS_z', zdir,s,ETR,RTR));
    eval(sprintf('save %s/mem_sub%02d_E%dR%d mem_z', zdir,s,ETR,RTR));
    eval(sprintf('save %s/ln_sub%02d_E%dR%d ln_z', zdir,s,ETR,RTR));
end %end func
