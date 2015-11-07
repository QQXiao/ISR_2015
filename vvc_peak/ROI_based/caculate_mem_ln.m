function caculate_mem_ln()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/ROI',basedir);

condname={'ERS_IBwc','ERS_DBwc','mem_DBwc','ln_DBwc'}
%%%%%%%%%
xlength =  112;
ylength =  112;
zlength =  64;
radius=3;
step=1;     % compute accuracy map for every STEP voxels in each dimension                                                                                          eps
epsilon=1e-6;
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
resultdir=sprintf('%s/peak/VVC/data/top/ps/ROI_based/mem_ln',basedir);
lndir=sprintf('%s/peak/VVC/data/top/ps/ln_DBwc',basedir);
mkdir(resultdir);
nt=50;

roi_name={'LIFG','RIFG','LIPL','RIPL','LFUS','RFUS','LITG','RITG',...
            'LdLOC','RdLOC','LvLOC','RvLOC','LMTG','RMTG','LHIP','RHIP',...
            'LAMG','RAMG','LPHG','RPHG','LaPHG','RaPHG','LpPHG','RpPHG',...
            'LaSMG','RaSMG','LpSMG','RpSMG','LANG','RANG','LSPL','RSPL',...
            'LFFA','RFFA',...
            'PCC','Precuneous','LFOC','LPreCG','RFOC','RPreCG'}; %38 rois in total
mem_r=[];
ln_r=[];

for s=subs;
sln_r=[];smem_r=[];
        %get encoding materail similarity matrix
        ln_file=sprintf('%s/Mrln_%d_sub%02d.mat', lndir,nt,s);
        load(ln_file); ln=ln_tcc;
        %get fMRI data
	for roi=1:length(roi_name);
	tln_r=zeros(40,3);tmem_r=zeros(40,3);
        	xx=[];tmp_xx=[];
        	tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,s,roi_name{roi}));
        	xx=tmp_xx(4:end,1:end-1); % remove the final zero and the first three rows showing the coordinates
		%%analysis
        	data_ln=xx(1:96,:);
         	data_mem=xx(97:end,:);
                tcc_ln=1-pdist(data_ln(:,:),'correlation');
                %cc_ln=0.5*(log(1+tcc_ln)-log(1-tcc_ln));
                tcc_mem=1-pdist(data_mem(:,:),'correlation');
                %cc_mem=0.5*(log(1+tcc_mem)-log(1-tcc_mem));

                cc_encoding_ln=1-pdist([ln;tcc_ln],'correlation');
                cc_encoding_mem=1-pdist([ln;tcc_mem],'correlation');

		tln_r(:,1)=s;tln_r(:,2)=roi;tln_r(:,3)=mean(cc_encoding_ln);
		tmem_r(:,1)=s;tmem_r(:,2)=roi;tmem_r(:,3)=mean(cc_encoding_mem);
	sln_r=[sln_r;tln_r];
	smem_r=[smem_r;tmem_r];
        end %roi
	ln_r=[ln_r;sln_r];
	mem_r=[mem_r;smem_r];
end %end sub
mem_z=[];
ln_z=[];
    mem_z=0.5*(log(1+mem_r)-log(1-mem_r));
    ln_z=0.5*(log(1+ln_r)-log(1-ln_r));
    eval(sprintf('save %s/mem.txt mem_z -ascii', resultdir));
    eval(sprintf('save %s/ln.txt ln_z -ascii', resultdir));
end %function
