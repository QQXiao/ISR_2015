function allroi(m)
methodname={'LSS','TR34','mLSS','glm'};
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based/ref_space/glm/sub/z',basedir);
resultdir=sprintf('%s/ROI_based/ref_space/glm',basedir);
%datadir=sprintf('%s/ROI_based/ref_space/zscore/final/sub/z',basedir);
%resultdir=sprintf('%s/ROI_based/ref_space/zscore/final',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
roi_name={'VVC','dLOC','IPL','PHG','HIP'}                                                       
%roi_name={'VVC','dLOC','IPL','PHG','HIP','IFG',...
%        'CA1','CA2','DG','CA3','subiculum','ERC'};
subs=setdiff([1:21],2);
s=subs';
for roi=1:length(roi_name)
        all_ERS_r=[]; all_ERS_z=[]; all_mem_r=[]; all_mem_z=[]; all_ln_r=[]; all_ln_z=[];
        for sub=subs
        load(sprintf('%s/ERS_sub%02d',datadir,sub));
        load(sprintf('%s/mem_sub%02d',datadir,sub));
        load(sprintf('%s/ln_sub%02d',datadir,sub));
        %load(sprintf('%s/ERS_sub%02d_ISR',datadir,sub));
        %load(sprintf('%s/mem_sub%02d_ISR',datadir,sub));
        %load(sprintf('%s/ln_sub%02d_ISR',datadir,sub));

         all_ERS_z=[all_ERS_z;ERS_z(roi,:)];
         all_mem_z=[all_mem_z;mem_z(roi,:)];
         all_ln_z=[all_ln_z;ln_z(roi,:)];
        end %end sub
        aERS_z=[s all_ERS_z];
        amem_z=[s all_mem_z];
        aln_z=[s all_ln_z];

        %file_name=sprintf('%s/ERS_%s_ISR.txt', resultdir,roi_name{roi});
        file_name=sprintf('%s/ERS_%s.txt', resultdir,roi_name{roi});
        eval(sprintf('save %s aERS_z -ascii',file_name));
        %file_name=sprintf('%s/mem_%s_ISR.txt', resultdir,roi_name{roi});
        file_name=sprintf('%s/mem_%s.txt', resultdir,roi_name{roi});
        eval(sprintf('save %s amem_z -ascii',file_name));
	%file_name=sprintf('%s/ln_%s_ISR.txt', resultdir,roi_name{roi});
	file_name=sprintf('%s/ln_%s.txt', resultdir,roi_name{roi});
        eval(sprintf('save %s aln_z -ascii',file_name));
end %end roi
end%end function
