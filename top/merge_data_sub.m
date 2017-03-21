function merge_pn_sub_data()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak
psdir=sprintf('%s/top/tmap/ps/p_based',basedir);
subs=setdiff(1:21,2);
d=1/96;
plist_all=0:d:1;
plist_need=plist_all(1:67);
plist=plist_need([1:5:46 47:(end-1)])';
for hd=1:2 %data
	for hr=1:2 %result
	ln_mln_all=[];mem_mln_all=[];
	ln_mmem_all=[];mem_mmem_all=[];
		for s=subs
		ln_mln=[];mem_mln=[];
		ln_mmem=[];mem_mmem=[];
		%get pn file for each sub
		ln_lnfile=sprintf('%s/ln_ln_sub%02d_d%d_r%d.mat',psdir,s,hd,hr);           
		mem_lnfile=sprintf('%s/mem_ln_sub%02d_d%d_r%d.mat',psdir,s,hd,hr);           
		mem_memfile=sprintf('%s/mem_mem_sub%02d_d%d_r%d.mat',psdir,s,hd,hr);           
		ln_memfile=sprintf('%s/ln_mem_sub%02d_d%d_r%d.mat',psdir,s,hd,hr);           
		load(ln_lnfile);load(mem_lnfile);
		load(ln_memfile);load(mem_memfile);
		sizel=length(plist);
		ln_mln=[s*ones(sizel(1),1) plist ln_ln(:,[1 2])];
		mem_mln=[s*ones(sizel(1),1) plist mem_ln(:,[1 2])];
		ln_mmem=[s*ones(sizel(1),1) plist ln_mem(:,[1 2])];
		mem_mmem=[s*ones(sizel(1),1) plist mem_mem(:,[1 2])];
		ln_mln_all=[ln_mln_all;ln_mln];
		mem_mln_all=[mem_mln_all;mem_mln];
		ln_mmem_all=[ln_mmem_all;ln_mmem];
		mem_mmem_all=[mem_mmem_all;mem_mmem];
		end %sub
		eval(sprintf('save %s/allsub_ln_mln_d%d_r%d.txt ln_mln_all -ascii -tabs', psdir,hd,hr));
		eval(sprintf('save %s/allsub_mem_mln_d%d_r%d.txt mem_mln_all -ascii -tabs', psdir,hd,hr));
		eval(sprintf('save %s/allsub_ln_mmem_d%d_r%d.txt ln_mmem_all -ascii -tabs', psdir,hd,hr));
		eval(sprintf('save %s/allsub_mem_mmem_d%d_r%d.txt mem_mmem_all -ascii -tabs', psdir,hd,hr));
	end %result
end %data
end %function
