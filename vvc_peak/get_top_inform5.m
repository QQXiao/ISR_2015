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
    ln_p95=prctile(pln,99);
    vln=find(pln>=ln_p95);
    data_vln=ttvvc(:,vln);
    yy11=data_vln([1:24],:);yy12=data_vln([25:48],:);yy21=data_vln([49:72],:);yy22=data_vln([73:96],:);               
    p_ln_11=m_ln([1:24],:);p_ln_12=m_ln([25:48],:);p_ln_21=m_ln([49:72],:);p_ln_22=m_ln([73:96],:); 
	
    tyy11=[yy11,p_ln_11];a=size(tyy11);ttyy11=sortrows(tyy11,a(2));data_ln_11=ttyy11(:,[1:end-1]);                
    tyy12=[yy12,p_ln_12];a=size(tyy12);ttyy12=sortrows(tyy12,a(2));data_ln_12=ttyy12(:,[1:end-1]);                
    tyy21=[yy21,p_ln_21];a=size(tyy21);ttyy21=sortrows(tyy21,a(2));data_ln_21=ttyy21(:,[1:end-1]);                
    tyy22=[yy22,p_ln_22];a=size(tyy22);ttyy22=sortrows(tyy22,a(2));data_ln_22=ttyy22(:,[1:end-1]);                
    data_ln_all=[data_ln_11;data_ln_12;data_ln_21;data_ln_22]; 
    
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
        mem_p95=prctile(pmem,99);
        vmem=find(pmem>=mem_p95);
        data_vmem=ttvvc(:,vmem);          
	zz11=data_vmem([1:24],:);zz12=data_vmem([25:48],:);zz21=data_vmem([49:72],:);zz22=data_vmem([73:96],:);           
        p_mem_11=m_mem([1:24],:);p_mem_12=m_mem([25:48],:);p_mem_21=m_mem([49:72],:);p_mem_22=m_mem([73:96],:); 
       
	tzz11=[zz11,p_mem_11];a=size(tzz11);ttzz11=sortrows(tzz11,a(2));data_mem_11=ttzz11(:,[1:end-1]);              
        tzz12=[zz12,p_mem_12];a=size(tzz12);ttzz12=sortrows(tzz12,a(2));data_mem_12=ttzz12(:,[1:end-1]);
        tzz21=[zz21,p_mem_21];a=size(tzz21);ttzz21=sortrows(tzz21,a(2));data_mem_21=ttzz21(:,[1:end-1]);              
        tzz22=[zz22,p_mem_22];a=size(tzz22);ttzz22=sortrows(tzz22,a(2));data_mem_22=ttzz22(:,[1:end-1]);              
        data_mem_all=[data_mem_11;data_mem_12;data_mem_21;data_mem_22];
        
	mem_cc_all=1-pdist(data_mem_all(:,:),'correlation');
        mem_tcc_all=squareform(mem_cc_all);
        tm=[mem_tcc_all([1:24],[73:96]);mem_tcc_all([25:48],[49:72])];
        m_p95_mem=tm(:);
end%sub
        file_name=sprintf('%s/p99_matrix_ln_sub%02d', infodir,s);
        eval(sprintf('save %s m_p95_ln',file_name));
        file_name=sprintf('%s/p99_matrix_mem_sub%02d', infodir,s);
        eval(sprintf('save %s m_p95_mem',file_name));
        file_name=sprintf('%s/p99_ln_sub%02d', medir,s);
        eval(sprintf('save %s data_vln',file_name));
        file_name=sprintf('%s/p99_mem_sub%02d', medir,s);
        eval(sprintf('save %s data_vmem',file_name));
end %function
