function get_top_information2(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak

datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/merged2',basedir);
vvcdir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);
%%%%%%%%%
TN=192;
%subs=setdiff(1:21,2);
%for c=1:4
resultdir=sprintf('%s/peak/VVC/data/top/coordinate',basedir);
mkdir(resultdir);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
for s=subs;
s
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);

        %get fMRI data
	vvcfile=sprintf('%s/sub%02d_vvc.txt',vvcdir,s);
	tmp_vvc=load(vvcfile);	
	tvvc=tmp_vvc(4:end,1:end-1);
	tvvc=(tvvc)';
	zvvc=zscore(tvvc);
	vvc=zvvc';
	ss=size(vvc);
        pa=combntns([1:ss(1)],2);
	for v=1:ss(2)
	tpln=[];tpmem=[];
	data_voxel=vvc(:,v);
	datav=data_voxel(:);
	coorv=datav(pa(:,1)).*datav(pa(:,2));
		t_sub_ln=idx_ln_D;
		for n=1:length(t_sub_ln)
		t=pa(t_sub_ln(n),1);
		[tidx_mem_D,tidx_mem_DB_wc,tidx_ln_D,tidx_ln_DB_wc]= get_idx_matrix(s,t);
		pt=[tidx_ln_D,tidx_ln_DB_wc];
		t_coorv=coorv(pt);	
		x=sum(coorv(tidx_ln_D)>t_coorv);
		tpln(n)=(x)/length(tidx_ln_DB_wc);
		end
		pln(v)=sum(tpln)/length(t_sub_ln);
		
		t_sub_mem=idx_mem_D;
		for n=1:length(t_sub_mem)
		t=pa(t_sub_mem(n),1);
		[tidx_mem_D,tidx_mem_DB_wc,tidx_ln_D,tidx_ln_DB_wc]= get_idx_matrix(s,t);
                pt=[tidx_mem_D,tidx_mem_DB_wc];
                t_coorv=coorv(pt);                       
		x=sum(coorv(tidx_mem_D)>t_coorv);
		tpmem(n)=(x)/length(tidx_mem_DB_wc);
		end
                pmem(v)=sum(tpmem)/length(t_sub_mem);
	end 
end%sub
        file_name=sprintf('%s/sub%02d_vvc_ln_inform_z.mat', resultdir, s);
        eval(sprintf('save %s pln',file_name));
        file_name=sprintf('%s/sub%02d_vvc_mem_inform_z.mat', resultdir, s);
        eval(sprintf('save %s pmem',file_name));
%end %end c
end %function
