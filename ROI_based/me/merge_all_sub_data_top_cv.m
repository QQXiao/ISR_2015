function merge_all_sub_data()
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/me/tmap/data/value_based/sub',basedir);
resultdir=sprintf('%s/me/tmap/data/value_based/item',basedir);
subs=setdiff(1:21,2);
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

all_sln=[];all_smem=[];
all_dln=[];all_dmem=[];
labeldir='/seastor/helenhelen/ISR_2015/behav/label';
for s=subs
	sln=zeros(48,19);smem=zeros(48,19);
	dln=zeros(48,19);dmem=zeros(48,19);
	tln=[];tmem=[];
	rln1=[];rmem1=[]
	rln2=[];rmem2=[]
	load(sprintf('%s/mem_sub%02d_h1.mat',datadir,s));
	mem1=roi_mem;
	load(sprintf('%s/mem_sub%02d_h2.mat',datadir,s));
	mem2=roi_mem;
	load(sprintf('%s/ln_sub%02d_h1.mat',datadir,s));
	ln1=roi_ln;
	load(sprintf('%s/ln_sub%02d_h2.mat',datadir,s));
	ln2=roi_ln;
	load(sprintf('%s/test_sub%02d.mat',labeldir,s));
	al=sortrows(submem,[MpID Mposit]);
	al1=al(1:2:end,:);
	al2=al(2:2:end,:);
	ll=2*ones(48,1);
	ll(al1(:,Mmem)==1 & al2(:,Mmem)==1)=1;
	ll(al1(:,Mmem)==3 | al2(:,Mmem)==3)=3;
	l=[al1(:,[MpID Mposit]) ll];
	for r=1:5
	rln1=[rln1 squeeze(ln1(:,r,:))];
	rln2=[rln2 squeeze(ln2(:,r,:))];
	rmem1=[rmem1 squeeze(mem1(:,r,:))];
	rmem2=[rmem2 squeeze(mem2(:,r,:))];
	end	
	tln1=[s*ones(48,1) l rln1];
	tln2=[s*ones(48,1) l rln2];
	tmem1=[s*ones(48,1) l rmem1];
	tmem2=[s*ones(48,1) l rmem2];
	tln1=sortrows(tln1,3);
	tln2=sortrows(tln2,3);
	tmem1=sortrows(tmem1,3);
	tmem2=sortrows(tmem2,3);
	dln(1:24,:)=tln2(1:24,:); 
	dln(25:end,:)=tln1(25:end,:); 
	dmem(1:24,:)=tmem2(1:24,:); 
	dmem(25:end,:)=tmem1(25:end,:); 
	sln(1:24,:)=tln1(1:24,:); 
	sln(25:end,:)=tln2(25:end,:); 
	smem(1:24,:)=tmem1(1:24,:); 
	smem(25:end,:)=tmem2(25:end,:); 
	all_sln=[all_sln;sln];
	all_smem=[all_smem;smem];
	all_dln=[all_dln;dln];
	all_dmem=[all_dmem;dmem];
end
eval(sprintf('save %s/all_mem_same.txt all_smem -ascii -tabs', resultdir));
eval(sprintf('save %s/all_ln_same.txt all_sln -ascii -tabs', resultdir));
eval(sprintf('save %s/all_mem_diff.txt all_dmem -ascii -tabs', resultdir));
eval(sprintf('save %s/all_ln_diff.txt all_dln -ascii -tabs', resultdir));
end
