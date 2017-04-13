function allroi()
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based/subs_within_between/mean',basedir);
resultdir=sprintf('%s/ROI_based/subs_within_between/mean',basedir);

addpath /seastor/helenhelen/scripts/NIFTI
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
'fmPFC','fPMC'};
%'mPFC','PCC',...
%'CA1','DG','subiculum','PRC','ERC'};

subs=setdiff([1:21],2);
s=subs';
aERS12_z=[];aERS21_z=[];amem_z=[];aln_z=[];
for roi=1:length(roi_name)
        tERS12_z=[]; ERS12_z=[]; tERS21_z=[]; ERS21_z=[]; tmem_z=[]; mem_z=[]; tln_z=[]; ln_z=[];
        ERS12_z=load(sprintf('%s/ERS12_%s.txt',datadir,roi_name{roi}));
        ERS21_z=load(sprintf('%s/ERS21_%s.txt',datadir,roi_name{roi}));
        mem_z=load(sprintf('%s/mem_%s.txt',datadir,roi_name{roi}));
        ln_z=load(sprintf('%s/ln_%s.txt',datadir,roi_name{roi}));

	si=size(s);
        tERS12_z=[s roi*ones(si(1),1) ERS12_z(s,:)];
        tERS21_z=[s roi*ones(si(1),1) ERS21_z(s,:)];
        tmem_z=[s roi*ones(si(1),1) mem_z(s,:)];
        tln_z=[s roi*ones(si(1),1) ln_z(s,:)];
	aERS12_z=[aERS12_z;tERS12_z];
    aERS21_z=[aERS21_z;tERS21_z];
	amem_z=[amem_z;tmem_z];
	aln_z=[aln_z;tln_z];
end
        file_name=sprintf('%s/%droi_ERS12.txt',resultdir,length(roi_name));
        eval(sprintf('save %s aERS12_z -ascii',file_name));
        file_name=sprintf('%s/%droi_ERS21.txt',resultdir,length(roi_name));
        eval(sprintf('save %s aERS21_z -ascii',file_name));
        file_name=sprintf('%s/%droi_mem.txt',resultdir,length(roi_name));
        eval(sprintf('save %s amem_z -ascii',file_name));
	file_name=sprintf('%s/%droi_ln.txt',resultdir,length(roi_name));
        eval(sprintf('save %s aln_z -ascii',file_name));
end%end function
