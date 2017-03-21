function merge_all_sub_data()
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/me/tmap/data/sub',basedir);
resultdir=sprintf('%s/me/tmap/data/item',basedir);
subs=setdiff(1:21,2);
mem=[];ln=[];ERS=[];
roi_name={'p97',...
'LVVC','LANG','LSMG','LIFG','LMFG',...
'RVVC','RANG','RSMG','RIFG','RMFG',...
'LaPHG','LpPHG','RaPHG','RpPHG',...
'HIP','CA1','CA2','DG','CA3','subiculum','ERC','PRC','pPHG'}
for s=subs
tln=[];rln=[];
tERS=[];rERS=[];
tmem=[];rmem=[];
	load(sprintf('%s/ln_sub%02d.mat',datadir,s));
	load(sprintf('%s/mem_sub%02d.mat',datadir,s));
	load(sprintf('%s/ERS_sub%02d.mat',datadir,s));
	for r=2:length(roi_name)
	rln=[rln squeeze(roi_ln(:,r,:))];
	rmem=[rmem squeeze(roi_mem(:,r,:))];
	rsad=squeeze(troi(:,r,8))-squeeze(troi(:,r,9))
	lnactm=(squeeze(troi(:,r,1))+squeeze(troi(:,r,2)))/2
	memactm=(squeeze(troi(:,r,3))+squeeze(troi(:,r,4)))/2
	rERS=[rERS squeeze(troi(:,r,[1:4 8 9])) lnactm memactm rsad];
	end
	tERS=[s*ones(48,1) [1:48]' rERS];
	tln=[s*ones(48,1) [1:48]' rln];
	tmem=[s*ones(48,1) [1:48]' rmem];
ERS=[ERS;tERS];
ln=[ln;tln];
mem=[mem;tmem];
end
eval(sprintf('save %s/ERS.txt ERS -ascii -tabs', resultdir));
eval(sprintf('save %s/ln.txt ln -ascii -tabs', resultdir));
eval(sprintf('save %s/mem.txt mem -ascii -tabs', resultdir));
end
