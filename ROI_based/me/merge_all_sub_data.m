function merge_all_sub_data()
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/me/tmap/data/sub',basedir);
resultdir=sprintf('%s/me/tmap/data/item',basedir);
subs=setdiff(1:21,2);
ln=[];mem=[]
%%%%%%%%%%%%%
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
Mmem=15;%1=hit;2=wrong;3=miss response;
Msub=16;
Mphase=17;
%%%%%%%%%%%%
labeldir='/seastor/helenhelen/ISR_2015/behav/label';
for s=subs
tln=[];tmem=[];
	rln=[];rmem=[]
	load(sprintf('%s/mem_sub%02d.mat',datadir,s));
	load(sprintf('%s/ln_sub%02d.mat',datadir,s));
        load(sprintf('%s/test_sub%02d.mat',labeldir,s));     
        al=sortrows(submem,[MpID Monset]);                   
        al1=al(1:2:end,:);                                   
        al2=al(2:2:end,:);                                   
        ll=2*ones(48,1);                                     
        ll(al1(:,Mmem)==1 & al2(:,Mmem)==1)=1;               
        ll(al1(:,Mmem)==3 | al2(:,Mmem)==3)=3;               
        l=[al1(:,MpID) ll];
	for r=1:14
	rln=[rln squeeze(roi_ln(:,r,:))];
	rmem=[rmem squeeze(roi_mem(:,r,:))];
	end
	tln=[s*ones(48,1) l rln];
	tmem=[s*ones(48,1) l rmem];
ln=[ln;tln]; mem=[mem;tmem];
end
eval(sprintf('save %s/mem.txt mem -ascii -tabs', resultdir));
eval(sprintf('save %s/ln.txt ln -ascii -tabs', resultdir));
end
