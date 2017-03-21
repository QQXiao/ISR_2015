function count_voxels()
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
datadir=sprintf('%s/top/tmap/data/number_based_WB',basedir);
resultdir=sprintf('%s/top/tmap/data/number_based_WB',basedir);
subs=setdiff([1:21],2);
for s=subs
        for h=1:2
	tn=[0:5:95 96:1:99 99.1 99.2 99.3 99.4 99.5 99.6 99.7 99.8 99.9];
		for n=1:length(tn)
		nn=tn(n);
		%if nn <= 99
		%ln_file=sprintf('%s/p%d_ln_sub%02d_h%d',datadir,nn,s,h);
		%mem_file=sprintf('%s/p%d_mem_sub%02d_h%d',datadir,nn,s,h);
		%else
		ln_file=sprintf('%s/p%.1f_ln_sub%02d_h%d.mat',datadir,nn,s,h);
                mem_file=sprintf('%s/p%.1f_mem_sub%02d_h%d.mat',datadir,nn,s,h);
		%end
		load(ln_file);load(mem_file);
		nln(s,n,h)=size(data_vln,2)
		nmem(s,n,h)=size(data_vmem,2);
		end
	end
end
file_name=sprintf('%s/num_inN_WB_voxels', resultdir);
eval(sprintf('save %s nln nmem',file_name));
end
