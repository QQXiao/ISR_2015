function caculate_ps_half_run(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
datadir=sprintf('%s/top/tmap/data/value_based/sep_roi',basedir);
resultdir=sprintf('%s/top/tmap/ps/value_based/sep_roi',basedir);
%%%%%%%%%
roi_name={'VVC','FPC'};
for s=subs
	for roi=1:2
	for hd=1:2
		for hr=1:2	
		[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx_sep_12_34(s,hr);
		tn=[0:5:95 96:1:99];
		for n=1:length(tn)
		nn=tn(n);
		ln_file=sprintf('%s/%s_p%d_ln_sub%02d_h%d',datadir,roi_name{roi},nn,s,hd);
		mem_file=sprintf('%s/%s_p%d_mem_sub%02d_h%d',datadir,roi_name{roi},nn,s,hd);
		load(ln_file);load(mem_file);
		%item-specific information sensitive voxels from encoding phase
		half_data_vln=data_vln([1:48 97:144]+48*(hr-1),:);
        	tln_cc=1-pdist(half_data_vln(:,:),'correlation');
		ln_cc=0.5*(log(1+tln_cc)-log(1-tln_cc));
        	
		ERS_ln(n,1)=mean(ln_cc(idx_ERS_I));
        	ERS_ln(n,2)=mean(ln_cc(idx_ERS_IB_wc));
        	ERS_ln(n,3)=mean(ln_cc(idx_ERS_IB_all));
        	ERS_ln(n,4)=mean(ln_cc(idx_ERS_D));
        	ERS_ln(n,5)=mean(ln_cc(idx_ERS_DB_wc));
        	ERS_ln(n,6)=mean(ln_cc(idx_ERS_DB_all));
        	mem_ln(n,1)=mean(ln_cc(idx_mem_D));
        	mem_ln(n,2)=mean(ln_cc(idx_mem_DB_wc));
        	ln_ln(n,1)=mean(ln_cc(idx_ln_D));
        	ln_ln(n,2)=mean(ln_cc(idx_ln_DB_wc));
        	ln_ln(n,3)=mean(ln_cc(idx_ln_DB_all));
                %item-specific information sensitive voxels from retrieval phase
                half_data_vmem=data_vmem([1:48 97:144]+48*(hr-1),:);
        	tmem_cc=1-pdist(half_data_vmem(:,:),'correlation');
		mem_cc=0.5*(log(1+tmem_cc)-log(1-tmem_cc));

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
		end %n
        file_name=sprintf('%s/ERS_ln_sub%02d_d%d_r%d_%s', resultdir,s,hd,hr,roi_name{roi});
        eval(sprintf('save %s ERS_ln',file_name));
        file_name=sprintf('%s/ERS_mem_sub%02d_d%d_r%d_%s', resultdir,s,hd,hr,roi_name{roi});
        eval(sprintf('save %s ERS_mem',file_name));
        file_name=sprintf('%s/mem_ln_sub%02d_d%d_r%d_%s', resultdir,s,hd,hr,roi_name{roi});
        eval(sprintf('save %s mem_ln',file_name));
        file_name=sprintf('%s/mem_mem_sub%02d_d%d_r%d_%s', resultdir,s,hd,hr,roi_name{roi});
        eval(sprintf('save %s mem_mem',file_name));
        file_name=sprintf('%s/ln_ln_sub%02d_d%d_r%d_%s', resultdir,s,hd,hr,roi_name{roi});
        eval(sprintf('save %s ln_ln',file_name));
        file_name=sprintf('%s/ln_mem_sub%02d_d%d_r%d_%s', resultdir,s,hd,hr,roi_name{roi});
        eval(sprintf('save %s ln_mem',file_name)); 
	end %result half
	end %data half
	end %end roi
end %sub
end %end func
