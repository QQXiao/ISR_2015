function caculate_mem_ln(c,nt)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak

datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);

condname={'ERS_IBwc','ERS_DBwc','mem_DBwc','ln_DBwc'}
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
resultdir=sprintf('%s/peak/VVC/data/top/ps/ROI_based/%s/mean_rep',basedir,condname{c});
lndir=sprintf('%s/peak/VVC/data/top/ps/set/%s',basedir,condname{c});
mkdir(resultdir);
%nt=200;
roi_name={'LdLOC','LvLOC',...
                'LCC','LOF','LTOF','LpTF','LaTF',...
                'LIFG','LpSMG','LaSMG','LANG',...             
                'LpPHG','LaPHG',...                           
                'RdLOC','RvLOC',...
                'RCC','ROF','RTOF','RpTF','RaTF',...
                'RIFG','RpSMG','RaSMG','RANG',...             
                'RpPHG','RaPHG'}; 

mem_r=[];
ln_r=[];

for s=subs;
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);

        %get encoding materail similarity matrix
        ln_file=sprintf('%s/Mrln_%d_sub%02d_mean.mat', lndir,nt,s);
        load(ln_file); ln=ln_tcc;                                                                                   
	%get fMRI data
	for roi=1:length(roi_name);
        	xx=[];tmp_xx=[];
        	tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
        	xx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
		%%analysis
        	data_ln=xx(1:96,:);
         	data_mem=xx(97:end,:);
                    yy1=data_ln([1:24 49:72],:);
                    m_ln_1=m_ln([1:24 49:72],:);                                                                                                          tyy1=[yy1,m_ln_1];a=size(tyy1);ttyy1=sortrows(tyy1,a(2));data_ln_set1=ttyy1(:,[1:end-1]);                                                      
    		
		    yy2=data_ln([25:48 73:96],:);
                    m_ln_2=m_ln([25:48 73:96],:);                                                                                                         tyy2=[yy2,m_ln_2];a=size(tyy2);ttyy2=sortrows(tyy2,a(2));data_ln_set2=ttyy2(:,[1:end-1]);                                                      
		    data_ln=(data_ln_set1+data_ln_set2)/2;
		    tcc_ln=1-pdist(data_ln(:,:),'correlation');
                    
			zz1=data_mem([1:24 49:72],:);
			m_mem_1=m_mem([1:24 49:72],:);                                                                                                        tzz1=[zz1,m_mem_1];a=size(tzz1);ttzz1=sortrows(tzz1,a(2));data_mem_set1=ttzz1(:,[1:end-1]);                                                    
			zz2=data_mem([25:48 73:96],:);
                    	m_mem_2=m_mem([25:48 73:96],:);                                                                                                       tzz2=[zz2,m_mem_2];a=size(tzz2);ttzz2=sortrows(tzz2,a(2));data_mem_set2=ttzz2(:,[1:end-1]);                                                    
                    	data_mem=(data_mem_set1+data_mem_set2)/2;
			tcc_mem=1-pdist(data_mem(:,:),'correlation');

                    cc_encoding_ln=1-pdist([ln;tcc_ln],'correlation');
                    cc_encoding_mem=1-pdist([ln;tcc_mem],'correlation');

                tln_r(s,roi,1)=s;tln_r(s,roi,2)=roi;tln_r(s,roi,3)=mean(cc_encoding_ln);
                tmem_r(s,roi,1)=s;tmem_r(s,roi,2)=roi;tmem_r(s,roi,3)=mean(cc_encoding_mem);
	end %roi
end %end sub
ln_sub=tln_r(:,:,1);ln_roi=tln_r(:,:,2);ln_rsa=tln_r(:,:,3);
ln_r=[ln_sub(:) ln_roi(:) ln_rsa(:)];
mem_sub=tmem_r(:,:,1);mem_roi=tmem_r(:,:,2);mem_rsa=tmem_r(:,:,3);
mem_r=[mem_sub(:) mem_roi(:) mem_rsa(:)];
ln_r(ln_r(:,1)==0,:)=[];mem_r(mem_r(:,1)==0,:)=[];
mem_z=[];ln_z=[];
    tmem_z=0.5*(log(1+mem_r(:,3))-log(1-mem_r(:,3)));
    tln_z=0.5*(log(1+ln_r(:,3))-log(1-ln_r(:,3)));
mem_z=[mem_r(:,1:2) tmem_z];
ln_z=[ln_r(:,1:2) tln_z];
    eval(sprintf('save %s/mem_%d.txt mem_z -ascii -tabs', resultdir,nt));
    eval(sprintf('save %s/ln_%d.txt ln_z -ascii -tabs', resultdir,nt));
end %function
