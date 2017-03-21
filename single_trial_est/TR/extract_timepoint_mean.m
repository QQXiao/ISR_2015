function extract_timepoint(subs)
Mtrial=1; % trial number
MpID=2;  % material id_pic
MwID=3;  % material id_word
Mcat1=4; % 1=structure,2=nature
Mcat2=5; % 1=structure-foreign,2=structure-local,3=nature-water,4=nature-land
Mres=6; %% 1=structure-foreign,2=structure-local,3=nature-water,4=nature-land
MRT=7; % reaction time;
Monset=8; % designed onset time
MAonset=9; % actually onset time
Mrun=10;
Mset=11;
MAonset_r=12; % actually onset time for response 1;category;
Mscore=13;%right or wrong for identity
%%added information
%Mmem=14;
%Mposit=15;
dur=4;
basedir='/seastor/helenhelen/ISR_2015';
labeldir=sprintf('%s/behav/results',basedir);
resultdir=sprintf('%s/data_singletrial/TR/native_space',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
sub=subs
TN=24;
for r=1:2
    for g=1:2
        etmp=[];rtmp=[];
        elabelfilename=ls(sprintf('%s/encoding_sub%02d_run%d_set%d*.mat',labeldir,sub,r,g));
        eval(sprintf('load %s',elabelfilename));
        etmp=ISR;
        niifile=sprintf('%s/ISR%02d/analysis/pre_encoding_run%d_set%d.feat/filtered_func_data.nii.gz',basedir,sub,r,g);
        all_data=load_nii_zip(niifile);
        all_data.img=zscore(all_data.img,0,4); % normalize along the time dimension
        onset=etmp(:,MAonset);
        all_data1=all_data.img(:,:,:,fix((onset+4)/2))/2+all_data.img(:,:,:,fix((onset+6)/2))/2;
        filename=sprintf('%s/sub%02d_encoding_run%d_set%d.nii',resultdir,sub,r,g);
        all_data.img=all_data1;
        all_data.hdr.dime.dim(5)=TN; % dimension chagne to
        save_untouch_nii(all_data, filename);
        system(sprintf('gzip -f %s',filename));

        rlabelfilename=ls(sprintf('%s/test_sub%02d_run%d_set%d*.mat',labeldir,sub,r,g));
        eval(sprintf('load %s',rlabelfilename));
        rtmp=ISR;
        niifile=sprintf('%s/ISR%02d/analysis/pre_test_run%d_set%d.feat/filtered_func_data.nii.gz',basedir,sub,r,g);
        all_data=load_nii_zip(niifile);
        all_data.img=zscore(all_data.img,0,4); % normalize along the time dimension
        onset=rtmp(:,MAonset);
        all_data1=all_data.img(:,:,:,fix((onset+4)/2))*0.4+all_data.img(:,:,:,fix((onset+6)/2))*0.4+all_data.img(:,:,:,fix((onset+8)/2))*0.2;
        filename=sprintf('%s/sub%02d_test_run%d_set%d.nii',resultdir,sub,r,g);
        all_data.img=all_data1;
        all_data.hdr.dime.dim(5)=TN; % dimension chagne to
        save_untouch_nii(all_data, filename);
        system(sprintf('gzip -f %s',filename));
    end
end
end
