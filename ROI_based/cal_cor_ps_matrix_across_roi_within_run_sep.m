function caculate_m_set()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

datadir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
%datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);
%%%%%%%%%
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
resultdir=sprintf('%s/ROI_based/ps_matrix_all_roi/glm/6rois',basedir);
%resultdir=sprintf('%s/ROI_based/ps_matrix_all_roi/glm/21rois',basedir);
mkdir(resultdir);
%nt=200;
roi_name={'VVC','dLOC','IPL','IFG','HIP','PHG'};
%roi_name={'CC','vLOC','OF','TOF','pTF','aTF','dLOC',...
%        'ANG','SMG','IFG','HIP',...
%        'CA1','CA2','DG','CA3','subiculum','ERC',...
%                'pPHG','aPHG',...
%                'aSMG','pSMG'};
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
                    tcc_all=squareform(cc_all);

			tl1=tcc_all([1:24],[25:48])
			ttl1=tl1(:);
			for i=1:24
			de(i)=i+24*(i-1);
			end
			ttl1(de)=[];
			tl2=tcc_all([49:72],[73:96]);
			ttl2=tl2(:);
                        for i=1:24
                        de(i)=i+24*(i-1);
                        end
                        ttl2(de)=[];
                    	cc_ln_ln1(roi,:)=tl1(:);cc_ln_ln2(roi,:)=tl2(:);
			tm1=tcc_all(96+[1:24],96+[25:48]);
                        ttm1=tm1(:);
                        for i=1:24
                        de(i)=i+24*(i-1);
                        end
                        ttm1(de)=[];	
			tm2=tcc_all(96+[49:72],96+[73:96]);
                        ttm2=tm2(:);
                        for i=1:24
                        de(i)=i+24*(i-1);
                        end
                        ttm2(de)=[];		    	
                        cc_mem_mem1(roi,:)=tm1(:);cc_mem_mem2(roi,:)=tm2(:);
	end %roi
cc_a_roi_ln_ln1(s,:)=1-pdist(cc_ln_ln1(:,:),'correlation');
cc_a_roi_ln_ln2(s,:)=1-pdist(cc_ln_ln2(:,:),'correlation');
cc_a_roi_mem_mem1(s,:)=1-pdist(cc_mem_mem1(:,:),'correlation');
cc_a_roi_mem_mem2(s,:)=1-pdist(cc_mem_mem2(:,:),'correlation');

cor_matrix_all1=[cc_ln_ln1;cc_mem_mem1];
cor_matrix_all2=[cc_ln_ln2;cc_mem_mem2];
cc_cor_matrix_all1=1-pdist(cor_matrix_all1(:,:),'correlation');
cc_cor_matrix_all2=1-pdist(cor_matrix_all2(:,:),'correlation');
ttlm1=squareform(cc_cor_matrix_all1);
ttlm2=squareform(cc_cor_matrix_all2);
tlm1=ttlm1([1:6],[7:12]);
%tlm1=ttlm1([1:21],[22:42]);
tlm2=ttlm2([1:6],[7:12]);
%tlm2=ttlm2([1:21],[22:42]);
cc_a_roi_ln_mem1(s,:)=tlm1(:);
cc_a_roi_ln_mem2(s,:)=tlm2(:);
end %end sub
cc_a_roi_ln_ln1=cc_a_roi_ln_ln1(subs,:,:);
cc_a_roi_ln_ln2=cc_a_roi_ln_ln2(subs,:,:);
cc_a_roi_mem_mem1=cc_a_roi_mem_mem1(subs,:,:);
cc_a_roi_mem_mem2=cc_a_roi_mem_mem2(subs,:,:);
cc_a_roi_ln_mem1=cc_a_roi_ln_mem1(subs,:,:);
cc_a_roi_ln_mem2=cc_a_roi_ln_mem2(subs,:,:);
c_ln_mem_subs1=0.5*(log(1+cc_a_roi_ln_mem1)-log(1-cc_a_roi_ln_mem1));
c_ln_mem_subs2=0.5*(log(1+cc_a_roi_ln_mem2)-log(1-cc_a_roi_ln_mem2));
c_ln_ln1=squareform(squeeze(mean(cc_a_roi_ln_ln1,1)));
c_ln_ln2=squareform(squeeze(mean(cc_a_roi_ln_ln2,1)));
c_mem_mem1=squareform(squeeze(mean(cc_a_roi_mem_mem1,1)));
c_mem_mem2=squareform(squeeze(mean(cc_a_roi_mem_mem2,1)));
%c_ln_ln=0.5*(log(1+tc_ln_ln)-log(1-tc_ln_ln));
%c_mem_mem=0.5*(log(1+tc_mem_mem)-log(1-tc_mem_mem));
tc_ln_mem1=reshape(mean(cc_a_roi_ln_mem1),6,6);
c_ln_mem1=0.5*(log(1+tc_ln_mem1)-log(1-tc_ln_mem1));
tc_ln_mem2=reshape(mean(cc_a_roi_ln_mem2),6,6);
c_ln_mem2=0.5*(log(1+tc_ln_mem2)-log(1-tc_ln_mem2));
eval(sprintf('save %s/a_roi_corr_ln_ln1.txt c_ln_ln1 -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_mem_mem1.txt c_mem_mem1 -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_ln_mem1.txt c_ln_mem1 -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_ln_mem_subs1.txt c_ln_mem_subs1 -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_ln_ln2.txt c_ln_ln2 -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_mem_mem2.txt c_mem_mem2 -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_ln_mem2.txt c_ln_mem2 -ascii -tabs', resultdir));
eval(sprintf('save %s/a_roi_corr_ln_mem_subs2.txt c_ln_mem_subs2 -ascii -tabs', resultdir));
end %function                                         

