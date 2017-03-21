function get_top_information(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
infodir=sprintf('%s/top/tmap/data',basedir);

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
	VVCfile=sprintf('%s/sub%02d_VVC.txt',vvcdir,s);
	tmp_VVC=load(VVCfile);
	IPLfile=sprintf('%s/sub%02d_IPL.txt',vvcdir,s);
	tmp_IPL=load(IPLfile);
	IFGfile=sprintf('%s/sub%02d_IFG.txt',vvcdir,s);
	tmp_IFG=load(IFGfile);
	MFGfile=sprintf('%s/sub%02d_MFG.txt',vvcdir,s);
	tmp_MFG=load(MFGfile);
	PHGfile=sprintf('%s/sub%02d_PHG.txt',vvcdir,s);
	tmp_PHG=load(PHGfile);
	pTFfile=sprintf('%s/sub%02d_pTF.txt',vvcdir,s);
	tmp_pTF=load(pTFfile);
	aTFfile=sprintf('%s/sub%02d_aTF.txt',vvcdir,s);
	tmp_aTF=load(aTFfile);
	dLOCfile=sprintf('%s/sub%02d_dLOC.txt',vvcdir,s);
	tmp_dLOC=load(dLOCfile);

	ttvvc_all=[tmp_VVC(:,1:end) tmp_IPL(:,1:end) tmp_IFG(:,1:end) tmp_MFG(:,1:end) tmp_PHG(:,1:end) tmp_pTF(:,1:end) tmp_aTF(:,1:end) tmp_dLOC(:,1:end)];
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
        for pn=99.5
		for h=1:2
		eval(sprintf('pln=pln%d;',h));
        	ln_pn=prctile(pln,pn);
        	vln=find(pln>=ln_pn);
        	data_vln=ttvvc(:,vln);
        	data_cvln=ttvvc_all(:,vln);
        	file_name=sprintf('%s/p%.1f_ln_sub%02d_h%d.mat',infodir,pn,s,h);
        	eval(sprintf('save %s data_vln',file_name));
        	file_name=sprintf('%s/p%.1f_ln_sub%02d_withc_h%d.mat',infodir,pn,s,h);
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
	for pn=99.5
	        for h=1:2
                eval(sprintf('ppmem=pmem%d',h));
        	mem_pn=prctile(ppmem,pn);
        	vmem=find(ppmem>=mem_pn);
        	data_vmem=ttvvc(:,vmem);          
        	data_cvmem=ttvvc_all(:,vmem);          
        	file_name=sprintf('%s/p%.1f_mem_sub%02d_h%d.mat',infodir,pn,s,h);
        	eval(sprintf('save %s data_vmem',file_name));
        	file_name=sprintf('%s/p%.1f_mem_sub%02d_withc_h%d.mat',infodir,pn,s,h);
        	eval(sprintf('save %s data_cvmem',file_name));
		end %half
	end %n
end%sub
end %function
