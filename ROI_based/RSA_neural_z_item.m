function RSA_neural_z_item(subs)
%subs=1;
%m=2;
methodname={'LSS','TR34','ms_LSS'};
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behav/label'];
datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);
rdir=sprintf('%s/ROI_based/ref_space/zscore/MTL/sub/r',basedir);
zdir=sprintf('%s/ROI_based/ref_space/zscore/MTL/sub/z',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/ISR_2015/behav

TN=96*2;
%%%%%%%%%
roi_name={'VVC','p95','dLOC',...
	'ANG','SMG','IFG','HIP',...
	'CA1','CA2','DG','CA3','subiculum','ERC'};
ERS_r=[]; ERS_z=[]; mem_r=[]; mem_z=[]; ln_r=[]; ln_z=[];
nERS=[]; nmem=[]; nln=[];
s=subs;
for t=1:48
        %get idx                                              
	[idx_mem_D,idx_mem_DB_wc,idx_mem_DB_all,idx_ln_D,idx_ln_DB_wc,idx_ln_DB_all,list_pid]=get_idx_item(s,t)
	%perpare data
	for roi=1:length(roi_name);
        xx=[];tmp_xx=[];
	if roi==1
	load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
	data_vln
	else
	tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
        xx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
	%data_all=xx;
        ln=xx(1:96,:);
        mem=xx(97:end,:);
	end
        tln=find(list_pid(1:96)==t);
        tmem=find(list_pid(97:end)==t);
	roi_ln(t,roi,1)=mean(ln(tln(1),:),2);
	roi_ln(t,roi,2)=mean(ln(tln(2),:),2);
	roi_ln(t,roi,3)=mean(mean(ln(tln,:),2));
	roi_mem(t,roi,1)=mean(mem(tmem(1),:),2);
	roi_mem(t,roi,2)=mean(mem(tmem(2),:),2);
	roi_mem(t,roi,3)=mean(mean(mem(tmem,:),2));
	
	data_all=[ln;mem];
        tcc=1-pdist(data_all(:,:),'correlation');
	cc=0.5*(log(1+tcc)-log(1-tcc));

        roi_mem(t,roi,4)=mean(cc(idx_mem_D));
        roi_mem(t,roi,5)=mean(cc(idx_mem_DB_wc));
        roi_mem(t,roi,6)=mean(cc(idx_mem_D))-mean(cc(idx_mem_DB_wc));
       	roi_ln(t,roi,4)=mean(cc(idx_ln_D));
        roi_ln(t,roi,5)=mean(cc(idx_ln_DB_wc));
        roi_ln(t,roi,6)=mean(cc(idx_ln_D))-mean(cc(idx_ln_DB_wc));
    end %end t
end %end roi
    eval(sprintf('save %s/mem_sub%02d roi_mem', rdir,s));
    eval(sprintf('save %s/ln_sub%02d roi_ln', rdir,s));
end %end func
