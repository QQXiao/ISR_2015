function caculate_peak_up_top(c)
c=3;
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/merged',basedir);

condname={'ERS_IBwc','ERS_DBwc','mem_DBwc','ln_DBwc','ERS_ID'}
%%%%%%%%%
radius=3;
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
resultdir=sprintf('%s/peak/VVC/data/top/ps/%s',basedir,condname{c});
mkdir(resultdir);
coorddir=sprintf('%s/peak/VVC/data/top/coordinate',basedir);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
coords=[];tcoords=[];
kmax=112-radius;jmax=112-radius;imax=64-radius
nt=5000;
%tnt=3408;
tnt=3000;
for s=subs;
tdata=[];
cc=[];
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc] = get_idx(s);

        %get fMRI data
        data_file=sprintf('%s/sub%02d.nii.gz',datadir,s);
        data_all=load_nii_zip(data_file);
        data=data_all.img;
        %get coordinate
        coord_file=sprintf('%s/%s_%d.mat', coorddir,condname{c},nt);
        load(coord_file);
 		%get material similarity matrix for encoding phase
		co=squeeze(coords(s,:,[1:3]));
        for t=1:tnt;
            tmp=[];
            tmp=squeeze(data(co(t,1),co(t,2),co(t,3),:));
            tdata=[tdata tmp];
        end
	tnv=50:50:3000
	for i=1:length(tnv)
		nv=tnv(i);
                xx=tdata(:,(1:(50+50*(i-1))));                                            
		tcc=1-pdist(xx(:,:),'correlation');
       		cc=0.5*(log(1+tcc)-log(1-tcc));
	
       		tln_z(s,i,1)=s;tln_z(s,i,2)=nv;
       		tln_z(s,i,3)=mean(cc(idx_mem_D))-mean(cc(idx_mem_DB_wc));
	end %end nv
end%sub
ln_sub=tln_z(:,:,1);ln_nv=tln_z(:,:,2);ln_rsa=tln_z(:,:,3);
ln_z=[ln_sub(:) ln_nv(:) ln_rsa(:)];
ln_z(ln_z(:,1)==0,:)=[];

file_name=sprintf('%s/mem_nv_add.txt', resultdir);
eval(sprintf('save %s ln_z -ascii',file_name));
%end %end c
end %function
