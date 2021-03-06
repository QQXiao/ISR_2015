function merge_pn_sub_data()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak
psdir=sprintf('%s/top/tmap/ps/number_based/sep_roi',basedir);
subs=setdiff(1:21,2);
roi_name={'VVC','FPC'};
for roi=1:length(roi_name);
	for hd=1:2 %data
		for hr=1:2 %result
		ln_mln_all=[];mem_mln_all=[];
		ln_mmem_all=[];mem_mmem_all=[];
			for s=subs
			ln_mln=[];mem_mln=[];
			ln_mmem=[];mem_mmem=[];
			%get pn file for each sub
			ln_lnfile=sprintf('%s/ln_ln_sub%02d_d%d_r%d_%s.mat',psdir,s,hd,hr,roi_name{roi});           
			mem_lnfile=sprintf('%s/mem_ln_sub%02d_d%d_r%d_%s.mat',psdir,s,hd,hr,roi_name{roi});           
			mem_memfile=sprintf('%s/mem_mem_sub%02d_d%d_r%d_%s.mat',psdir,s,hd,hr,roi_name{roi});           
			ln_memfile=sprintf('%s/ln_mem_sub%02d_d%d_r%d_%s.mat',psdir,s,hd,hr,roi_name{roi});           
			load(ln_lnfile);load(mem_lnfile);
			load(ln_memfile);load(mem_memfile);
			n=[0:5:95 96:99 99.1 99.2 99.3 99.4 99.5];
			%n=10:10:100
			sizel=length(n);
			ln_mln=[s*ones(sizel(1),1) n' ln_ln(:,[1 2])];
			mem_mln=[s*ones(sizel(1),1) n' mem_ln(:,[1 2])];
			ln_mmem=[s*ones(sizel(1),1) n' ln_mem(:,[1 2])];
			mem_mmem=[s*ones(sizel(1),1) n' mem_mem(:,[1 2])];
			ln_mln_all=[ln_mln_all;ln_mln];
			mem_mln_all=[mem_mln_all;mem_mln];
			ln_mmem_all=[ln_mmem_all;ln_mmem];
			mem_mmem_all=[mem_mmem_all;mem_mmem];
			end %sub
			eval(sprintf('save %s/allsub_ln_mln_d%d_r%d_%s.txt ln_mln_all -ascii -tabs', psdir,hd,hr,roi_name{roi}));
			eval(sprintf('save %s/allsub_mem_mln_d%d_r%d_%s.txt mem_mln_all -ascii -tabs', psdir,hd,hr,roi_name{roi}));
			eval(sprintf('save %s/allsub_ln_mmem_d%d_r%d_%s.txt ln_mmem_all -ascii -tabs', psdir,hd,hr,roi_name{roi}));
			eval(sprintf('save %s/allsub_mem_mmem_d%d_r%d_%s.txt mem_mmem_all -ascii -tabs', psdir,hd,hr,roi_name{roi}));
		end %result
	end %data
end %roi
end %function
