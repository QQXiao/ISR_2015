function RSA_neural_z_item(subs)
%subs=1;
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behav/label'];
%datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);
datadir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
topdir=sprintf('%s/top/tmap/data',basedir);
rdir=sprintf('%s/me/tmap/data/sub',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

TN=96*2;
%%%%%%%%%
roi_name={'p90','p95'};
ERS_r=[]; ERS_z=[]; mem_r=[]; mem_z=[]; ln_r=[]; ln_z=[];
nERS=[]; nmem=[]; nln=[];
s=subs;
for n=[90,95];
for t=1:48
        %get idx
	[idx_mem_D,idx_mem_DB_wc,idx_mem_DB_all,idx_ln_D,idx_ln_DB_wc,idx_ln_DB_all,list_pid]=get_idx_item_all(s,t)
	%perpare data
	for roi=1:length(roi_name);
        xx=[];tmp_xx=[];
		load(sprintf('%s/p%d_ln_sub%02d.mat',topdir,n,s));
		ln=data_vln(1:96,:);
		load(sprintf('%s/p%d_mem_sub%02d.mat',topdir,n,s));
		mem=data_vmem(97:end,:);
    		
		tln=find(list_pid(1:96)==t);
    		tmem=find(list_pid(97:end)==t);
		roi_ln(t,roi,1)=mean(mean(ln(tln,:),2));
		roi_mem(t,roi,1)=mean(mean(mem(tmem,:),2));

		tcc_ln=1-pdist(ln(:,:),'correlation');
		cc_ln=0.5*(log(1+tcc_ln)-log(1-tcc_ln));
		tcc_mem=1-pdist(mem(:,:),'correlation');
		cc_mem=0.5*(log(1+tcc_mem)-log(1-tcc_mem));

    	roi_mem(t,roi,2)=mean(cc_mem(idx_mem_D));
    	roi_mem(t,roi,3)=mean(cc_mem(idx_mem_DB_wc));
    	roi_ln(t,roi,2)=mean(cc_ln(idx_ln_D));
    	roi_ln(t,roi,3)=mean(cc_ln(idx_ln_DB_wc));
    	end %end roi
end %end t
    eval(sprintf('save %s/all_mem_sub%02d_p%d roi_mem', rdir,s,n));
    eval(sprintf('save %s/all_ln_sub%02d_p%d roi_ln', rdir,s,n));
end %end func
