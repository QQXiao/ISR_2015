function get_top_information(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
infodir=sprintf('%s/top/tmap/data/number_based_WB',basedir);

datadir=sprintf('%s/data_singletrial/glm/all',basedir);
vvcdir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
%%%%%%%%%
TN=192;
%subs=setdiff(1:21,2);
for s=subs
tpln1=[];tpln2=[];tpmem1=[];tpmem2=[];
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);
	u=[];
        %get fMRI data
	%VVCfile=sprintf('%s/sub%02d_VVC.txt',vvcdir,s);
	%tmp_VVC=load(VVCfile);
	%IPLfile=sprintf('%s/sub%02d_IPL.txt',vvcdir,s);
	%tmp_IPL=load(IPLfile);
	%IFGfile=sprintf('%s/sub%02d_IFG.txt',vvcdir,s);
	%tmp_IFG=load(IFGfile);
	%MFGfile=sprintf('%s/sub%02d_MFG.txt',vvcdir,s);
	%tmp_MFG=load(MFGfile);
	%PHGfile=sprintf('%s/sub%02d_PHG.txt',vvcdir,s);
	%tmp_PHG=load(PHGfile);
	%pTFfile=sprintf('%s/sub%02d_pTF.txt',vvcdir,s);
	%tmp_pTF=load(pTFfile);
	%aTFfile=sprintf('%s/sub%02d_aTF.txt',vvcdir,s);
	%tmp_aTF=load(aTFfile);
	%dLOCfile=sprintf('%s/sub%02d_dLOC.txt',vvcdir,s);
	%tmp_dLOC=load(dLOCfile);

	%ttvvc_all=[tmp_VVC(:,1:end) tmp_IPL(:,1:end) tmp_IFG(:,1:end) tmp_MFG(:,1:end) tmp_PHG(:,1:end) tmp_pTF(:,1:end) tmp_aTF(:,1:end) tmp_dLOC(:,1:end)];
	 WBfile=sprintf('%s/sub%02d_WB.txt',vvcdir,s);
        tmp_WB=load(WBfile);
	ttvvc_all=tmp_WB(:,1:end); 
	ttvvc=ttvvc_all(4:end,:);
	size_all=size(ttvvc,2);
	for j=1:size_all
                a=ttvvc(:,j);
                ta=a';
                b = diff([0 a'==0 0]);
                res = find(b==-1) - find(b==1);
                u(j)=sum(res>=6);
        end %j
	ttvvc(:,find(u>=1))=[];
	ttvvc_all(:,find(u>=1))=[];
    	tvvc=(ttvvc)';
	zvvc=zscore(tvvc);
	vvc=zvvc';
	ss=size(vvc);
	pa=combntns([1:ss(1)],2);

	t_sub_I=idx_ERS_I;
	n1=1;n2=1;
	for n=1:length(t_sub_I)
	t=pa(t_sub_I(n),1);
	[tidx_ERS_I,tidx_ERS_IB_all,tidx_ERS_IB_wc,tidx_ERS_D,tidx_ERS_DB_all,tidx_ERS_DB_wc,list_pid]=get_idx_item_ERS(s,t)	
	for v=1:ss(2)
		data_voxel=vvc(:,v);
		datav=data_voxel(:);
		coorv=datav(pa(:,1)).*datav(pa(:,2));
		t_coorv=coorv(tidx_ERS_IB_all);
       		 x=sum(coorv(tidx_ERS_I)>t_coorv);
			if t<=48
			tpERS1(v,n1)=(x)/length(tidx_ERS_IB_all);
			else
			tpERS2(v,n2)=(x)/length(tidx_ERS_IB_all);
			end
		end%voxel
		if t<=48
			n1=n1+1;
		else
			n2=n2+1;
		end %if
	end %nI
	pERS1=mean(tpERS1,2);
	pERS2=mean(tpERS2,2);
        for pn=[0:5:95 96:1:99 99.1 99.2 99.3 99.4 99.5 99.6 99.7 99.8 99.9] 
		for h=1:2
		eval(sprintf('pERS=pERS%d;',h));
        	ERS_pn=prctile(pERS,pn);
        	vERS=find(pERS>=ERS_pn);
        	data_vERS=ttvvc(:,vERS);
        	data_cvERS=ttvvc_all(:,vERS);
		if pn <= 99
        	file_name=sprintf('%s/p%d_ERSI_sub%02d_h%d.mat',infodir,pn,s,h);
        	eval(sprintf('save %s data_vERS',file_name));
        	file_name=sprintf('%s/p%d_ERSI_sub%02d_withc_h%d.mat',infodir,pn,s,h);
        	eval(sprintf('save %s data_cvERS',file_name)); 
		else
		file_name=sprintf('%s/p%.1f_ERSI_sub%02d_h%d.mat',infodir,pn,s,h);                                          
                eval(sprintf('save %s data_vERS',file_name));                                                             
                file_name=sprintf('%s/p%.1f_ERSI_sub%02d_withc_h%d.mat',infodir,pn,s,h);                                    
                eval(sprintf('save %s data_cvERS',file_name)); 
		end
		end %half
	end %pn

	t_sub_D=idx_ERS_D;
	n1=1;n2=1;
	for n=1:length(t_sub_D)
	t=pa(t_sub_D(n),1);
		[tidx_ERS_I,tidx_ERS_IB_all,tidx_ERS_IB_wc,tidx_ERS_D,tidx_ERS_DB_all,tidx_ERS_DB_wc,list_pid]=get_idx_item_ERS(s,t)
		for v=1:ss(2)
		data_voxel=vvc(:,v);
		datav=data_voxel(:);
		coorv=datav(pa(:,1)).*datav(pa(:,2));
		t_coorv=coorv(tidx_ERS_DB_all);
       		 x=sum(coorv(tidx_ERS_D)>t_coorv);
			if t<=48
			tpERS1(v,n1)=(x)/length(tidx_ERS_DB_all);
			else
			tpERS2(v,n2)=(x)/length(tidx_ERS_DB_all);
			end
		end%voxel
		if t<=48
			n1=n1+1;
		else
			n2=n2+1;
		end
	end %D
	pERS1=mean(tpERS1,2);
	pERS2=mean(tpERS2,2);
	for pn=[0:5:95 96:1:99 99.1 99.2 99.3 99.4 99.5 99.6 99.7 99.8 99.9] 
        %for pn=[0:5:95 96:1:99 99.1 99.2 99.3 99.4 99.5]
		for h=1:2
		eval(sprintf('pERS=pERS%d;',h));
        	ERS_pn=prctile(pERS,pn);
        	vERS=find(pERS>=ERS_pn);
        	data_vERS=ttvvc(:,vERS);
        	data_cvERS=ttvvc_all(:,vERS);
		if pn <= 99
        	file_name=sprintf('%s/p%d_ERSD_sub%02d_h%d.mat',infodir,pn,s,h);
        	eval(sprintf('save %s data_vERS',file_name));
        	file_name=sprintf('%s/p%d_ERSD_sub%02d_withc_h%d.mat',infodir,pn,s,h);
        	eval(sprintf('save %s data_cvERS',file_name)); 
		else
		file_name=sprintf('%s/p%.1f_ERSD_sub%02d_h%d.mat',infodir,pn,s,h);                                          
                eval(sprintf('save %s data_vERS',file_name));                                                             
                file_name=sprintf('%s/p%.1f_ERSD_sub%02d_withc_h%d.mat',infodir,pn,s,h);                                    
                eval(sprintf('save %s data_cvERS',file_name)); 
		end
		end %half
	end %pn
end%sub
end %function
