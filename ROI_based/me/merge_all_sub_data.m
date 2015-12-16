function merge_all_sub_data()
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/me/data/sub',basedir);
resultdir=sprintf('%s/me/data/item',basedir);
subs=setdiff(1:21,2);
ln=[];mem=[]
for s=subs
tln=[];tmem=[];
	rln=[];rmem=[]
	load(sprintf('%s/mem_sub%02d.mat',datadir,s));
	load(sprintf('%s/ln_sub%02d.mat',datadir,s));
	for r=1:15
	rln=[rln squeeze(roi_ln(:,r,:))];
	rmem=[rmem squeeze(roi_mem(:,r,:))];
	end
	tln=[s*ones(48,1) [1:48]' rln];
	tmem=[s*ones(48,1) [1:48]' rmem];
ln=[ln;tln]; mem=[mem;tmem];
end
eval(sprintf('save %s/mem.txt mem -ascii -tabs', resultdir));
eval(sprintf('save %s/ln.txt ln -ascii -tabs', resultdir));
end
