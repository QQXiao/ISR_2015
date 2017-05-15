function allroi()
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based/subs_within_between/add_rank/test3/crossRoi',basedir);
resultdir=sprintf('%s/ROI_based/subs_within_between/add_rank/test3/crossRoi',basedir);

addpath /seastor/helenhelen/scripts/NIFTI

roi_name1={'tLVVC','tRVVC'};
roi_name2={'LANG','RANG','LSMG','RSMG','LIFG', 'RIFG','LMFG', 'RMFG',...
'LSFG', 'RSFG','fmPFC','fPMC'};
%'mPFC','PCC',...
%roi_name={'CA1','DG','subiculum','PRC','ERC'};

subs=setdiff([1:21],2);
s=subs';
aERS12_z=[];aERS21_z=[];amem_z=[];aln_z=[];
for r1=1:length(roi_name1)
    for r2=1:length(roi_name2)
        tERS12_z=[]; ERS12_z=[]; tERS21_z=[]; ERS21_z=[]; tmem_z=[]; mem_z=[]; tln_z=[]; ln_z=[];
        ERS12_z=load(sprintf('%s/ERS12_%s_%s.txt',datadir,roi_name1{r1},roi_name2{r2}));
        ERS21_z=load(sprintf('%s/ERS21_%s_%s.txt',datadir,roi_name1{r1},roi_name2{r2}));
        mem_z=load(sprintf('%s/mem_%s_%s.txt',datadir,roi_name1{r1},roi_name2{r2}));
        ln_z=load(sprintf('%s/ln_%s_%s.txt',datadir,roi_name1{r1},roi_name2{r2}));

        si=size(s);
        tERS12_z=[s (r2+(r1-1)*length(roi_name2))*ones(si(1),1) ERS12_z(s,:)];
        tERS21_z=[s (r2+(r1-1)*length(roi_name2))*ones(si(1),1) ERS21_z(s,:)];
        tmem_z=[s (r2+(r1-1)*length(roi_name2))*ones(si(1),1) mem_z(s,:)];
        tln_z=[s (r2+(r1-1)*length(roi_name2))*ones(si(1),1) ln_z(s,:)];
        aERS12_z=[aERS12_z;tERS12_z];
        aERS21_z=[aERS21_z;tERS21_z];
        amem_z=[amem_z;tmem_z];
        aln_z=[aln_z;tln_z];
    end
end
        file_name=sprintf('%s/24roi_ERS12.txt',resultdir);
        eval(sprintf('save %s aERS12_z -ascii',file_name));
        file_name=sprintf('%s/24roi_ERS21.txt',resultdir);
        eval(sprintf('save %s aERS21_z -ascii',file_name));
        file_name=sprintf('%s/24roi_mem.txt',resultdir);
        eval(sprintf('save %s amem_z -ascii',file_name));
        file_name=sprintf('%s/24roi_ln.txt',resultdir);
        eval(sprintf('save %s aln_z -ascii',file_name));
end%end function
