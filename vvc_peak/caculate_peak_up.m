function caculate_peak_up_top(c)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/merged',basedir);

condname={'ERS_IBwc','ERS_DBwc','mem_DBwc','ln_DBwc'}
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
nt=50;
for s=subs;
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc] = get_idx(s);

        %get fMRI data
        data_file=sprintf('%s/sub%02d.nii.gz',datadir,s);
        data_all=load_nii_zip(data_file);
        data=data_all.img;
        %get coordinate
        coord_file=sprintf('%s/%s_%d.mat', coorddir,condname{c},nt);
        coords=load(coord_file);
 		%get material similarity matrix for encoding phase
		tdata=data(squeeze(coords(s,:,[1:3])),:);
		xx=tdata;
       	tcc=1-pdist(xx(:,:),'correlation');
       	cc=0.5*(log(1+tcc)-log(1-tcc));
		ERS_z(s,1)=mean(cc(idx_ERS_I));
        ERS_z(s,2)=mean(cc(idx_ERS_IB_wc));
        ERS_z(s,3)=mean(cc(idx_ERS_IB_all));
        ERS_z(s,4)=mean(cc(idx_ERS_D));
	    ERS_z(s,5)=mean(cc(idx_ERS_DB_wc));
       	ERS_z(s,6)=mean(cc(idx_ERS_DB_all));

        mem_z(s,1)=mean(cc(idx_mem_D));
        mem_z(s,2)=mean(cc(idx_mem_DB_wc));
        mem_z(s,3)=mean(cc(idx_mem_DB_all));

       	ln_z(s,1)=mean(cc(idx_ln_D));
      	ln_z(s,2)=mean(cc(idx_ln_DB_wc));
	    ln_z(s,3)=mean(cc(idx_ln_DB_all));
end%sub
	    ERS=[subs' ERS_z(subs,:)];mem=[subs' mem_z(subs,:)];ln=[subs' ln_z(subs,:)];
	    file_name=sprintf('%s/ERS_%d.txt', resultdir,nt);
	    eval(sprintf('save %s ERS -ascii',file_name));
        file_name=sprintf('%s/mem_%d.txt', resultdir,nt);
        eval(sprintf('save %s mem -ascii',file_name));
        file_name=sprintf('%s/ln_%d.txt', resultdir,nt);
        eval(sprintf('save %s ln -ascii',file_name));
        file_name=sprintf('%s/all_%d.txt', resultdir,nt);
        eval(sprintf('save %s cc -ascii',file_name));
%end %end c
end %function
