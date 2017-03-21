function get_top_information(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
infodir=sprintf('%s/top/tmap/data/value_based/sep_roi',basedir);

datadir=sprintf('%s/data_singletrial/glm/all',basedir);
vvcdir=sprintf('%s/ROI_based/ref_space/glm/raw',basedir);
%%%%%%%%%
TN=192;
%subs=setdiff(1:21,2);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
vln_cln=[];vmem_cmem=[];
subs
roi_name={'VVC','FPC'};
for s=subs
tpln1=[];tpln2=[];tpmem1=[];tpmem2=[];
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);
	u=[];
        %get fMRI data
	VVCfile=sprintf('%s/sub%02d_VVC.txt',vvcdir,s);
	tmp_VVC=load(VVCfile);
	IPLfile=sprintf('%s/sub%02d_IPL.txt',vvcdir,s); 
	tmp_IPL=load(IPLfile);
	IFGfile=sprintf('%s/sub%02d_IFG.txt',vvcdir,s); 
	tmp_IFG=load(IFGfile); 
	MFGfile=sprintf('%s/sub%02d_MFG.txt',vvcdir,s);
	tmp_MFG=load(MFGfile);
	for roi=1:length(roi_name);                           
        u=[]; 
                %get fMRI data
                if roi==1
                        ttvvc_all=[tmp_VVC(:,1:end)];
                else
                        ttvvc_all=[tmp_IPL(:,1:end) tmp_IFG(:,1:end) tmp_MFG(:,1:end)];
                end	
	ttvvc=ttvvc_all(4:end,:);
	size_all=size(ttvvc,2);
	for j=1:size_all
                a=ttvvc(:,j);
                ta=a';
                b = diff([0 a'==0 0]);
                res = find(b==-1) - find(b==1);
                u(j)=sum(res>=6);
        end
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
        [tidx_ERS_I,tidx_ERS_IB_all,tidx_ERS_D,tidx_ERS_DB_all]=get_idx_matrix_ERS(s,t);
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
       for pn=[0:5:95 96:1:99]
                for h=1:2
                eval(sprintf('pERS=pERS%d;',h));
                tpERS=unique(pERS);
                ERS_pn=prctile(tpERS,pn);
                vERS=find(pERS>=ERS_pn);
                data_vERS=ttvvc(:,vERS);                                              
                data_cvERS=ttvvc_all(:,vERS);
                file_name=sprintf('%s/%s_p%d_ERSI_sub%02d_h%d',infodir,roi_name{roi},pn,s,h);          
                eval(sprintf('save %s data_vERS',file_name));                         
                file_name=sprintf('%s/%s_p%d_ERSI_sub%02d_withc_h%d',infodir,roi_name{roi},pn,s,h);    
                eval(sprintf('save %s data_cvERS',file_name));                        
                end %half                                                             
        end %pn                                                                       
                                                                                      
        t_sub_D=idx_ERS_D;                                                            
        n1=1;n2=1;                                                                    
        for n=1:length(t_sub_D)                                                       
        t=pa(t_sub_D(n),1);                                                           
        [tidx_ERS_I,tidx_ERS_IB_all,tidx_ERS_D,tidx_ERS_DB_all]=get_idx_matrix_ERS(s,t);
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
        for pn=[0:5:95 96:1:99]                                                       
                for h=1:2                                                             
                eval(sprintf('pERS=pERS%d;',h));                                      
                tpERS=unique(pERS);                                                   
                ERS_pn=prctile(tpERS,pn);                                             
                vERS=find(pERS>=ERS_pn);                                              
                data_vERS=ttvvc(:,vERS);                                              
                data_cvERS=ttvvc_all(:,vERS);                                         
                file_name=sprintf('%s/%s_p%d_ERSD_sub%02d_h%d',infodir,roi_name{roi},pn,s,h);          
                eval(sprintf('save %s data_vERS',file_name));                         
                file_name=sprintf('%s/%s_p%d_ERSD_sub%02d_withc_h%d',infodir,roi_name{roi},pn,s,h);    
                eval(sprintf('save %s data_cvERS',file_name));                        
                end %half                                                             
        end %pn    
end %roi                                                                   
end%sub                                                                               
end %function                    
