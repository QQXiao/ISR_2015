function caculate_mem_ln()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak

datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);

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
resultdir=sprintf('%s/peak/VVC/data/top/ps/ROI_based/inform/ln',basedir);
matrixdir=sprintf('%s/peak/VVC/data/top/inform',basedir);
mkdir(resultdir);
%nt=200;
roi_name={'CC','VVC','dLOC','ANG','SMG','IFG',...                                                       
                'HIP','pPHG','aPHG',...
                'aSMG','pSMG'}

mem_r=[];
ln_r=[];

for s=subs;
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);

        %get encoding materail similarity matrix
        ln_file=sprintf('%s/p95_matrix_ln_sub%02d.mat', matrixdir,s);
        load(ln_file); ln=m_p95_ln;
        mem_file=sprintf('%s/p95_matrix_mem_sub%02d.mat', matrixdir,s);
        load(mem_file); mem=m_p95_mem;
                                                                                   
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
                    data_all=[data_ln_all;data_mem_all];                                                                                                           
                    cc_all=1-pdist(data_all(:,:),'correlation');                                                                                                   
                    tcc_all=squareform(cc_all);                                                                                                                    
                                                                                                                                                                   
                    tl=[tcc_all([1:24],[73:96]);tcc_all([25:48],[49:72])];                                                                                     
                    c_ln_roi=tl(:);                                                                                                                         
                    tm=[tcc_all(96+[1:24],96+[73:96]);tcc_all(96+[25:48],96+[49:72])];                                                                         
                    c_mem_roi=tm(:); 

		tdata_rln_mln=[ln;c_ln_roi];
                tc_rln_mln=1-pdist(tdata_rln_mln(:,:),'correlation');                                                                                                   
		tdata_rmem_mln=[ln;c_mem_roi];
                tc_rmem_mln=1-pdist(tdata_rmem_mln(:,:),'correlation');                                                                                                   

		tdata_rln_mmem=[mem;c_ln_roi];
                tc_rln_mmem=1-pdist(tdata_rln_mmem(:,:),'correlation');                                                                                                   
		tdata_rmem_mmem=[mem;c_mem_roi];
                tc_rmem_mmem=1-pdist(tdata_rmem_mmem(:,:),'correlation');                                                                                                   

                tln_r(s,roi,1)=s;tln_r(s,roi,2)=roi;
		tln_mln(s,roi)=mean(tc_rln_mln);
		tln_mmem(s,roi)=mean(tc_rln_mmem);
		tmem_mln(s,roi)=mean(tc_rmem_mln);
		tmem_mmem(s,roi)=mean(tc_rmem_mmem);
	end %roi
end %end sub
zln_mln=0.5*(log(1+tln_mln(:))-log(1-tln_mln(:)));
zmem_mln=0.5*(log(1+tmem_mln(:))-log(1-tmem_mln(:)));
zln_mmem=0.5*(log(1+tln_mmem(:))-log(1-tln_mmem(:)));
zmem_mmem=0.5*(log(1+tmem_mmem(:))-log(1-tmem_mmem(:)));
ln_sub=tln_r(subs,:,1);ln_roi=tln_r(subs,:,2);
ln_mln=[ln_sub(:) ln_roi(:) zln_mln];
ln_mmem=[ln_sub(:) ln_roi(:) zln_mln];
mem_mln=[ln_sub(:) ln_roi(:) zmem_mln];
mem_mmem=[ln_sub(:) ln_roi(:) zmem_mln];
    eval(sprintf('save %s/rln_mln.txt ln_mln -ascii -tabs', resultdir));
    eval(sprintf('save %s/rln_mmem.txt ln_mmem -ascii -tabs', resultdir));
    eval(sprintf('save %s/rmem_mln.txt mem_mln -ascii -tabs', resultdir));
    eval(sprintf('save %s/rmem_mmem.txt mem_mmem -ascii -tabs', resultdir));
end %function
