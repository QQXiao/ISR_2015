function get_top_information()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
infodir=sprintf('%s/top/tmap/data/value_based/sep_roi',basedir);

datadir=sprintf('%s/data_singletrial/glm/all',basedir);
vvcdir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
%%%%%%%%%
subs=setdiff([1:21],2);
for h=1:2
	for s=subs
	tln=[];tmem=[];
	datafile=sprintf('%s/np_sub%02d',infodir,s);
	load(datafile)
	tln(1,:)=squeeze(pvln(1,h,:));
	tmem(1,:)=squeeze(pvmem(2,h,:));
	tln(2,:)=squeeze(nvln(1,h,:));
	tmem(2,:)=squeeze(nvmem(2,h,:));
	pln=find(tln(1,:)~=0);
	pmem=find(tmem(1,:)~=0);
	ln=tln(:,pln);
	ln=ln';
	mem=tmem(:,pmem);
	mem=mem'
	file_name=sprintf('%s/np_all_h%d_sub%02d',infodir,h,s);
	eval(sprintf('save %s ln mem',file_name));
	end %sub
end%half
end %function
