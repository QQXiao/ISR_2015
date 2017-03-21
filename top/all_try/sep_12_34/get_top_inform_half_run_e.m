function get_top_information(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
infodir=sprintf('%s/top/tmap/data/equal/',basedir);

datadir=sprintf('%s/data_singletrial/glm/all',basedir);
vvcdir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
%%%%%%%%%
TN=192;
%subs=setdiff(1:21,2);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
vln_cln=[];vmem_cmem=[];
subs
for s=subs
tpln1=[];tpln2=[];tpmem1=[];tpmem2=[];
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);
	u=[];
        %get fMRI data
	vvcfile=sprintf('%s/sub%02d_vvc.txt',vvcdir,s);
	tmp_vvc=load(vvcfile);
	ANGfile=sprintf('%s/sub%02d_ANG.txt',vvcdir,s);
	tmp_ang=load(ANGfile);
	SMGfile=sprintf('%s/sub%02d_SMG.txt',vvcdir,s);
	tmp_smg=load(SMGfile);
	aPHGfile=sprintf('%s/sub%02d_aPHG.txt',vvcdir,s);
	tmp_aphg=load(aPHGfile);
	pPHGfile=sprintf('%s/sub%02d_pPHG.txt',vvcdir,s);
	tmp_pphg=load(pPHGfile);

	ttvvc_all=[tmp_vvc(:,1:end) tmp_ang(:,1:end) tmp_smg(:,1:end) tmp_aphg(:,1:end) tmp_pphg(:,1:end)];
	ttvvc=ttvvc_all(4:end,:);
	size_all=size(ttvvc,2);
	for j=1:size_all
	u(j)=sum(ttvvc(:,j)==0)/192;
	end
	ttvvc(:,find(u>=0.125))=[];
	ttvvc_all(:,find(u>=0.125))=[];
    	tvvc=(ttvvc)';
	zvvc=zscore(tvvc);
	vvc=zvvc';
	ss=size(vvc);
	pa=combntns([1:ss(1)],2);

	t_sub_ln=idx_ln_D;
	n1=1;n2=1;
	for n=1:length(t_sub_ln)
	t=pa(t_sub_ln(n),1);
	[tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
		for v=1:ss(2)
		data_voxel=vvc(:,v);
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
        for pn=[0:10:50]
		for h=1:2
		eval(sprintf('pln=pln%d;',h));
        	bo_ln_pn=prctile(pln,pn);
        	to_ln_pn=prctile(pln,pn+10);
        	vln=find(pln>=bo_ln_pn & pln<to_ln_pn);
        	data_vln=ttvvc(:,vln);
        	data_cvln=ttvvc_all(:,vln);
        	file_name=sprintf('%s/p%d_ln_sub%02d_h%d',infodir,pn,s,h);
        	eval(sprintf('save %s data_vln',file_name));
        	file_name=sprintf('%s/p%d_ln_sub%02d_withc_h%d',infodir,pn,s,h);
        	eval(sprintf('save %s data_cvln',file_name)); 
		end %half
	end %pn
    
    t_sub_mem=idx_mem_D;
	m1=1;m2=1;
    for n=1:length(t_sub_mem)
    t=pa(t_sub_mem(n),1);
    [tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
        for v=1:ss(2)
            data_voxel=vvc(:,v);
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
	for pn=[0:10:50]
	        for h=1:2
                eval(sprintf('ppmem=pmem%d',h));
        	bo_mem_pn=prctile(ppmem,pn);
        	to_mem_pn=prctile(ppmem,pn+10);
        	vmem=find(ppmem>=bo_mem_pn & ppmem<to_mem_pn);
        	data_vmem=ttvvc(:,vmem);          
        	data_cvmem=ttvvc_all(:,vmem);          
        	file_name=sprintf('%s/p%d_mem_sub%02d_h%d',infodir,pn,s,h);
        	eval(sprintf('save %s data_vmem',file_name));
        	file_name=sprintf('%s/p%d_mem_sub%02d_withc_h%d',infodir,pn,s,h);
        	eval(sprintf('save %s data_cvmem',file_name));
		end %half
	end %n
end%sub
end %function
