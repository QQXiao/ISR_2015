function allroi(m)
methodname={'LSS','TR34'};
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based/ref_space/glm',basedir);
resultdir=sprintf('%s/ROI_based/ref_space/glm/tVVC',basedir);
%datadir=sprintf('%s/ROI_based/ref_space/glm/sub_hipp',basedir);
%resultdir=sprintf('%s/ROI_based/ref_space/glm/sub_hipp',basedir);
%datadir=sprintf('%s/ROI_based/ref_space/zscore/final/sub/z',basedir);
%resultdir=sprintf('%s/ROI_based/ref_space/zscore/final',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
%roi_name={'CC','VVC','dLOC','IPL','SPL','IFG','MFG','HIP','PHG'};
%roi_name={'vLOC','OF','TOF','pTF','aTF','ANG','SMG','pSMG','aSMG','pPHG','aPHG'};
%roi_name={'LVVC','LANG','LSMG','LIFG','RVVC','RANG','RSMG','RIFG'};
%roi_name={'LVVC','LANG','LSMG','LIFG','LMFG','RVVC','RANG','RSMG','RIFG','RMFG'};
roi_name={'LVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
'RVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
'mPFC','PCC'};
%roi_name={'LVVC','LIPL','LIFG','RVVC','RIPL','RIFG'};
%roi_name={'CA1','CA2','DG','CA3','subiculum','PRC','ERC','pPHG'};
subs=setdiff([1:21],2);
s=subs';
aERS_z=[];amem_z=[];aln_z=[];
for roi=1:length(roi_name)
        tERS_z=[]; ERS_z=[]; tmem_z=[]; mem_z=[]; tln_z=[]; ln_z=[];
        ERS_z=load(sprintf('%s/ERS_%s.txt',datadir,roi_name{roi}));
        mem_z=load(sprintf('%s/mem_%s.txt',datadir,roi_name{roi}));
        ln_z=load(sprintf('%s/ln_%s.txt',datadir,roi_name{roi}));

	si=size(ERS_z);
        tERS_z=[ERS_z(:,1) roi*ones(si(1),1) ERS_z(:,2:end)];
        tmem_z=[mem_z(:,1) roi*ones(si(1),1) mem_z(:,2:end)];
        tln_z=[ln_z(:,1) roi*ones(si(1),1) ln_z(:,2:end)];
	aERS_z=[aERS_z;tERS_z];
	amem_z=[amem_z;tmem_z];
	aln_z=[aln_z;tln_z];
end
        file_name=sprintf('%s/new_vvc_%droi_ERS.txt',resultdir,length(roi_name));
        eval(sprintf('save %s aERS_z -ascii',file_name));
        file_name=sprintf('%s/new_vvc_%droi_mem.txt',resultdir,length(roi_name));
        eval(sprintf('save %s amem_z -ascii',file_name));
	file_name=sprintf('%s/new_vvc_%droi_ln.txt',resultdir,length(roi_name));
        eval(sprintf('save %s aln_z -ascii',file_name));
end%end function
