function caculate_m_set()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak

datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);
%%%%%%%%%
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
resultdir=sprintf('%s/ROI_based/ps_matrix_all_roi/21rois',basedir);
mkdir(resultdir);
%nt=200;
roi_name={'CC','vLOC','OF','TOF','pTF','aTF','dLOC',...
        'ANG','SMG','IFG','HIP',...
        'CA1','CA2','DG','CA3','subiculum','ERC',...
                'pPHG','aPHG',...
                'aSMG','pSMG'};
for s=subs;
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);

        %get fMRI data
        for roi=1:length(roi_name);
                xx=[];tmp_xx=[];
                tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
                xx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
                %%analysis
        	data_ln=xx(1:96,:);
         	data_mem=xx(97:end,:);
                    yy1=data_ln([1:24 49:72],:);
		    m_ln_1=m_ln([1:24 49:72],:);                                                                                                 
        	    tyy1=[yy1,m_ln_1];a=size(tyy1);ttyy1=sortrows(tyy1,a(2));data_ln_set1=ttyy1(:,[1:end-1]);

                    yy2=data_ln([25:48 73:96],:);
		    m_ln_2=m_ln([25:48 73:96],:);                                                                                                
        	    tyy2=[yy2,m_ln_2];a=size(tyy2);ttyy2=sortrows(tyy2,a(2));data_ln_set2=ttyy2(:,[1:end-1]);
                    data_ln_all=[data_ln_set1;data_ln_set2];

		    zz1=data_mem([1:24 49:72],:);
	            m_mem_1=m_mem([1:24 49:72],:);                                                                                               
        	    tzz1=[zz1,m_mem_1];a=size(tzz1);ttzz1=sortrows(tzz1,a(2));data_mem_set1=ttzz1(:,[1:end-1]);

                    zz2=data_mem([25:48 73:96],:);
		    m_mem_2=m_mem([25:48 73:96],:);                                                                                              
        	    tzz2=[zz2,m_mem_2];a=size(tzz2);ttzz2=sortrows(tzz2,a(2));data_mem_set2=ttzz2(:,[1:end-1]);

                    data_mem_all=[data_mem_set1;data_mem_set2];
                    
		    data_all=[data_ln_all;data_mem_all];
		    cc_all=1-pdist(data_all(:,:),'correlation');
                    tcc_all=squareform(cc_all);

			tl=[tcc_all([1:24],[49:72]);tcc_all([25:48],[73:96])];
		    cc_ln_ln(roi,:)=tl(:);
			tm=[tcc_all(96+[1:24],96+[49:72]);tcc_all(96+[25:48],96+[73:96])];
		    cc_mem_mem(roi,:)=tm(:);
        end %roi
cc_a_roi_ln_ln(s,:)=1-pdist(cc_ln_ln(:,:),'correlation');
cc_a_roi_mem_mem(s,:)=1-pdist(cc_mem_mem(:,:),'correlation');

cor_matrix_all=[cc_ln_ln;cc_mem_mem];
cc_cor_matrix_all=1-pdist(cor_matrix_all(:,:),'correlation');
ttlm=squareform(cc_cor_matrix_all);
%tlm=ttlm([1:28],[29:56]);                                                                                                                             
tlm=ttlm([1:21],[22:42]);                                                                                                                             
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
tc_ln_mem=reshape(mean(cc_a_roi_ln_mem),17,17);
c_ln_mem=0.5*(log(1+tc_ln_mem)-log(1-tc_ln_mem));

eval(sprintf('save %s/a_roi_corr_ln_ln.txt c_ln_ln -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_mem_mem.txt c_mem_mem -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_ln_mem.txt c_ln_mem -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_ln_mem_subs.txt c_ln_mem_subs -ascii -tabs', resultdir));
end %function
