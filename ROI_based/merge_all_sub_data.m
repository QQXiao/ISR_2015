function merge_all_sub_data()
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/me/data/sub',basedir);
resultdir=sprintf('%s/me/data/item',basedir);
subs=setdiff(1:21,2);
ln=[];mem=[]
for s=subs
	tln=[];tmem=[]
	load(sprintf('%s/mem_sub%02d.mat',datadir,s));
	load(sprintf('%s/ln_sub%02d.mat',datadir,s));
	for r=1:13
	tln=[tln squeeze(roi_ln(:,r,:))];
	tmem=[tmem squeeze(roi_mem(:,r,:))];
	end
	ln=[s*ones(48,1) [1:48]' tln];
	mem=[s*ones(48,1) [1:48]' tmem];
end
eval(sprintf('save %s/mem.txt mem -ascii -tabs', resultdir));
eval(sprintf('save %s/ln.txt ln -ascii -tabs', resultdir));
end
