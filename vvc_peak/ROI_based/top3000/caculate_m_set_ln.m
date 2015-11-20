function caculate_mem_ln(c,nt)
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
resultdir=sprintf('%s/peak/VVC/data/top/ps/ROI_based/%s/set',basedir,condname{c});
lndir=sprintf('%s/peak/VVC/data/top/ps/set/%s',basedir,condname{c});
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

        %get encoding materail similarity matrix
        ln_file1=sprintf('%s/Mrln_%d_sub%02d_set1.mat', lndir,nt,s);                                                       
        load(ln_file1); ln_set1=ln_tcc1;                                                                                   
        ln_file2=sprintf('%s/Mrln_%d_sub%02d_set2.mat', lndir,nt,s);                                                       
        load(ln_file2); ln_set2=ln_tcc2;        
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

                    tcc_ln_set1=1-pdist(data_ln_set1(:,:),'correlation');
                    tcc_ln_set2=1-pdist(data_ln_set2(:,:),'correlation');
                    
		    zz1=data_mem([1:24 49:72],:);
	            m_mem_1=m_mem([1:24 49:72],:);                                                                                               
        	    tzz1=[zz1,m_mem_1];a=size(tzz1);ttzz1=sortrows(tzz1,a(2));data_mem_set1=ttzz1(:,[1:end-1]);

                    zz2=data_mem([25:48 73:96],:);
		    m_mem_2=m_mem([25:48 73:96],:);                                                                                              
        	    tzz2=[zz2,m_mem_2];a=size(tzz2);ttzz2=sortrows(tzz2,a(2));data_mem_set2=ttzz2(:,[1:end-1]);

                    tcc_mem_set1=1-pdist(data_mem_set1(:,:),'correlation');
                    tcc_mem_set2=1-pdist(data_mem_set2(:,:),'correlation');

                    for set=1:2; %
                    cc_encoding_ln_same(s)=eval(sprintf('1-pdist([ln_set%d;tcc_ln_set%d],''correlation'')',set,set));
                    cc_encoding_mem_same(s)=eval(sprintf('1-pdist([ln_set%d;tcc_mem_set%d],''correlation'')',set,set));
                    cc_encoding_ln_diff(s)=eval(sprintf('1-pdist([ln_set%d;tcc_ln_set%d],''correlation'')',set,3-set));
                    cc_encoding_mem_diff(s)=eval(sprintf('1-pdist([ln_set%d;tcc_mem_set%d],''correlation'')',set,3-set));
                    end
		tln_r_same(s,roi,1)=s;tln_r_same(s,roi,2)=roi;tln_r_same(s,roi,3)=mean(cc_encoding_ln_same);
		tln_r_diff(s,roi,1)=s;tln_r_diff(s,roi,2)=roi;tln_r_diff(s,roi,3)=mean(cc_encoding_ln_diff);
		tmem_r_same(s,roi,1)=s;tmem_r_same(s,roi,2)=roi;tmem_r_same(s,roi,3)=mean(cc_encoding_mem_same);
		tmem_r_diff(s,roi,1)=s;tmem_r_diff(s,roi,2)=roi;tmem_r_diff(s,roi,3)=mean(cc_encoding_mem_diff);
        end %roi
end %end sub
ln_sub=tln_r_same(:,:,1);ln_roi=tln_r_same(:,:,2);ln_rsa_same=tln_r_same(:,:,3);ln_rsa_diff=tln_r_diff(:,:,3);
ln_r_same=[ln_sub(:) ln_roi(:) ln_rsa_same(:)];
ln_r_diff=[ln_sub(:) ln_roi(:) ln_rsa_diff(:)];
mem_sub=tmem_r_same(:,:,1);mem_roi=tmem_r_same(:,:,2);mem_rsa_same=tmem_r_same(:,:,3);mem_rsa_diff=tmem_r_diff(:,:,3);
mem_r_same=[mem_sub(:) mem_roi(:) mem_rsa_same(:)];
mem_r_diff=[mem_sub(:) mem_roi(:) mem_rsa_diff(:)];

ln_r_same(ln_r_same(:,1)==0,:)=[];mem_r_same(mem_r_same(:,1)==0,:)=[];
ln_r_diff(ln_r_diff(:,1)==0,:)=[];mem_r_diff(mem_r_diff(:,1)==0,:)=[];
    tmem_z_same=0.5*(log(1+mem_r_same(:,3))-log(1-mem_r_same(:,3)));
    tln_z_same=0.5*(log(1+ln_r_same(:,3))-log(1-ln_r_same(:,3)));
    tmem_z_diff=0.5*(log(1+mem_r_diff(:,3))-log(1-mem_r_diff(:,3)));
    tln_z_diff=0.5*(log(1+ln_r_diff(:,3))-log(1-ln_r_diff(:,3)));
mem_z_same=[mem_r_same(:,1:2) tmem_z_same];mem_z_diff=[mem_r_diff(:,1:2) tmem_z_diff];
ln_z_same=[ln_r_same(:,1:2) tln_z_same];ln_z_diff=[ln_r_diff(:,1:2) tln_z_diff];
    eval(sprintf('save %s/mem_same_%d.txt mem_z_same -ascii -tabs', resultdir,nt));
    eval(sprintf('save %s/ln_same_%d.txt ln_z_same -ascii -tabs', resultdir,nt));
    eval(sprintf('save %s/mem_diff_%d.txt mem_z_diff -ascii -tabs', resultdir,nt));
    eval(sprintf('save %s/ln_diff_%d.txt ln_z_diff -ascii -tabs', resultdir,nt));
end %function
