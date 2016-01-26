function allroi(m)
methodname={'LSS','TR34','mLSS','glm'};
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based/ref_space/glm/t24/sub/z',basedir);
resultdir=sprintf('%s/ROI_based/ref_space/glm/t24',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
roi_name={'CC','VVC','dLOC','IPL','SPL','IFG','MFG','HIP','PHG',...
'vLOC','OF','TOF','pTF','aTF','ANG','SMG','pSMG','aSMG','pPHG','aPHG',...
'LCC','LVVC','LdLOC','LIPL','LSPL','LIFG','LMFG','LHIP','LPHG',...
'LvLOC','LOF','LTOF','LpTF','LaTF','LANG','LSMG','LpSMG','LaSMG','LpPHG','LaPHG',...
'RCC','RVVC','RdLOC','RIPL','RSPL','RIFG','RMFG','RHIP','RPHG',...
'RvLOC','ROF','RTOF','RpTF','RaTF','RANG','RSMG','RpSMG','RaSMG','RpPHG','RaPHG'};
subs=setdiff([1:21],2);
s=subs';
for roi=1:length(roi_name)
        all_ERS_r=[]; all_ERS_z=[]; all_mem_r=[]; all_mem_z=[]; all_ln_r=[]; all_ln_z=[];
        for sub=subs
        load(sprintf('%s/ERS_sub%02d',datadir,sub));
        load(sprintf('%s/mem_sub%02d',datadir,sub));
        load(sprintf('%s/ln_sub%02d',datadir,sub));

         all_ERS_z=[all_ERS_z;ERS_z(roi,:)];
         all_mem_z=[all_mem_z;mem_z(roi,:)];
         all_ln_z=[all_ln_z;ln_z(roi,:)];
        end %end sub
        aERS_z=[s all_ERS_z];
        amem_z=[s all_mem_z];
        aln_z=[s all_ln_z];

        file_name=sprintf('%s/ERS_%s.txt', resultdir,roi_name{roi});
        eval(sprintf('save %s aERS_z -ascii',file_name));
        file_name=sprintf('%s/mem_%s.txt', resultdir,roi_name{roi});
        eval(sprintf('save %s amem_z -ascii',file_name));
	file_name=sprintf('%s/ln_%s.txt', resultdir,roi_name{roi});
        eval(sprintf('save %s aln_z -ascii',file_name));
end %end roi
end%end function
