function merge_all_sub_data()
basedir='/seastor/helenhelen/ISR_2015';
datadir=sprintf('%s/me/data/sub',basedir);
resultdir=sprintf('%s/me/data/item',basedir);
subs=setdiff(1:21,2);
ERS=[];
for s=subs
tERS=[];rERS=[];
	load(sprintf('%s/ERS_sub%02d.mat',datadir,s));
	for r=1:13
	rERS=[rERS squeeze(troi(:,r,:))];
	end
	tERS=[s*ones(96,1) [1:96]' rERS];
ERS=[ERS;tERS];
end
eval(sprintf('save %s/ERS.txt ERS -ascii -tabs', resultdir));
end
