function merge_pn_sub_data()
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
psdir=sprintf('%s/top/tmap/ps/number_based_WB',basedir);
cond_name={'ERSI','ERSD'};
	for c = 1:2
		d1r1=[];d1r2=[];d2r1=[];d2r2=[];
		same_mean=[];diff_mean=[];
		%get pn file for each cond
		d1r1_file=sprintf('%s/allsub_%s_d1_r1.txt',psdir,cond_name{c});           
		d1r2_file=sprintf('%s/allsub_%s_d1_r2.txt',psdir,cond_name{c});           
		d2r1_file=sprintf('%s/allsub_%s_d2_r1.txt',psdir,cond_name{c});           
		d2r2_file=sprintf('%s/allsub_%s_d2_r2.txt',psdir,cond_name{c});           
		d1r1=load(d1r1_file);d1r2=load(d1r2_file);
		d2r1=load(d2r1_file);d2r2=load(d2r2_file);
		subs=d1r1(:,1);np=d1r1(:,2);
		same_mean=[subs np mean([d1r1(:,3) d2r2(:,3)],2) mean([d1r1(:,4) d2r2(:,4)],2)];
		diff_mean=[subs np mean([d1r2(:,3) d2r1(:,3)],2) mean([d1r2(:,4) d2r1(:,4)],2)];
		eval(sprintf('save %s/allsub_%s_same_mean.txt same_mean -ascii -tabs', psdir,cond_name{c}));
		eval(sprintf('save %s/allsub_%s_diff_mean.txt diff_mean -ascii -tabs', psdir,cond_name{c}));
	end %cond
end %function
