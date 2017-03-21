function caculate_ps_half_run(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
datadir=sprintf('%s/top/tmap/data/value_based',basedir);
resultdir=sprintf('%s/top/tmap/ps/value_based',basedir);
%%%%%%%%%
for s=subs
	for hd=1:2
		for hr=1:2	
		[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx_sep_12_34(s,hr);
		tn=[0:5:95 96:1:99];
		for n=1:length(tn)
		nn=tn(n);
		ln_file=sprintf('%s/p%d_ERSI_sub%02d_h%d', datadir,nn,s,hd);
		load(ln_file);
		half_data_vln=data_vERS([1:48 97:144]+48*(hr-1),:);
		mem_file=sprintf('%s/p%d_ERSD_sub%02d_h%d', datadir,nn,s,hd);
		load(mem_file);
		half_data_vmem=data_vERS([1:48 97:144]+48*(hr-1),:);
        	tln_cc=1-pdist(half_data_vln(:,:),'correlation');
		ln_cc=0.5*(log(1+tln_cc)-log(1-tln_cc));
		ERSI(n,1)=mean(ln_cc(idx_ERS_I));
        	ERSI(n,2)=mean(ln_cc(idx_ERS_IB_wc));
        	ERSI(n,3)=mean(ln_cc(idx_ERS_IB_all));
		
        	tmem_cc=1-pdist(half_data_vmem(:,:),'correlation');
		mem_cc=0.5*(log(1+tmem_cc)-log(1-tmem_cc));
		ERSD(n,1)=mean(mem_cc(idx_ERS_D));
        	ERSD(n,2)=mean(mem_cc(idx_ERS_DB_wc));
        	ERSD(n,3)=mean(mem_cc(idx_ERS_DB_all));
		end %n
        file_name=sprintf('%s/ERSI_sub%02d_d%d_r%d', resultdir,s,hd,hr);
        eval(sprintf('save %s ERSI',file_name));
        file_name=sprintf('%s/ERSD_sub%02d_d%d_r%d', resultdir,s,hd,hr);
        eval(sprintf('save %s ERSD',file_name));
	end %result half
	end %data half
end %sub
end %end func
