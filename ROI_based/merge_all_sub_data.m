function merge_all_sub_data()
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/me/data/sub',basedir);
resultdir=sprintf('%s/me/data/item',basedir);
subs=setdiff(1:21,2);
rois=[1:13]';
ln=[];mem=[]
for s=subs
	load(sprintf('%s/mem_sub%02d.mat',datadir,s);
	load(sprintf('%s/ln_sub%02d.mat',datadir,s);
	for t=1:48
	tln=[];tmem=[]
	tln=[s*ones(13,1) rois squeeze(roi_ln(t,:,:))];
	tmem=[s*ones(13,1) rois squeeze(roi_mem(t,:,:))];
	ln=[ln;tln];mem=[mem;tmem];
	end
end
eval(sprintf('save %s/mem.txt mem -ascii -tabs', resultdir));
eval(sprintf('save %s/ln.txt ln -ascii -tabs', resultdir));
end
