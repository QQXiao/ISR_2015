function merge_pn_sub_data()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak
psdir=sprintf('%s/top/tmap/ps/number_based_WB',basedir);
subs=setdiff(1:21,2);
for hd=1:2 %data
	for hr=1:2 %result
	ERSI_all=[];ERSD_all=[];
		for s=subs
		ERSI=[];ERSD=[];
		%get pn file for each sub
		ERSIfile=sprintf('%s/ERSI_sub%02d_d%d_r%d.mat',psdir,s,hd,hr);           
		ERSDfile=sprintf('%s/ERSD_sub%02d_d%d_r%d.mat',psdir,s,hd,hr);           
		load(ERSIfile);load(ERSDfile);
		n=[0:5:95 96:99 99.1 99.2 99.3 99.4 99.5 99.6 99.7 99.8 99.9]
		sizel=length(n);
		ERSI=[s*ones(sizel(1),1) n' ERSI(:,[1 2])];
		ERSD=[s*ones(sizel(1),1) n' ERSD(:,[1 2])];
		ERSI_all=[ERSI_all;ERSI];
		ERSD_all=[ERSD_all;ERSD];
		end %sub
		eval(sprintf('save %s/allsub_ERSI_d%d_r%d.txt ERSI_all -ascii -tabs', psdir,hd,hr));
		eval(sprintf('save %s/allsub_ERSD_d%d_r%d.txt ERSD_all -ascii -tabs', psdir,hd,hr));
	end %result
end %data
end %function
