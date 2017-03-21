function allroi(ETR,RTR)
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based/ref_space/TR/tVVC/sub/z',basedir);
resultdir=sprintf('%s/ROI_based/ref_space/TR',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
'mPFC','PCC'}
subs=setdiff([1:21],2);
s=subs';
for roi=1:length(roi_name)aERS_z=[];amem_z=[];aln_z=[];
    aERS_z=[];amem_z=[];aln_z=[];
    all_ERS_r=[]; all_ERS_z=[]; all_mem_r=[]; all_mem_z=[]; all_ln_r=[]; all_ln_z=[];
    for sub=subs
        load(sprintf('%s/ERS_sub%02d_E%dR%d',datadir,sub,ETR,RTR));
        load(sprintf('%s/mem_sub%02d_E%dR%d',datadir,sub,ETR,RTR));
        load(sprintf('%s/ln_sub%02d_E%dR%d',datadir,sub,ETR,RTR));

        all_ERS_z=[all_ERS_z;ERS_z(roi,:)];
        all_mem_z=[all_mem_z;mem_z(roi,:)];
        all_ln_z=[all_ln_z;ln_z(roi,:)];
    end %end sub
    aERS_z=[s all_ERS_z];
    amem_z=[s all_mem_z];
    aln_z=[s all_ln_z];

    file_name=sprintf('%s/ERS_%s_E%dR%d.txt', resultdir,roi_name{roi},ETR,RTR);
    eval(sprintf('save %s aERS_z -ascii',file_name));
    file_name=sprintf('%s/mem_%s_E%dR%d.txt', resultdir,roi_name{roi},ETR,RTR);
    eval(sprintf('save %s amem_z -ascii',file_name));
    file_name=sprintf('%s/ln_%s_E%dR%d.txt', resultdir,roi_name{roi},ETR,RTR);
    eval(sprintf('save %s aln_z -ascii',file_name));
end %end roi
end%end function
