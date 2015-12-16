function RSA_neural_z_item(subs)
%subs=1;
methodname={'LSS','TR34','ms_LSS'};
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behav/label'];
datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);
rdir=sprintf('%s/me/data/sub',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav

TN=96*2;
%%%%%%%%%
roi_name={'p90','p95','VVC','dLOC','IPL',...
	'IFG','HIP',...
	'CA1','CA2','DG','CA3','subiculum','ERC',...
	'aPHG','pPHG'};
ERS_r=[]; ERS_z=[]; mem_r=[]; mem_z=[]; ln_r=[]; ln_z=[];
nERS=[]; nmem=[]; nln=[];
s=subs;
for t=1:48
        %get idx
        [idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,list_pid]=get_idx_item_ERS(s,t)
	%perpare data
	for roi=1:length(roi_name);
        xx=[];tmp_xx=[];
		if roi==1
		load(sprintf('%s/me/data/roi/p90_ln_sub%02d.mat',basedir,s));
		ln=data_vln;
		load(sprintf('%s/me/data/roi/p90_mem_sub%02d.mat',basedir,s));
		mem=data_vmem;
		elseif roi==2
                load(sprintf('%s/me/data/roi/p95_ln_sub%02d.mat',basedir,s));
                ln=data_vln;
                load(sprintf('%s/me/data/roi/p95_mem_sub%02d.mat',basedir,s));
                mem=data_vmem;
		else
		tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
    		xx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
    		ln=xx(1:96,:);
   	 	mem=xx(97:end,:);
		end
        tall=[ln;mem];
    		tln=find(list_pid(1:96)==t);
    		tmem=find(list_pid(97:end)==t);
		troi(t,roi,1)=mean(ln(tln(1),:),2);
		troi(t,roi,2)=mean(ln(tln(2),:),2);
		troi(t,roi,3)=mean(mem(tmem(1),:),2);
		troi(t,roi,4)=mean(mem(tmem(2),:),2);

		tcc=1-pdist(tall(:,:),'correlation');
		cc=0.5*(log(1+tcc)-log(1-tcc));

    	troi(t,roi,5)=mean(cc(idx_ERS_I));
    	troi(t,roi,6)=mean(cc(idx_ERS_IB_all));
    	troi(t,roi,7)=mean(cc(idx_ERS_IB_wc));
    	troi(t,roi,8)=mean(cc(idx_ERS_D));
    	troi(t,roi,9)=mean(cc(idx_ERS_DB_wc));
    	troi(t,roi,10)=mean(cc(idx_ERS_DB_all));
    	end %end roi
end %end t
    eval(sprintf('save %s/ERS_sub%02d troi', rdir,s));
end %end func
