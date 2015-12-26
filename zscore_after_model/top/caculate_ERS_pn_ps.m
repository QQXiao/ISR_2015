function caulate_ps_matrix_p95(subs)
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak
psdir=sprintf('%s/me/data/ps_matrix',basedir);
resultdir=sprintf('%s/me/results/top95',basedir);
%%%%%%%%%
subs=setdiff(1:21,2);
for s=subs
load(sprintf('%s/ln_top95_mps_ln_sub%02d.mat',psdir,s));
load(sprintf('%s/mem_top95_mps_mem_sub%02d.mat',psdir,s));
        %%analysis
        cc(s)=1-pdist([cc_ln_ln;cc_mem_mem],'correlation');
end %sub
cc=cc(subs);
file_name=sprintf('%s/correlation_ln_mem_psm',resultdir);
eval(sprintf('save %s cc',file_name));
end %function
