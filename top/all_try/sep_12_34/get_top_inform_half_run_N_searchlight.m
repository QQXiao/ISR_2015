function get_top_information(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
infodir=sprintf('%s/top/tmap/data/value_based/searchlight',basedir);
datadir=sprintf('%s/data_singletrial/glm/all',basedir);
%%%%%%%%%
TN=192;
%subs=setdiff(1:21,2);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
vln_cln=[];vmem_cmem=[];
xlength =  112;
ylength =  112;
zlength =  64;
radius  =  2;     % the cubic size is (2*radius+1) by (2*radius+1) by (2*radius+1)
step    =  1;     % compute accuracy map for every STEP voxels in each dimension
epsilon =  1e-6;
for s=subs
tpln=[];tpln2=[];tpmem=[];tpmem2=[];
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);
        %get fMRI data                                        
        data_file=sprintf('%s/sub%02d.nii.gz',datadir,s);
        data_all=load_nii_zip(data_file);                     
        data=data_all.img;
	ss=size(data);
	pa=combntns([1:ss(4)],2);
	ss1=ss;ss1(4)=48;
	pln=zeros(ss1);
	pmem=zeros(ss1);
	%%analysis
        for k=1:ss(1)
            for j=1:ss(2)
                for i=1:ss(3)
                    tvdata = data(k,j,i,:); % define small cubic for memory data
		    vdata=tvdata(:);
		    ta=vdata';                                                         
                    b = diff([0 ta==0 0]);                                            
                    res = find(b==-1) - find(b==1);                                   
                    u=sum(res>=6);
		     if u >=1		
                    %if sum(std(v_data(:,:))==0)>epsilon
                    pln(k,j,i,:)=10;
                    pmem(k,j,i,:)=10;
                    else
			datav=vdata;	
			t_sub_ln=idx_ln_D;
			for n=1:length(t_sub_ln)
			t=pa(t_sub_ln(n),1);
			[tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
			coorv=datav(pa(:,1)).*datav(pa(:,2));
			t_coorv=coorv(tidx_ln_DB_all);
			 x=sum(coorv(tidx_ln_D)>t_coorv);
			pln(k,j,i,n)=(x)/length(tidx_ln_DB_all);
			end
			
	    
			t_sub_mem=idx_mem_D;
			for n=1:length(t_sub_mem)
			t=pa(t_sub_mem(n),1);
			[tidx_mem_D,tidx_mem_DB_wc,tidx_mem_DB_all,tidx_ln_D,tidx_ln_DB_wc,tidx_ln_DB_all]= get_idx_matrix(s,t);
			coorv=datav(pa(:,1)).*datav(pa(:,2));
			t_coorv=coorv(tidx_mem_DB_all);
			x=sum(coorv(tidx_mem_D)>t_coorv);
			pmem(k,j,i,n)=(x)/length(tidx_mem_DB_all);
			end %n
		    end %if
		end %i
	     end %j
	end %k
	cd(infodir)
	mpln=mean(pln,4);
	mpmem=mean(pmem,4);
        filename=sprintf('pmem_sub%02d.nii',s);                                                                                          
        data_all.img=squeeze(mpmem(:,:,:));                                                                                           
        data_all.hdr.dime.dim(5)=1; % dimension chagne to 3                                                                             
        save_untouch_nii(data_all, filename);                                                                                           
        system(sprintf('gzip -f %s',filename));                                                                                         
                                                                                                                                        
        filename=sprintf('pln_sub%02d.nii',s);                                                                                           
        data_all.img=squeeze(pln(:,:,:));                                                                                            
        data_all.hdr.dime.dim(5)=1; % dimension chagne to 3                                                                             
        save_untouch_nii(data_all, filename);                                                                                           
        system(sprintf('gzip -f %s',filename));    
end%sub
end %function
