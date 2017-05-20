function Cal_EquivalentInRepresentationSpace(r,subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
datadir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4/data_two_sets',basedir);
resultdir=sprintf('%s/ROI_based/subs_within_between/add_rank/test4',basedir);

% basedir='/Users/xiaoqian/Documents/experiment/ISR_2015_results';
% addpath /Users/xiaoqian/Documents/experiment/ISR_2015_results/scripts/bnuserver
% addpath /Users/xiaoqian/Documents/scripts/NIFTI
% datadir='/Users/xiaoqian/Documents/experiment/ISR_2015_results/data/tmap/across_subs/test4/data_two_sets';
%subs=setdiff(1:21,2);
nsub=length(subs);
roi_name={'tLVVC','LANG','LSMG','LIFG','LMFG','LSFG',...
    'tRVVC','RANG','RSMG','RIFG','RMFG','RSFG',...
    'fmPFC','fPMC',...
    'CA1','DG','subiculum','PRC','ERC'};
roi=r;
s=subs;
%%%%%%%%%
%load data
load(sprintf('%s/sub%02d_%s.mat',datadir,s,roi_name{roi}));
%representation space matrix for all subjects
for np1=1:1000
    data1=all_data_ln1(:,:,np1);
    for np2=1:1000
        data2=all_data_ln2(:,:,np2);
        cal_equ_ln(np1,np2)=all(all(data1==data2));
    end %end permutation2
end % end permutation1
for np1=1:1000
    data1=all_data_mem1(:,:,np1);
    for np2=1:1000
        data2=all_data_mem2(:,:,np2);
        cal_equ_mem(np1,np2)=all(all(data1==data2));
    end %end permutation2
end % end permutation1
eval(sprintf('save %s/NumEqu_RS_sub%02d_%s.mat cal_equ_ln cal_equ_mem', resultdir,s,roi_name{roi}));
end %function