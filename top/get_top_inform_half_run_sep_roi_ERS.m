function get_top_information(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
infodir=sprintf('%s/top/tmap/data/number_based/new_vvc_sep_roi',basedir);

datadir=sprintf('%s/data_singletrial/glm/all',basedir);
vvcdir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
%%%%%%%%%
TN=192;
%subs=setdiff(1:21,2);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
vln_cln=[];vmem_cmem=[];
subs
roi_name={'VVC','FPC'};
for s=subs
tpln1=[];tpln2=[];tpmem1=[];tpmem2=[];
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);
		VVCfile=sprintf('%s/sub%02d_tVVC.txt',vvcdir,s);
		tmp_VVC=load(VVCfile);
		IPLfile=sprintf('%s/sub%02d_IPL.txt',vvcdir,s);
		tmp_IPL=load(IPLfile);
		IFGfile=sprintf('%s/sub%02d_IFG.txt',vvcdir,s);
		tmp_IFG=load(IFGfile);
		MFGfile=sprintf('%s/sub%02d_MFG.txt',vvcdir,s);
		tmp_MFG=load(MFGfile);
	for roi=1:length(roi_name);
	u=[];
		%get fMRI data
		if roi==1
			ttvvc_all=[tmp_VVC(:,1:end)];
		else
			ttvvc_all=[tmp_IPL(:,1:end) tmp_IFG(:,1:end) tmp_MFG(:,1:end)];
		end
	ttvvc=ttvvc_all(4:end,:);
	size_all=size(ttvvc,2);
	for j=1:size_all
                a=ttvvc(:,j);
                ta=a';
                b = diff([0 a'==0 0]);
                res = find(b==-1) - find(b==1);
                u(j)=sum(res>=6);
        end
	ttvvc(:,find(u>=1))=[];
	ttvvc_all(:,find(u>=1))=[];
    	tvvc=(ttvvc)';
	zvvc=zscore(tvvc);
	vvc=zvvc';
	ss=size(vvc);
	pa=combntns([1:ss(1)],2);

	t_sub_ln=idx_ERS_I;
	n1=1;n2=1;
	for n=1:length(t_sub_ln)
	t=pa(t_sub_ln(n),1);
	[tidx_ERS_I,tidx_ERS_IB_all,tidx_ERS_IB_wc,tidx_ERS_D,tidx_ERS_DB_all,tidx_ERS_DB_wc,list_pid]=get_idx_item_ERS(s,t)		
		for v=1:ss(2)
		data_voxel=vvc(:,v);
		datav=data_voxel(:);
		coorv=datav(pa(:,1)).*datav(pa(:,2));
		t_coorv=coorv(tidx_ERS_IB_all);
       		 x=sum(coorv(tidx_ERS_I)>t_coorv);
			if t<=48
			tpln1(v,n1)=(x)/length(tidx_ERS_IB_all);
			else
			tpln2(v,n2)=(x)/length(tidx_ERS_IB_all);
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
        %for pn=[99.1 99.2 99.3 99.4 99.5]
        for pn=[0:5:95 96:1:99 99.1 99.2 99.3 99.4 99.5 99.6 99.7 99.8 99.9]
		for h=1:2
		eval(sprintf('pln=pln%d;',h));
        	ln_pn=prctile(pln,pn);
		vln=find(pln>=ln_pn);
        	data_vln=ttvvc(:,vln);
        	data_cvln=ttvvc_all(:,vln);
        	file_name=sprintf('%s/%s_p%.1f_ERSI_sub%02d_h%d.mat',infodir,roi_name{roi},pn,s,h);
        	eval(sprintf('save %s data_vln',file_name));
        	file_name=sprintf('%s/%s_p%.1f_ERSI_sub%02d_withc_h%d.mat',infodir,roi_name{roi},pn,s,h);
        	eval(sprintf('save %s data_cvln',file_name)); 
		end %half
	end %pn
    
    t_sub_mem=idx_ERS_D;
	m1=1;m2=1;
    for n=1:length(t_sub_mem)
    t=pa(t_sub_mem(n),1);
    [tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
        for v=1:ss(2)
            data_voxel=vvc(:,v);
            datav=data_voxel(:);
            coorv=datav(pa(:,1)).*datav(pa(:,2));
            t_coorv=coorv(tidx_ERS_DB_all);
            x=sum(coorv(tidx_ERS_D)>t_coorv);
                if t<=144
                tpmem1(v,m1)=(x)/length(tidx_ERS_DB_all);
                else
                tpmem2(v,m2)=(x)/length(tidx_ERS_DB_all);
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
	for pn=[0:5:95 96:1:99 99.1 99.2 99.3 99.4 99.5 99.6 99.7 99.8 99.9]
	%for pn=[0:5:95 96:1:99]
	        for h=1:2
                eval(sprintf('ppmem=pmem%d',h));
        	mem_pn=prctile(ppmem,pn);
        	vmem=find(ppmem>=mem_pn);
        	data_vmem=ttvvc(:,vmem);          
        	data_cvmem=ttvvc_all(:,vmem);          
        	file_name=sprintf('%s/%s_p%.1f_ERSD_sub%02d_h%d.mat',infodir,roi_name{roi},pn,s,h);
        	eval(sprintf('save %s data_vmem',file_name));
        	file_name=sprintf('%s/%s_p%.1f_ERS_sub%02d_withc_h%d.mat',infodir,roi_name{roi},pn,s,h);
        	eval(sprintf('save %s data_cvmem',file_name));
		end %half
	end %n
	end %roi
end%sub
end %function
