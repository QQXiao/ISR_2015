function get_top_information(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak
infodir=sprintf('%s/peak/VVC/data/top/inform',basedir);

datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/merged',basedir);
vvcdir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);
%%%%%%%%%
TN=192;
%subs=setdiff(1:21,2);
resultdir=sprintf('%s/peak/VVC/data/top/coordinate',basedir);
mkdir(resultdir);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
vln_cln=[];vmem_cmem=[];
for s=subs
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);

        %get fMRI data
	vvcfile=sprintf('%s/sub%02d_vvc.txt',vvcdir,s);
	tmp_vvc=load(vvcfile);	
	ttvvc=tmp_vvc(4:end,1:end-1);
        tvvc=(ttvvc)';
        zvvc=zscore(tvvc);
        vvc=zvvc';	
	ss=size(vvc);
        pa=combntns([1:ss(1)],2);
	
	t_sub_ln=idx_ln_D;
	for n=1:length(t_sub_ln)
	t=pa(t_sub_ln(n),1);
	[tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
		for v=1:ss(2)
        	data_voxel=vvc(:,v);
       		datav=data_voxel(:);
        	coorv=datav(pa(:,1)).*datav(pa(:,2));
		t_coorv=coorv(tidx_ln_DB_all);	
		x=sum(coorv(tidx_ln_D)>t_coorv);
		tpln(v,n)=(x)/length(tidx_ln_DB_all);
		end%voxel
	end%encoding phase	
	pln=sum(tpln,2)/length(t_sub_ln);
        ln_p95=prctile(pln,95);
	vln=find(pln>=ln_p95);
	data_vln=ttvvc(:,vln);
        %tcc_ln=1-pdist(data_vln(:,:),'correlation');
	%vln_cln(1)=mean(tcc_ln(idx_ln_D))；
	%vln_cln(2)=mean(tcc_ln(idx_ln_DBwc))；
        yy1=data_vln([1:24 49:72],:);
        m_ln_1=m_ln([1:24 49:72],:);
        tyy1=[yy1,m_ln_1];a=size(tyy1);ttyy1=sortrows(tyy1,a(2));data_ln_set1=ttyy1(:,[1:end-1]);
        ln_tcc1=1-pdist(data_ln_set1(:,:),'correlation');
        ln_cc1=0.5*(log(1+ln_tcc1)-log(1-ln_tcc1));
        yy2=data_vln([25:48 73:96],:);
        m_ln_2=m_ln([25:48 73:96],:);
        tyy2=[yy2,m_ln_2];a=size(tyy2);ttyy2=sortrows(tyy2,a(2));data_ln_set2=ttyy2(:,[1:end-1]);
	
	data_ln_all=[data_ln_set1;data_ln_set2];
        ln_cc_all=1-pdist(data_ln_all(:,:),'correlation');
        ln_tcc_all=squareform(ln_cc_all);
	tl=[ln_tcc_all([1:24],[73:96]);ln_tcc_all([25:48],[49:72])];
	m_p95_ln=tl(:);

	t_sub_mem=idx_mem_D;
	for n=1:length(t_sub_mem)
	t=pa(t_sub_mem(n),1);
	[tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
		for v=1:ss(2)
        	data_voxel=vvc(:,v);
       		datav=data_voxel(:);
        	coorv=datav(pa(:,1)).*datav(pa(:,2));
                t_coorv=coorv(tidx_mem_DB_all);                       
		x=sum(coorv(tidx_mem_D)>t_coorv);
		tpmem(v,n)=(x)/length(tidx_mem_DB_all);
		end%voxels
	end%retrieval phase  
        pmem=sum(tpmem,2)/length(t_sub_mem);
        mem_p95=prctile(pmem,95);
	vmem=find(pmem>=mem_p95);
        data_vmem=ttvvc(:,vmem);
        %tcc_mem=1-pdist(data_vmem(:,:),'correlation');
        %vmem_cmem(1)=mean(tcc_mem(idx_mem_D))；  
        %vmem_cmem(2)=mean(tcc_mem(idx_mem_DBwc))；
        zz1=data_vmem([1:24 49:72],:);                                                                                     
        m_mem_1=m_mem([1:24 49:72],:);                                                                              
        tzz1=[zz1,m_mem_1];a=size(tzz1);ttzz1=sortrows(tzz1,a(2));data_mem_set1=ttzz1(:,[1:end-1]);                 
        zz2=data_vmem([25:48 73:96],:);                                                                                    
        m_mem_2=m_mem([25:48 73:96],:);                                                                             
        tzz2=[zz2,m_mem_2];a=size(tzz2);ttzz2=sortrows(tzz2,a(2));data_mem_set2=ttzz2(:,[1:end-1]);                 

        data_mem_all=[data_mem_set1;data_mem_set2];
        mem_cc_all=1-pdist(data_mem_all(:,:),'correlation');
        mem_tcc_all=squareform(mem_cc_all);
        tm=[mem_tcc_all([1:24],[73:96]);mem_tcc_all([25:48],[49:72])];
        m_p95_mem=tm(:);
end%sub
        file_name=sprintf('%s/p95_mattix_ln_sub%02d', infodir,s);
        eval(sprintf('save %s m_p95_ln',file_name));
        file_name=sprintf('%s/p95_matrix_mem_sub%02d', infodir,s);
        eval(sprintf('save %s m_p95_mem',file_name));
end %function
