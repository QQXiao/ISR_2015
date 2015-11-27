function merge_pn_sub_data()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak
pndir=sprintf('%s/me/data/roi',basedir);
subs=setdiff(1:21,2);
ln_mln_all=[];mem_mln_all=[];
ln_mmem_all=[];mem_mmem_all=[];
for s=subs
ln_mln=[];mem_mln=[];
ln_mmem=[];mem_mmem=[];
	%get pn file for each sub
	ln_lnfile=sprintf('%s/ln_ln_sub%02d.mat',pndir,s);           
	mem_lnfile=sprintf('%s/mem_ln_sub%02d.mat',pndir,s);           
	mem_memfile=sprintf('%s/mem_mem_sub%02d.mat',pndir,s);           
	ln_memfile=sprintf('%s/ln_mem_sub%02d.mat',pndir,s);           
	load(ln_lnfile);load(mem_lnfile);
	load(ln_memfile);load(mem_memfile);
	n=60:5:95
	sizel=length(n);
	ln_mln=[s*ones(sizel(1),1) n' ln_ln(n,[1 2])];
	mem_mln=[s*ones(sizel(1),1) n' mem_ln(n,[1 2])];
	ln_mmem=[s*ones(sizel(1),1) n' ln_mem(n,[1 2])];
	mem_mmem=[s*ones(sizel(1),1) n' mem_mem(n,[1 2])];
	ln_mln_all=[ln_mln_all;ln_mln];
	mem_mln_all=[mem_mln_all;mem_mln];
	ln_mmem_all=[ln_mmem_all;ln_mmem];
	mem_mmem_all=[mem_mmem_all;mem_mmem];
end %sub
eval(sprintf('save %s/allsub_ln_mln.txt ln_mln_all -ascii -tabs', pndir));
eval(sprintf('save %s/allsub_mem_mln.txt mem_mln_all -ascii -tabs', pndir));
eval(sprintf('save %s/allsub_ln_mmem.txt ln_mmem_all -ascii -tabs', pndir));
eval(sprintf('save %s/allsub_mem_mmem.txt mem_mmem_all -ascii -tabs', pndir));
end %function
