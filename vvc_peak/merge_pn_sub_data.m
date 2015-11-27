function merge_pn_sub_data()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak
pndir=sprintf('%s/me/data/roi',basedir);
subs=setdiff(1:21,2);
ln_all=[];mem_all=[];
for s=subs
ln=[];mem=[];
	%get pn file for each sub
	lnfile=sprintf('%s/ln_ln_sub%02d.mat',pndir,s);           
	memfile=sprintf('%s/mem_mem_sub%02d.mat',pndir,s);           
	load(lnfile);load(memfile);
	n=60:5:95
	sizel=length(n);
	ln=[s*ones(sizel(1),1) n' ln_ln(n,[2 3])];
	mem=[s*ones(sizel(1),1) n' mem_mem(n,[2 3])];
	ln_all=[ln_all;ln];mem_all=[mem_all;mem];
end %sub
eval(sprintf('save %s/allsub_ln.txt ln_all -ascii -tabs', pndir));
eval(sprintf('save %s/allsub_mem.txt mem_all -ascii -tabs', pndir));
end %function
