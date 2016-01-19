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
roi_name={'p90','p95','VVC','dLOC','IPL',...
	'IFG','HIP','PHG',...
	'CA1','CA2','DG','CA3','subiculum','ERC',...
	'aPHG','pPHG'};
ERS_r=[]; ERS_z=[]; mem_r=[]; mem_z=[]; ln_r=[]; ln_z=[];
nERS=[]; nmem=[]; nln=[];
s=subs;
for t=1:48
        %get idx
	[idx_mem_D,idx_mem_DB_wc,idx_mem_DB_all,idx_ln_D,idx_ln_DB_wc,idx_ln_DB_all,list_pid]=get_idx_item_all(s,t)
	%perpare data
	for roi=1:length(roi_name);
        xx=[];tmp_xx=[];
		if roi==1
		load(sprintf('%s/p90_ln_sub%02d.mat',topdir,s));
		ln=data_vln(1:96,:);
		load(sprintf('%s/p90_mem_sub%02d.mat',topdir,s));
		mem=data_vmem(97:end,:);
		elseif roi==2
                load(sprintf('%s/p95_ln_sub%02d.mat',topdir,s));
                ln=data_vln(1:96,:);
                load(sprintf('%s/p95_mem_sub%02d.mat',topdir,s));
                mem=data_vmem(97:end,:);		
		else
		tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
    		xx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
    		ln=xx(1:96,:);
   	 	mem=xx(97:end,:);
		end
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
    eval(sprintf('save %s/all_mem_sub%02d roi_mem', rdir,s));
    eval(sprintf('save %s/all_ln_sub%02d roi_ln', rdir,s));
end %end func
