function calculate_mean(subs)
addpath /seastor/helenhelen/scripts/NIFTI
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/Searchlight_RSM/ref_space/zscore/z',basedir);
resultdir=sprintf('%s/Searchlight_RSM/ref_space/zscore/each_cond',basedir);

list=[];
cond_D={'ln','mem'};
D_name={'D','Bwc','Ball'};
cond_is={'ERS'};
is_name={'I','IBwc','IBall','D','DBwc','DBall'};
for s=subs
	for d=1:2
	diff = load_nii_zip(sprintf('%s/%s_sub%02d.nii.gz',datadir,cond_D{d},s)); % read all volume
	diff1 = load_nii_zip(sprintf('%s/%s_sub%02d.nii.gz',datadir,cond_D{d},s),1); % read all volume
		for c=1:3
		a=diff.img(:,:,:,c);
        	diff1.img=a;
        	filename=sprintf('%s/%s_%s_sub%02d.nii',resultdir,cond_D{d},D_name{c},s);
        	save_untouch_nii(diff1, filename);
        	system(sprintf('gzip -f %s',filename));
  		end 
	end %end d
        for i=1:6
        diff = load_nii_zip(sprintf('%s/ERS_sub%02d.nii.gz',datadir,s)); % read all volume
        diff1 = load_nii_zip(sprintf('%s/ERS_sub%02d.nii.gz',datadir,s),1); % read all volume
                for c=1:6
                a=diff.img(:,:,:,c);
                diff1.img=a;                
		filename=sprintf('%s/ERS_%s_sub%02d.nii',resultdir,is_name{c},s);
                save_untouch_nii(diff1, filename);
                system(sprintf('gzip -f %s',filename));
                end 
        end %end g
end %end sub
end %end func
