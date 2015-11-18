function get_top_information(c)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak

datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/merged',basedir);
%%%%%%%%%
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
vvcdir=sprintf('%s/peak/VVC/data/vvc_data/%s',basedir,condname{c});
resultdir=sprintf('%s/peak/VVC/data/top/coordinate',basedir);
mkdir(resultdir);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
coords=zeros(21,nt,4);
for s=subs;
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);
        %get fMRI data
	vvcfile=sprintf('%s/sub%02d.nii.gz',vvcdir,s);
	vvc_all=load_nii_zip(vvcfile);
	vvc=vvc_all.img;
	ss=size(vvc);
        pa=combntns(ss(4),2);
	for k=1:ss(1);
		for j=1:ss(2);
			for i=1:ss(3);
			data_voxel=vvc(k,j,i,:);
			datav=data_voxel(:);
			coorv=datav(pa(:,1)).*datav(pa(:,2));
			lcoorv=sortcoorv;

			pln=
			end
        	end
	end 
end%sub
        file_name=sprintf('%s/%s_%d.mat', resultdir,condname{c},nt);
        eval(sprintf('save %s coords',file_name));
%end %end c
end %function
