function caculate_ps_half_run(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
datadir=sprintf('%s/top/tmap/data/number_based/new_vvc_sep_roi',basedir);
resultdir=sprintf('%s/top/tmap/ps/number_based/new_vvc_sep_roi',basedir);
%%%%%%%%%
roi_name={'VVC','FPC'};
for s=subs
	for roi=1:2
	for hd=1:2
		for hr=1:2	
		[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx_sep_12_34(s,hr);
		tn=[0:5:95 96:1:99 99.1 99.2 99.3 99.4 99.5 99.6 99.7 99.8 99.9];
		%tn=[0:5:95 96:1:99;
		for n=1:length(tn)
		nn=tn(n);
		%if nn <= 99
		%ln_file=sprintf('%s/%s_p%d_ln_sub%02d_h%d.mat',datadir,roi_name{roi},nn,s,hd);
		%mem_file=sprintf('%s/%s_p%d_mem_sub%02d_h%d.mat',datadir,roi_name{roi},nn,s,hd);
		%else
		ln_file=sprintf('%s/%s_p%.1f_ERSI_sub%02d_h%d.mat',datadir,roi_name{roi},nn,s,hd);
                mem_file=sprintf('%s/%s_p%.1f_ERSD_sub%02d_h%d.mat',datadir,roi_name{roi},nn,s,hd);
		%end
       		load(ln_file);
		half_data_vln=data_vln([1:48 97:144]+48*(hr-1),:);
		load(mem_file);
		half_data_vmem=data_vmem([1:48 97:144]+48*(hr-1),:);		
 	
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
	file_name=sprintf('%s/ERSI_sub%02d_d%d_r%d_%s', resultdir,s,hd,hr,roi_name{roi});
	eval(sprintf('save %s ERSI',file_name));
	file_name=sprintf('%s/ERSD_sub%02d_d%d_r%d_%s', resultdir,s,hd,hr,roi_name{roi});
	eval(sprintf('save %s ERSD',file_name)); 
	end %result half
	end %data half
	end %end roi
end %sub
end %end func
