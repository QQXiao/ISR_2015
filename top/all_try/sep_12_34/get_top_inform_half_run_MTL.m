function get_top_information(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
infodir=sprintf('%s/top/tmap/data/MTL',basedir);

datadir=sprintf('%s/data_singletrial/glm/all',basedir);
vvcdir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
%%%%%%%%%
TN=192;
%subs=setdiff(1:21,2);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
vln_cln=[];vmem_cmem=[];
roi_name={'CA1','CA2','DG','CA3','subiculum','ERC',...        
        'pPHG','aPHG'};
for s=subs
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);
	for roi=1:length(roi_name);
	tpln1=[];tpln2=[];tpmem1=[];tpmem2=[];u=[];
        %get fMRI data
	datafile=sprintf('%s/sub%02d_%s.txt',vvcdir,s,roi_name{roi});
	tmp_data=load(datafile);

	ttdata_all=tmp_data;
	ttdata=ttdata_all(4:end,:);
	size_all=size(ttdata,2);
	for j=1:size_all
	u(j)=sum(ttdata(:,j)==0)/192;
	end
	ttdata(:,find(u>=0.125))=[];
	ttdata_all(:,find(u>=0.125))=[];
    	tdata=(ttdata)';
	zdata=zscore(tdata);
	data=zdata';
	ss=size(data);
	pa=combntns([1:ss(1)],2);

	t_sub_ln=idx_ln_D;
	n1=1;n2=1;
	for n=1:length(t_sub_ln)
	t=pa(t_sub_ln(n),1);
	[tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
		for v=1:ss(2)
		data_voxel=data(:,v);
		datav=data_voxel(:);
		coorv=datav(pa(:,1)).*datav(pa(:,2));
		t_coorv=coorv(tidx_ln_DB_all);
       		 x=sum(coorv(tidx_ln_D)>t_coorv);
			if t<=48
			tpln1(v,n1)=(x)/length(tidx_ln_DB_all);
			else
			tpln2(v,n2)=(x)/length(tidx_ln_DB_all);
			end
		end%voxel
		if t<=48
			n1=n1+1;
		else
			n2=n2+1;
		end
	end%encoding phase
	pln1=mean(tpln1,2);
	pln2=mean(tpln2,2);
        for pn=[60:5:95]
		for h=1:2
		eval(sprintf('pln=pln%d;',h));
        	ln_pn=prctile(pln,pn);
        	vln=find(pln>=ln_pn);
        	data_vln=ttdata(:,vln);
        	data_cvln=ttdata_all(:,vln);
        	file_name=sprintf('%s/p%d_ln_sub%02d_h%d_%s',infodir,pn,s,h,roi_name{roi});
        	eval(sprintf('save %s data_vln',file_name));
        	file_name=sprintf('%s/p%d_ln_sub%02d_withc_h%d_%s',infodir,pn,s,h,roi_name{roi});
        	eval(sprintf('save %s data_cvln',file_name)); 
		end %half
	end %pn
    
    t_sub_mem=idx_mem_D;
	m1=1;m2=1;
    for n=1:length(t_sub_mem)
    t=pa(t_sub_mem(n),1);
    [tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
        for v=1:ss(2)
            data_voxel=data(:,v);
            datav=data_voxel(:);
            coorv=datav(pa(:,1)).*datav(pa(:,2));
            t_coorv=coorv(tidx_mem_DB_all);
            x=sum(coorv(tidx_mem_D)>t_coorv);
                if t<=144
                tpmem1(v,m1)=(x)/length(tidx_mem_DB_all);
                else
                tpmem2(v,m2)=(x)/length(tidx_mem_DB_all);
                end
	end%voxels
	if t<=144
		m1=m1+1;
	else
		m2=m2+1;
	end
    end%retrieval phase
        pmem1=mean(tpmem1,2);
        pmem2=mean(tpmem2,2);
	for pn=[60:5:95]
	        for h=1:2
                eval(sprintf('ppmem=pmem%d',h));
        	mem_pn=prctile(ppmem,pn);
        	vmem=find(ppmem>=mem_pn);
        	data_vmem=ttdata(:,vmem);          
        	data_cvmem=ttdata_all(:,vmem);          
        	file_name=sprintf('%s/p%d_mem_sub%02d_h%d_%s',infodir,pn,s,h,roi_name{roi});
        	eval(sprintf('save %s data_vmem',file_name));
        	file_name=sprintf('%s/p%d_mem_sub%02d_withc_h%d_%s',infodir,pn,s,h,roi_name{roi});
        	eval(sprintf('save %s data_cvmem',file_name));
		end %half
	end %n
end %end roi
end%sub
end %function
