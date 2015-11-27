function get_top_information(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak
infodir=sprintf('%s/peak/VVC/data/top/inform',basedir);
medir=sprintf('%s/me/data/roi',basedir);

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
    ANGfile=sprintf('%s/sub%02d_ANG.txt',vvcdir,s);
    tmp_ang=load(ANGfile);
    SMGfile=sprintf('%s/sub%02d_SMG.txt',vvcdir,s);
    tmp_smg=load(SMGfile);
    aPHGfile=sprintf('%s/sub%02d_aPHG.txt',vvcdir,s);
    tmp_aphg=load(aPHGfile);
    pPHGfile=sprintf('%s/sub%02d_pPHG.txt',vvcdir,s);
    tmp_pphg=load(pPHGfile);

    ttvvc_all=[tmp_vvc(:,1:end-1) tmp_ang(:,1:end-1) tmp_smg(:,1:end-1) tmp_aphg(:,1:end-1) tmp_pphg(:,1:end-1)];
	ttvvc=ttvvc_all(4:end,:);
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
        for n=[60:5:95]
        ln_pn=prctile(pln,n);
        vln=find(pln>=ln_pn);
        data_vln=ttvvc(:,vln);                                                                                                                                
        file_name=sprintf('%s/p%d_ln_sub%02d', medir,n,s);                                                                                                     
        eval(sprintf('save %s data_vln',file_name));                                                                                                                                                                
        ln_cc=1-pdist(data_vln(:,:),'correlation');
        ERS_ln(n,1)=mean(ln_cc(idx_ERS_I));
        ERS_ln(n,2)=mean(ln_cc(idx_ERS_IB_wc));
        ERS_ln(n,3)=mean(ln_cc(idx_ERS_IB_all));
        ERS_ln(n,4)=mean(ln_cc(idx_ERS_D));
        ERS_ln(n,5)=mean(ln_cc(idx_ERS_DB_wc));
        ERS_ln(n,6)=mean(ln_cc(idx_ERS_DB_all));

        mem_ln(n,1)=mean(ln_cc(idx_mem_D));
        mem_ln(n,2)=mean(ln_cc(idx_mem_DB_wc));
        mem_ln(n,3)=mean(ln_cc(idx_mem_DB_all));

        ln_ln(n,1)=mean(ln_cc(idx_ln_D));
        ln_ln(n,2)=mean(ln_cc(idx_ln_DB_wc));
        ln_ln(n,3)=mean(ln_cc(idx_ln_DB_all));       
        end

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
	for n=[60:5:95]
        mem_pn=prctile(pmem,n);
        vmem=find(pmem>=mem_pn);
        data_vmem=ttvvc(:,vmem);          
        file_name=sprintf('%s/p%d_mem_sub%02d', medir,n,s);
        eval(sprintf('save %s data_vmem',file_name));
        
	mem_cc=1-pdist(data_vmem(:,:),'correlation');
        ERS_mem(n,1)=mean(mem_cc(idx_ERS_I));
        ERS_mem(n,2)=mean(mem_cc(idx_ERS_IB_wc));
        ERS_mem(n,3)=mean(mem_cc(idx_ERS_IB_all));
        ERS_mem(n,4)=mean(mem_cc(idx_ERS_D));
        ERS_mem(n,5)=mean(mem_cc(idx_ERS_DB_wc));
        ERS_mem(n,6)=mean(mem_cc(idx_ERS_DB_all));

        mem_mem(n,1)=mean(mem_cc(idx_mem_D));
        mem_mem(n,2)=mean(mem_cc(idx_mem_DB_wc));
        mem_mem(n,3)=mean(mem_cc(idx_mem_DB_all));

        ln_mem(n,1)=mean(mem_cc(idx_ln_D));
        ln_mem(n,2)=mean(mem_cc(idx_ln_DB_wc));
        ln_mem(n,3)=mean(mem_cc(idx_ln_DB_all));
	end	
        file_name=sprintf('%s/ERS_ln_sub%02d', medir,s);
        eval(sprintf('save %s ERS_ln',file_name));
        file_name=sprintf('%s/ERS_mem_sub%02d', medir,s);
        eval(sprintf('save %s ERS_mem',file_name));
        file_name=sprintf('%s/mem_ln_sub%02d', medir,s);
        eval(sprintf('save %s mem_ln',file_name));
        file_name=sprintf('%s/mem_mem_sub%02d', medir,s);
        eval(sprintf('save %s mem_mem',file_name));
        file_name=sprintf('%s/ln_ln_sub%02d', medir,s);
        eval(sprintf('save %s ln_ln',file_name));
        file_name=sprintf('%s/ln_mem_sub%02d', medir,s);
        eval(sprintf('save %s ln_mem',file_name));
end%sub
end %function
