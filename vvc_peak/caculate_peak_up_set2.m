function caculate_peak_up_top(c,nt)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/merged2',basedir);

condname={'ERS_IBwc','ERS_DBwc','mem_DBwc','ln_DBwc','ERS_ID'}
%%%%%%%%%
radius=3;
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
resultdir=sprintf('%s/peak/VVC/data/top/ps/set/%s',basedir,condname{c});
mkdir(resultdir);
coorddir=sprintf('%s/peak/VVC/data/top/coordinate',basedir);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
coords=[];tcoords=[];
kmax=112-radius;jmax=112-radius;imax=64-radius
for s=subs;
tdata=[];
cc=[];
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem] = get_idx(s);

        %get fMRI data
        data_file=sprintf('%s/sub%02d.nii.gz',datadir,s);
        data_all=load_nii_zip(data_file);
        data=data_all.img;
        %get coordinate
        coord_file=sprintf('%s/%s_20000.mat', coorddir,condname{c});
        load(coord_file);
 		%get material similarity matrix for encoding phase
		co=squeeze(coords(s,:,[1:3]));
        for t=1:nt;
            tmp=[];
            tmp=squeeze(data(co(t,1),co(t,2),co(t,3),:));
            tdata=[tdata tmp];
        end
		xx=tdata(:,1:nt);
		%xx=tdata;
       	tcc=1-pdist(xx(:,:),'correlation');
       	cc=0.5*(log(1+tcc)-log(1-tcc));

        yy=tdata(1:96,:);

        yy1=yy([1:24 49:72],:);
	m_ln_1=m_ln([1:24 49:72],:);
        tyy1=[yy1,m_ln_1];a=size(tyy1);ttyy1=sortrows(tyy1,a(2));data_ln_set1=ttyy1(:,[1:end-1]);
	ln_tcc1=1-pdist(data_ln_set1(:,:),'correlation');
        ln_cc1=0.5*(log(1+ln_tcc1)-log(1-ln_tcc1));
        yy2=yy([25:48 73:96],:);
        m_ln_2=m_ln([25:48 73:96],:);
	tyy2=[yy2,m_ln_2];a=size(tyy2);ttyy2=sortrows(tyy2,a(2));data_ln_set2=ttyy2(:,[1:end-1]);        
	ln_tcc2=1-pdist(data_ln_set2(:,:),'correlation');
        ln_cc2=0.5*(log(1+ln_tcc2)-log(1-ln_tcc2));
        file_name=sprintf('%s/Mrln_%d_sub%02d_set1', resultdir,nt,s);
        eval(sprintf('save %s ln_tcc1',file_name));
        file_name=sprintf('%s/Mrln_%d_sub%02d_set2', resultdir,nt,s);
        eval(sprintf('save %s ln_tcc2',file_name));

        zz=tdata(97:end,:);

        zz1=zz([1:24 49:72],:);
        m_mem_1=m_mem([1:24 49:72],:);
	tzz1=[zz1,m_mem_1];a=size(tzz1);ttzz1=sortrows(tzz1,a(2));data_mem_set1=ttzz1(:,[1:end-1]);
	mem_tcc1=1-pdist(data_mem_set1(:,:),'correlation');
        mem_cc1=0.5*(log(1+mem_tcc1)-log(1-mem_tcc1));
        zz2=zz([25:48 73:96],:);
        m_mem_2=m_mem([25:48 73:96],:);
	tzz2=[zz2,m_mem_2];a=size(tzz2);ttzz2=sortrows(tzz2,a(2));data_mem_set2=ttzz2(:,[1:end-1]);
	mem_tcc2=1-pdist(data_mem_set2(:,:),'correlation');
        mem_cc2=0.5*(log(1+mem_tcc2)-log(1-mem_tcc2));
        file_name=sprintf('%s/Mrmem_%d_sub%02d_set1', resultdir,nt,s);
        eval(sprintf('save %s mem_tcc1',file_name));
        file_name=sprintf('%s/Mrmem_%d_sub%02d_set2', resultdir,nt,s);
        eval(sprintf('save %s mem_tcc2',file_name));
end%sub
%end %end c
end %function
