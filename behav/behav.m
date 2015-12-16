labeldir='/seastor/helenhelen/ISR_2015/behav/label';
datadir='/seastor/helenhelen/ISR_2015/behav/results';
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
Mposit=14;
Mmem=15;
Msub=16;
Mphase=17;

%subs=[8:10];
subs=setxor([1:21],2);

%% combine files for every sub
for sub=subs
    GRATE_ln=[];
    subln=[];
    GRATE_mem=[];
    submem=[];
    
    %load learning files
    for runid=1:2
        for set=1:2
            filename=ls(sprintf('%s/encoding_sub%02d_run%d_set%d*',datadir,sub,runid,set)); 
            eval(sprintf('load %s',filename));
            subln=[subln; ISR];        

            grate(grate(:,1)==0,:)=[];
            grate(:,1)=grate(:,1)+runid*24-24; %actually position in the sequence(all runs)
            grate(grate(:,3)==-1,3)=0;
            GRATE_ln=[GRATE_ln; grate];   
        end%end run
    end%end group
        subln(:,Mposit)=[1:96]; % actually position in the sequence(all runs)
    %load memory test files
    for runid=1:2
        for set=1:2
            filename=ls(sprintf('%s/test_sub%02d_run%d_set%d*',datadir,sub,runid,set));
            eval(sprintf('load %s',filename));
            submem=[submem; ISR];        
	
            grate(grate(:,1)==0,:)=[];
            grate(:,1)=grate(:,1)+runid*24-24; %actually position in the sequence(all runs)
            grate(grate(:,3)==-1,3)=0;
            GRATE_mem=[GRATE_mem; grate];   
        end%end run
    end%end group
    trial_mem=unique(submem(:,MwID));
    submem(:,Mposit)=[1:96]; % actually position in the sequence(all runs)
    submem(submem(:,Mscore)==1,Mmem)=1;
    submem(submem(:,Mscore)==0  & submem(:,Mres)~=0,Mmem)=2;
    submem(submem(:,Mres)==0,Mmem)=3;
%% analysis: 
%memory performance    
       mem_perf(sub,1)= length(find(submem(:,Mscore)==1))/96;%hit
       mem_perf(sub,2)= length(find(submem(:,Mscore)==0  & submem(:,Mres)~=0))/96;%wrong
       mem_perf(sub,3)= length(find(submem(:,Mres)==0))/96;%miss the response
%category report during encoding
       cate_perf(sub,1)= length(find(subln(:,Mscore)==1))/96;%hit
       cate_perf(sub,2)= length(find(subln(:,Mscore)==0 & subln(:,Mres)~=0))/96;%wrong
       cate_perf(sub,3)= length(find(subln(:,Mres)==0))/96;%miss the response
%RT and ACC, and make sure no diff in the grate task%encoding 
       cate_perf_rt(sub,1)= mean(subln(subln(:,Mscore)==1,MRT));%hit
       cate_perf_rt(sub,2)= mean(subln(subln(:,Mscore)==0 & subln(:,Mres)~=0,MRT));%wrong
       cate_perf_rt(sub,3)= mean(subln(subln(:,Mres)==0,MRT));%miss the response

     for rem=1:3 % memory performance
        items=trial_mem(submem(:,Mmem) == rem); % get the items
        if isempty(items);
        else
            for k=1:length(items)
                GRATE_ln(GRATE_ln(:,1)==subln(subln(:,MwID)==items(k),Mposit),6)=rem;
                subln(subln(:,MwID)==items(k),Mmem)=rem;%add memory performance
            end
            ln_cr(sub,rem)=sum(subln(subln(:,Mmem)==rem,Mscore))/length(items);
            ln_rt(sub,rem)=mean(subln((subln(:,Mmem)==rem),MRT));
            ln_grate_cr(sub,rem)=length(find(GRATE_ln(GRATE_ln(:,6)==rem,3)==1))/length(find(GRATE_ln(:,6)==rem));
            ln_grate_rt(sub,rem)=mean(GRATE_ln(GRATE_ln(:,6)==rem & GRATE_ln(:,3)==1,4));
        end%end if 
     end %end rem
%retrieval
     for rem=1:3 % memory performance
        items=trial_mem(submem(:,Mmem) == rem); % get the items
        if isempty(items);
        else
            for k=1:length(items)
                GRATE_mem(GRATE_mem(:,1)==submem(submem(:,MwID)==items(k),Mposit),6)=rem;
            end
            mem_cr(sub,rem)=sum(submem(submem(:,Mmem)==rem,Mscore))/length(items);
            mem_rt(sub,rem)=mean(submem((submem(:,Mmem)==rem),MRT));
            mem_grate_cr(sub,rem)=length(find(GRATE_mem(GRATE_mem(:,6)==rem,3)==1))/length(find(GRATE_mem(:,6)==rem));
            mem_grate_rt(sub,rem)=mean(GRATE_mem(GRATE_mem(:,6)==rem & GRATE_mem(:,3)==1,4));
        end%end if 
     end %end rem
    eval(sprintf('save %s/test_sub%02d.mat submem',labeldir,sub));
    eval(sprintf('save %s/encoding_sub%02d.mat subln',labeldir,sub));
end % end sub

save result mem_perf cate_perf cate_perf_rt ln_cr ln_rt ln_grate_cr ln_grate_rt mem_cr mem_rt mem_grate_cr mem_grate_rt
