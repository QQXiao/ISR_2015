function Adj_AllsubsInOne_AcrossROIs()
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/method1/AcrossROIs',basedir);
resultdir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/method1/AcrossROIs',basedir);

addpath /seastor/helenhelen/scripts/NIFTI

roi_name1={'tLVVC','tRVVC'};
roi_name2={'LANG','RANG','LSMG','RSMG','LIFG', 'RIFG','LMFG', 'RMFG',...
'LSFG', 'RSFG','fmPFC','fPMC'};
%'mPFC','PCC',...
%roi_name={'CA1','DG','subiculum','PRC','ERC'};

subs=setdiff([1:21],2);
s=subs';
aERS_z=[];amem_z=[];aln_z=[];
for r1=1:length(roi_name1)
    for r2=1:length(roi_name2)
        tERS_z=[]; ERS_z=[]; tmem_z=[]; mem_z=[]; tln_z=[]; ln_z=[];
        ERS_z=load(sprintf('%s/ERS_%s_%s.txt',datadir,roi_name1{r1},roi_name2{r2}));
        mem_z=load(sprintf('%s/mem_%s_%s.txt',datadir,roi_name1{r1},roi_name2{r2}));
        ln_z=load(sprintf('%s/ln_%s_%s.txt',datadir,roi_name1{r1},roi_name2{r2}));

        si=size(s);
        tERS_z=[s (r2+(r1-1)*length(roi_name2))*ones(si(1),1) ERS_z(s,:)];
        tmem_z=[s (r2+(r1-1)*length(roi_name2))*ones(si(1),1) mem_z(s,:)];
        tln_z=[s (r2+(r1-1)*length(roi_name2))*ones(si(1),1) ln_z(s,:)];
        aERS_z=[aERS_z;tERS_z];
        amem_z=[amem_z;tmem_z];
        aln_z=[aln_z;tln_z];
    end
end
file_name=sprintf('%s/24roi_ERS.txt',resultdir);
eval(sprintf('save %s aERS_z -ascii',file_name));
file_name=sprintf('%s/24roi_mem.txt',resultdir);
eval(sprintf('save %s amem_z -ascii',file_name));
file_name=sprintf('%s/24roi_ln.txt',resultdir);
eval(sprintf('save %s aln_z -ascii',file_name));
end%end function
