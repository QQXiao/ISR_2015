function caculate_m_set()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak

datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);

condname={'ERS_IBwc','ERS_DBwc','mem_DBwc','ln_DBwc','ERS_ID'}
%%%%%%%%%
xlength =  112;
ylength =  112;
zlength =  64;
radius=3;
step=1;     % compute accuracy map for every STEP voxels in each dimension                                                                                          eps
epsilon=1e-6;
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
resultdir=sprintf('%s/ROI_based/ps_matrix_all_roi',basedir);
mkdir(resultdir);
%nt=200;

roi_name={'LdLOC','LvLOC',...
		'LCC','LOF','LTOF','LpTF','LaTF',...
		'LIFG','LpSMG','LaSMG','LANG',...
		'LHIP','LpPHG','LaPHG',...
		'RdLOC','RvLOC',...
		'RCC','ROF','RTOF','RpTF','RaTF',...
                'RIFG','RpSMG','RaSMG','RANG',...
                'RHIP','RpPHG','RaPHG'};

mem_r=[];
ln_r=[];

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
                    data_ln_mean=(data_ln_set1+data_ln_set2)/2;

                    tcc_ln_set1=1-pdist(data_ln_set1(:,:),'correlation');
                    tcc_ln_set2=1-pdist(data_ln_set2(:,:),'correlation');
                    tcc_ln_mean=1-pdist(data_ln_mean(:,:),'correlation');
                    
		    zz1=data_mem([1:24 49:72],:);
	            m_mem_1=m_mem([1:24 49:72],:);                                                                                               
        	    tzz1=[zz1,m_mem_1];a=size(tzz1);ttzz1=sortrows(tzz1,a(2));data_mem_set1=ttzz1(:,[1:end-1]);

                    zz2=data_mem([25:48 73:96],:);
		    m_mem_2=m_mem([25:48 73:96],:);                                                                                              
        	    tzz2=[zz2,m_mem_2];a=size(tzz2);ttzz2=sortrows(tzz2,a(2));data_mem_set2=ttzz2(:,[1:end-1]);

                    data_mem_mean=(data_mem_set1+data_mem_set2)/2;
                    
		    tcc_mem_set1=1-pdist(data_mem_set1(:,:),'correlation');
                    tcc_mem_set2=1-pdist(data_mem_set2(:,:),'correlation');
                    tcc_mem_mean=1-pdist(data_mem_mean(:,:),'correlation');

		    cc_ln_set1(s,roi,:)=tcc_ln_set1;
		    cc_ln_set2(s,roi,:)=tcc_ln_set2;
		    cc_ln_mean(s,roi,:)=tcc_ln_mean;
		    cc_mem_set1(s,roi,:)=tcc_mem_set1;
		    cc_mem_set2(s,roi,:)=tcc_mem_set2;
		    cc_mem_mean(s,roi,:)=tcc_mem_mean;
        end %roi
end %end sub
cc_ln_set1=cc_ln_set1(subs,:,:);
cc_ln_set2=cc_ln_set2(subs,:,:);
cc_ln_mean=cc_ln_mean(subs,:,:);
cc_mem_set1=cc_mem_set1(subs,:,:);
cc_mem_set2=cc_mem_set2(subs,:,:);
cc_mem_mean=cc_mem_mean(subs,:,:);
c_ln_set1=squeeze(mean(cc_ln_set1,1));c_ln_set2=squeeze(mean(cc_ln_set2,1));c_ln_mean=squeeze(mean(cc_ln_mean,1)); 
c_mem_set1=squeeze(mean(cc_mem_set1,1));c_mem_set2=squeeze(mean(cc_mem_set2,1));c_mem_mean=squeeze(mean(cc_mem_mean,1));   
eval(sprintf('save %s/all_mem_set1.txt c_mem_set1 -ascii -tabs', resultdir));
eval(sprintf('save %s/all_mem_set2.txt c_mem_set2 -ascii -tabs', resultdir));
eval(sprintf('save %s/all_mem_mean.txt c_mem_mean -ascii -tabs', resultdir));
eval(sprintf('save %s/all_ln_set1.txt c_ln_set1 -ascii -tabs', resultdir));
eval(sprintf('save %s/all_ln_set2.txt c_ln_set2 -ascii -tabs', resultdir));
eval(sprintf('save %s/all_ln_mean.txt c_ln_mean -ascii -tabs', resultdir));
end %function
