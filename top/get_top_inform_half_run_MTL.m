function get_top_information(subs,r)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
infodir=sprintf('%s/top/tmap/data',basedir);

datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);
roiname={'DG','CA1','CA2','CA3','ERC','subiculumn'}
%%%%%%%%%
TN=192;
%subs=setdiff(1:21,2);
ERS_z=[];mem_z=[];ln_z=[];
vln_cln=[];vmem_cmem=[];
for s=subs
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);

        %get fMRI data
    datafile=sprintf('%s/sub%02d_%s.txt',vvcdir,s,roiname{r});
    tmp_data=load(datafile);

    ttvvc_all=tmp_data;
	ttvvc=ttvvc_all(4:end,:);
	size_all=length(ttvvc);
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
    for h=1:2
    	for nh=1:24
	n=nh+length(t_sub_ln)/2*(h-1);
    	t=pa(t_sub_ln(n),1);
    	[tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
        	for v=1:ss(2)
        	data_voxel=vvc(:,v);
        	datav=data_voxel(:);
        	coorv=datav(pa(:,1)).*datav(pa(:,2));
        	t_coorv=coorv(tidx_ln_DB_all);
        	x=sum(coorv(tidx_ln_D)>t_coorv);
        	tpln(v,nh)=(x)/length(tidx_ln_DB_all);
        	end%voxel
	end %end 48 trials
    pln=sum(tpln,2)/(length(t_sub_ln)/2);
        for n=[60:5:95]
        ln_pn=prctile(pln,n);
        vln=find(pln>=ln_pn);
        data_vln=ttvvc(:,vln);                                                                                                                                
        data_cvln=ttvvc_all(:,vln);                                                                                                                                
        file_name=sprintf('%s/p%d_ln_sub%02d_half%d', infodir,n,s,h);                                                                                                     
        eval(sprintf('save %s data_vln',file_name));
        file_name=sprintf('%s/p%d_ln_sub%02d_withc_half%d', infodir,n,s,h);                                                                                                     
        eval(sprintf('save %s data_cvln',file_name));
        end
    end%encoding phase

    t_sub_mem=idx_mem_D;
    for h=1:2
        for nh=1:24
        n=nh+length(t_sub_ln)/2*(h-1);
    	t=pa(t_sub_mem(n),1);
    	[tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
        	for v=1:ss(2)
            	data_voxel=vvc(:,v);
            	datav=data_voxel(:);
            	coorv=datav(pa(:,1)).*datav(pa(:,2));
            	t_coorv=coorv(tidx_mem_DB_all);
            	x=sum(coorv(tidx_mem_D)>t_coorv);
            	tpmem(v,nh)=(x)/length(tidx_mem_DB_all);
        	end%voxels
	end %end 48 trials
    end%retrieval phase
    pmem=sum(tpmem,2)/(length(t_sub_mem)/2);
	for n=[60:5:95]
        mem_pn=prctile(pmem,n);
        vmem=find(pmem>=mem_pn);
        data_vmem=ttvvc(:,vmem);          
        data_cvmem=ttvvc_all(:,vmem);          
        file_name=sprintf('%s/p%d_mem_sub%02d_half%d_%s', infodir,n,s,h,roiname{r});
        eval(sprintf('save %s data_vmem',file_name));
        file_name=sprintf('%s/p%d_mem_sub%02d_withc_half%d_%s', infodir,n,s,h,roiname{r});
        eval(sprintf('save %s data_cvmem',file_name));
    end%retrieval phase
end%sub
end %function
