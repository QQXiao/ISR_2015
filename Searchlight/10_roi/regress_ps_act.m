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
cond_names_ln={'ln_DBwc'};
cond_names_mem={'mem_DBwc'};
%%%%%%%%%
for s=1:length(subs)
subid=subs(s);
%get act data
	for roi=1:length(roi_names)
        act_file=sprintf('%s/sub%02d_%s.txt',actdir,subid,roi_names{roi});
        act_all=load(act_file);
        act=act_all(4:end,:);
	act_ln=act(1:96,:);
	act_mem=act(97:end,:);
        tactMean_ln=mean(act_ln);
        actMean_ln(s)=mean(tactMean_ln);
	actStd_ln(s)=std(tactMean_ln,0);
        tactMean_mem=mean(act_mem);
        actMean_mem(s)=mean(tactMean_mem);
	actStd_mem(s)=std(tactMean_mem,0);
	end %end roi
end %end sub
for roi=1:length(roi_names)
		par_actMean=[];
		par_actStd=[];
	for c=1:length(cond_names_ln)
		%get ps data
		ps_file=sprintf('%s/%s_%s.txt',psdir,roi_names{roi},cond_names_ln{c}); 
		ps_all=load(ps_file);
		ps=ps_all;
		actMean=actMean_ln';
		actStd=actStd_ln';
		%regression
		[B,BINT,R] = regress(ps,actMean); % regress out actMean effect 
		%[B,BINT,R] = regress(ps,[actMean ones(length(subs),1)]); % regress out actMean effect 
		c_par_actMean=R;
		[B,BINT,R] = regress(ps,actStd); % regress out actStd effect 
		c_par_actStd=R;
		%par_actMean=[par_actMean c_par_actMean];
		%par_actStd=[par_actStd c_par_actStd];
		par_actMean=c_par_actMean;
		par_actStd=c_par_actStd;
		outputfile=sprintf('%s/%s_%s_actMean.txt',resultdir,roi_names{roi},cond_names_ln{c});
		eval(sprintf('save %s par_actMean -tabs -ascii',outputfile));
		outputfile=sprintf('%s/%s_%s_actStd.txt',resultdir,roi_names{roi},cond_names_ln{c});
		eval(sprintf('save %s par_actStd -tabs -ascii',outputfile));
	end %end condition
        for c=1:length(cond_names_mem)
                %get ps data
                ps_file=sprintf('%s/%s_%s.txt',psdir,roi_names{roi},cond_names_mem{c});
                ps_all=load(ps_file);
                ps=ps_all;
                actMean=actMean_mem';
                actStd=actStd_mem';
                %regression
                [B,BINT,R] = regress(ps,actMean); % regress out actMean effect 
                %[B,BINT,R] = regress(ps,[actMean ones(length(subs),1)]); % regress out actMean effect 
                c_par_actMean=R;
                [B,BINT,R] = regress(ps,actStd); % regress out actStd effect 
                c_par_actStd=R;
                %par_actMean=[par_actMean c_par_actMean];
                %par_actStd=[par_actStd c_par_actStd];
                par_actMean=c_par_actMean;
                par_actStd=c_par_actStd;
                outputfile=sprintf('%s/%s_%s_actMean.txt',resultdir,roi_names{roi},cond_names_mem{c});
                eval(sprintf('save %s par_actMean -tabs -ascii',outputfile));
                outputfile=sprintf('%s/%s_%s_actStd.txt',resultdir,roi_names{roi},cond_names_mem{c});
                eval(sprintf('save %s par_actStd -tabs -ascii',outputfile));
        end %end condition
end %end roi
