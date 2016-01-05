%% data structure
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

%subs=[5:14];
subs=setxor([1:21],2);
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/behav/results',basedir);

%% combine files for every sub
condnames={'encoding','test'};
for sub=subs
    resultfile=sprintf('%s/ISR%02d/behav',basedir,sub);
    %load learning files
for c=1:2
    for runid=1:2
    	for set=1:2
            	filename=ls(sprintf('%s/%s_sub%02d_run%d_set%d*',datadir,condnames{c},sub,runid,set)); 
            	eval(sprintf('load %s',filename));
		for tid=1:24
            	tmp1=ISR(ISR(:,Mtrial)==tid,MAonset); %% onset;
            	tmp2=[tmp1,ones(size(tmp1))*dur ones(size(tmp1))];
            	outputfile=sprintf('%s/%s_run%d_set%d_T%d.txt',resultfile,condnames{c},runid,set,tid);
            	eval(sprintf('save %s tmp2 -tabs -ascii',outputfile));
        	end %end trial
	end%end set
    end%end run
end%end conds
end
