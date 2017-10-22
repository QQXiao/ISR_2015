function Adj_AllsubsInOne()
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/ROI_based/subs_within_between/MantelTest/noAver/method1',basedir);
resultdir=sprintf('%s/ROI_based/subs_within_between/MantelTest/noAver/method1',basedir);

addpath /seastor/helenhelen/scripts/NIFTI
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
'fmPFC','fPMC'};
%'mPFC','PCC',...
%roi_name={'CA1','DG','subiculum','PRC','ERC'};

subs=setdiff([1:21],2);
s=subs';
aERS_z=[];amem_z=[];aln_z=[];
for roi=1:length(roi_name)
    tERS_z=[]; ERS_z=[]; tmem_z=[]; mem_z=[]; tln_z=[]; ln_z=[];
    ERS_z=load(sprintf('%s/ERS_%s.txt',datadir,roi_name{roi}));
    mem_z=load(sprintf('%s/mem_%s.txt',datadir,roi_name{roi}));
    ln_z=load(sprintf('%s/ln_%s.txt',datadir,roi_name{roi}));

    si=size(s);
    tERS_z=[s roi*ones(si(1),1) ERS_z(s,:)];
    tmem_z=[s roi*ones(si(1),1) mem_z(s,:)];
    tln_z=[s roi*ones(si(1),1) ln_z(s,:)];
    aERS_z=[aERS_z;tERS_z];
    amem_z=[amem_z;tmem_z];
    aln_z=[aln_z;tln_z];
end
    file_name=sprintf('%s/%droi_ERS.txt',resultdir,length(roi_name));
    eval(sprintf('save %s aERS_z -ascii',file_name));
    file_name=sprintf('%s/%droi_mem.txt',resultdir,length(roi_name));
    eval(sprintf('save %s amem_z -ascii',file_name));
    file_name=sprintf('%s/%droi_ln.txt',resultdir,length(roi_name));
    eval(sprintf('save %s aln_z -ascii',file_name));
end%end function
