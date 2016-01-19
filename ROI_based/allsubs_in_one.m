function allroi(m)
methodname={'LSS','TR34'};
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based/ref_space/glm/sub/z/sub_hipp',basedir);
resultdir=sprintf('%s/ROI_based/ref_space/glm/sub_hipp',basedir);
%datadir=sprintf('%s/ROI_based/ref_space/zscore/final/sub/z',basedir);
%resultdir=sprintf('%s/ROI_based/ref_space/zscore/final',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
%roi_name={'CC','vLOC','OF','TOF','pTF','aTF',...
%'dLOC','ANG','SMG','IFG',...
%'HIP','pPHG','aPHG'};
%roi_name={'CA1','CA2','DG','CA3','subiculum','ERC'};
%roi_name={'VVC','dLOC','IPL'}                                                       
roi_name={'CC','VVC','dLOC','IPL','IFG','HIP','PHG'}                                                      
%                'HIP','pPHG','aPHG',...
%                'aSMG','pSMG'}
%roi_name={'LIFG','RIFG','LIPL','RIPL','LFUS','RFUS','LITG','RITG',...
%          'LdLOC','RdLOC','LvLOC','RvLOC','LMTG','RMTG','LHIP','RHIP',...
%         'LAMG','RAMG','LPHG','RPHG','LaPHG','RaPHG','LpPHG','RpPHG',...
%    	  'LaSMG','RaSMG','LpSMG','RpSMG','LANG','RANG','LSPL','RSPL',...
%	  'LFFA','RFFA',...
%          'PCC','Precuneous','LFOC','LPreCG','RFOC','RPreCG'}; %38 rois in total
subs=setdiff([1:21],2);
s=subs';
aERS_z=[];amem_z=[];aln_z=[];
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
	si=size(all_ERS_z);
        tERS_z=[s roi*ones(si(1),1) all_ERS_z];
        tmem_z=[s roi*ones(si(1),1) all_mem_z];
        tln_z=[s roi*ones(si(1),1) all_ln_z];
	aERS_z=[aERS_z;tERS_z];
	amem_z=[amem_z;tmem_z];
	aln_z=[aln_z;tln_z];
end
        file_name=sprintf('%s/ERS_ISR.txt', resultdir);
        eval(sprintf('save %s aERS_z -ascii',file_name));
        file_name=sprintf('%s/mem_ISR.txt', resultdir);
        eval(sprintf('save %s amem_z -ascii',file_name));
	file_name=sprintf('%s/ln_ISR.txt', resultdir);
        eval(sprintf('save %s aln_z -ascii',file_name));
end%end function
