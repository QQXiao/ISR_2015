function allroi
basedir='/seastor/helenhelen/ISR_2015';
labeldir=[basedir,'/behavior/label'];
datadir=sprintf('%s/ROI_based/ref_space/TR/tVVC/sub/z',basedir);
resultdir=sprintf('%s/ROI_based/ref_space/TR/TR_co',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
'mPFC','PCC'}
subs=setdiff([1:21],2);
s=subs';
for roi=1:length(roi_name)
    all_ERS_I=[];all_ERS_D=[];all_ERS_d=[];all_ERS_i=[];
    tmERS_I=[];tmERS_D=[];tmERS_d=[];tmERS_i=[];
    mERS_I=[];mERS_D=[];mERS_d=[];mERS_i=[];
    for sub=subs
    tall_ERS_I=[];tall_ERS_D=[];tall_ERS_d=[];tall_ERS_i=[];
        for ETR=1:4
            for RTR=1:4
                load(sprintf('%s/ERS_sub%02d_E%dR%d',datadir,sub,ETR,RTR));
                %load(sprintf('%s/mem_sub%02d_E%dR%d',datadir,sub,ETR,RTR));
                %load(sprintf('%s/ln_sub%02d_E%dR%d',datadir,sub,ETR,RTR));
                tall_ERS_I=[tall_ERS_I ERS_z(roi,1)-ERS_z(roi,2)];
                tall_ERS_D=[tall_ERS_D ERS_z(roi,4)-ERS_z(roi,5)];
                tall_ERS_d=[tall_ERS_d ERS_z(roi,4)];
                tall_ERS_i=[tall_ERS_i ERS_z(roi,4)];
                %all_mem_z=[all_mem_z mem_z(roi,:)];
                %all_ln_z=[all_ln_z ln_z(roi,:)];
            end
        end
    all_ERS_I=[all_ERS_I;tall_ERS_I];
    all_ERS_D=[all_ERS_D;tall_ERS_D];
    all_ERS_d=[all_ERS_d;tall_ERS_d];
    all_ERS_i=[all_ERS_i;tall_ERS_i];
    end %end sub
    tmERS_I=mean(all_ERS_I);
    tmERS_D=mean(all_ERS_D);
    tmERS_d=mean(all_ERS_d);
    tmERS_i=mean(all_ERS_i);
    mERS_I=reshape(tmERS_I,4,4);
    mERS_D=reshape(tmERS_D,4,4);
    mERS_d=reshape(tmERS_d,4,4);
    mERS_i=reshape(tmERS_i,4,4);
    aERS_I=[s all_ERS_I];
    aERS_D=[s all_ERS_D];
    aERS_d=[s all_ERS_d];
    aERS_i=[s all_ERS_i];

    file_name=sprintf('%s/ERS_I_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s mERS_I -ascii',file_name));
    file_name=sprintf('%s/ERS_D_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s mERS_D -ascii',file_name));
    file_name=sprintf('%s/ERS_dd_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s mERS_d -ascii',file_name));
    file_name=sprintf('%s/ERS_ii_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s mERS_i -ascii',file_name));
    file_name=sprintf('%s/aERS_I_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s aERS_I -ascii',file_name));
    file_name=sprintf('%s/aERS_D_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s aERS_D -ascii',file_name));
    file_name=sprintf('%s/aERS_dd_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s aERS_d -ascii',file_name));
    file_name=sprintf('%s/aERS_ii_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s aERS_i -ascii',file_name));
    %file_name=sprintf('%s/ERS_I_%s.txt', resultdir,roi_name{roi});
    %eval(sprintf('save %s aERS_I -ascii',file_name));
    %file_name=sprintf('%s/ERS_D_%s.txt', resultdir,roi_name{roi});
    %eval(sprintf('save %s amem_z -ascii',file_name));
    %file_name=sprintf('%s/ln_%s.txt', resultdir,roi_name{roi});
    %eval(sprintf('save %s aln_z -ascii',file_name));
end %end roi
end%end function
