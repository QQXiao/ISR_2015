function regress_ps_act(m)
methodsname={'LSS','TR34','ms_LSS','glm'};
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015'; 
psdir=sprintf('%s/Searchlight_RSM/standard_space/glm/group/roi/data/ps',basedir);
actdir=sprintf('%s/Searchlight_RSM/standard_space/glm/group/roi/data/act',basedir);
resultdir=sprintf('%s/Searchlight_RSM/standard_space/glm/group/roi/data/regress_act',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
subs=setdiff(1:21,2);
roi_names={'IPL','VVC'};
cond_names={'ln_DBwc','mem_DBwc','ERS_DBwc','ERS_IBwc','ERS_ID'};
%%%%%%%%% 
for c=1:length(cond_names)
	par_actMean=[];
	par_actStd=[];
	for roi=1:length(roi_names)
	%get act data
	act_file=sprintf('%s/%s_%s.txt',actdir,cond_names{c},roi_names{roi});
	act_all=load(act_file);
	act=act_all(4:end,:);
	actMean=mean(act,2);
	actStd=std(act,0,2);
	%get ps data
	ps_file=sprintf('%s/%s_%s.txt',psdir,roi_names{roi},cond_names{c}); 
	ps_all=load(ps_file);
	ps=ps_all;
	%regression
	[B,BINT,R] = regress(ps,actMean); % regress out actMean effect 
	%[B,BINT,R] = regress(ps,[actMean ones(length(subs),1)]); % regress out actMean effect 
	c_par_actMean=R;
	[B,BINT,R] = regress(ps,actStd); % regress out actStd effect 
	c_par_actStd=R;
	par_actMean=[par_actMean c_par_actMean];
	par_actStd=[par_actStd c_par_actStd];
	end %end roi
outputfile=sprintf('%s/%s_actMean.txt',resultdir,cond_names{c});
eval(sprintf('save %s par_actMean -tabs -ascii',outputfile));
outputfile=sprintf('%s/%s_actStd.txt',resultdir,cond_names{c});
eval(sprintf('save %s par_actStd -tabs -ascii',outputfile));
end %end cond
