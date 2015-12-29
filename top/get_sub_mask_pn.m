function get_sub_mask(subs,n)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
niidir=sprintf('%s/data_singletrial/ref_space/zscore/beta/merged',basedir);
datadir=sprintf('%s/me/data/roi',basedir);
resultdir=sprintf('%s/peak/VVC/data/top/mask',basedir);
%%%%%%%%%
mkdir(resultdir);
for s=subs
    	%get fMRI data
    	niifile=sprintf('%s/sub%02d.nii.gz',niidir,s);
    	data_all=load_nii_zip(niifile);                     
    	data=data_all.img;
	data1=data(:,:,:,1);
	size_all=size(data);
	ln=zeros(size_all);
	mem=zeros(size_all);
	
    	lnfile=sprintf('%s/p%d_ln_sub%02d_withc.mat',datadir,n,s);
    	load(lnfile);
    	mask_ln=data_cvln(1:3,:);
	sln=size(mask_ln);
	for i=1:sln(2)
	c=mask_ln(:,i);
	ln(c(1),c(2),c(3),:)=1;
	end
    	memfile=sprintf('%s/p%d_mem_sub%02d_withc.mat',datadir,n,s);
    	load(memfile);
    	mask_mem=data_cvmem(1:3,:);
	smem=size(mask_mem);
        for j=1:smem(2)                                         
        c=mask_mem(:,j);
        mem(c(1),c(2),c(3),:)=1;
        end  
	
       	filename=sprintf('%s/top%d_ln_sub%02d.nii',resultdir,n,s);
       	data_all.img=squeeze(ln(:,:,:,:));                  
       	data_all.hdr.dime.dim(5)=1; % dimension chagne to     
       	save_untouch_nii(data_all, filename);                  
       	system(sprintf('gzip -f %s',filename));
       	filename=sprintf('%s/top%d_mem_sub%02d.nii',resultdir,n,s);
       	data_all.img=squeeze(mem(:,:,:,:));                  
       	data_all.hdr.dime.dim(5)=1; % dimension chagne to     
       	save_untouch_nii(data_all, filename);                  
       	system(sprintf('gzip -f %s',filename));
end%sub
end %function
