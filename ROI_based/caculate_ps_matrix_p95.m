function caculate_mem_ln()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak

datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);

%%%%%%%%%
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
resultdir=sprintf('%s/ROI_based/ps_matrix_all_roi',basedir);
matrixdir=sprintf('%s/me/data/ps_matrix',basedir);
mkdir(resultdir);
roi_name={'CC','vLOC','OF','TOF','pTF','aTF','dLOC',...
        'ANG','SMG','IFG','HIP',...
        'CA1','CA2','DG','CA3','subiculum','ERC',...
                'pPHG','aPHG',...
                'aSMG','pSMG'};
mem_r=[];
ln_r=[];

for s=subs;
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);

        %get encoding materail similarity matrix
        ln_file=sprintf('%s/ln_top95_mps_ln_sub%02d.mat', matrixdir,s);
        load(ln_file); ln=cc_ln_ln;
        mem_file=sprintf('%s/mem_top95_mps_mem_sub%02d.mat', matrixdir,s);
        load(mem_file); mem=cc_mem_mem;
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
                    tl=[tcc_all([1:24],[73:96]);tcc_all([25:48],[49:72])];                                                                                     			
		c_ln_roi=tl(:);                                                                                                                         
                    tm=[tcc_all(96+[1:24],96+[73:96]);tcc_all(96+[25:48],96+[49:72])];                                                                         			
		c_mem_roi=tm(:); 

		tdata_rln_mln=[ln;c_ln_roi'];
                tc_rln_mln=1-pdist(tdata_rln_mln(:,:),'correlation');                                                                                                   
		tdata_rmem_mln=[ln;c_mem_roi'];
                tc_rmem_mln=1-pdist(tdata_rmem_mln(:,:),'correlation');                                                                                                   

		tdata_rln_mmem=[mem;c_ln_roi'];
                tc_rln_mmem=1-pdist(tdata_rln_mmem(:,:),'correlation');                                                                                                   
		tdata_rmem_mmem=[mem;c_mem_roi'];
                tc_rmem_mmem=1-pdist(tdata_rmem_mmem(:,:),'correlation');                                                                                                   

                tln_r(s,roi,1)=s;tln_r(s,roi,2)=roi;
		tln_mln(s,roi)=mean(tc_rln_mln);
		tln_mmem(s,roi)=mean(tc_rln_mmem);
		tmem_mln(s,roi)=mean(tc_rmem_mln);
		tmem_mmem(s,roi)=mean(tc_rmem_mmem);
	end %roi
end %end sub
ln_mln=tln_mln(subs,:);
ln_mmem=tln_mmem(subs,:);
mem_mln=tmem_mln(subs,:);
mem_mmem=tmem_mmem(subs,:);
zln_mln=0.5*(log(1+ln_mln(:))-log(1-ln_mln(:)));
zmem_mln=0.5*(log(1+mem_mln(:))-log(1-mem_mln(:)));
zln_mmem=0.5*(log(1+ln_mmem(:))-log(1-ln_mmem(:)));
zmem_mmem=0.5*(log(1+mem_mmem(:))-log(1-mem_mmem(:)));
ln_sub=tln_r(subs,:,1);ln_roi=tln_r(subs,:,2);
ln_mln=[ln_sub(:) ln_roi(:) zln_mln];
ln_mmem=[ln_sub(:) ln_roi(:) zln_mmem];
mem_mln=[ln_sub(:) ln_roi(:) zmem_mln];
mem_mmem=[ln_sub(:) ln_roi(:) zmem_mmem];
    eval(sprintf('save %s/p95_rln_mln.txt ln_mln -ascii -tabs', resultdir));
    eval(sprintf('save %s/p95_rln_mmem.txt ln_mmem -ascii -tabs', resultdir));
    eval(sprintf('save %s/p95_rmem_mln.txt mem_mln -ascii -tabs', resultdir));
    eval(sprintf('save %s/p95_rmem_mmem.txt mem_mmem -ascii -tabs', resultdir));
end %function
