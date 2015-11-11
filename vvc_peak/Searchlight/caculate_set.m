function caculate_set(c,nt)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/vvc_peak
datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/merged2',basedir);

condname={'ERS_IBwc','ERS_DBwc','mem_DBwc','ln_DBwc'}
%%%%%%%%%
xlength =  112;
ylength =  112;
zlength =  64;
radius=3;
step=1;     % compute accuracy map for every STEP voxels in each dimension                                                                                          eps
epsilon=1e-6;
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
resultdir=sprintf('%s/peak/VVC/data/top/ps/Searchlignt/%s/set/r',basedir,condname{c});
lndir=sprintf('%s/peak/VVC/data/top/ps/set/%s',basedir,condname{c});
%mkdir(resultdir);
%nt=200;

for s=subs;
mem_r_diff=zeros(xlength,ylength,zlength,1);
ln_r_diff=zeros(xlength,ylength,zlength,1);
mem_r_same=zeros(xlength,ylength,zlength,1);
ln_r_same=zeros(xlength,ylength,zlength,1);
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);
        %get fMRI data
        data_file=sprintf('%s/sub%02d.nii.gz',datadir,s);
        data_all=load_nii_zip(data_file);
        data=data_all.img;
        %get encoding materail similarity matrix
        ln_file1=sprintf('%s/Mrln_%d_sub%02d_set1.mat', lndir,nt,s);
        load(ln_file1); ln_set1=ln_tcc1;
        ln_file2=sprintf('%s/Mrln_%d_sub%02d_set2.mat', lndir,nt,s);
        load(ln_file2); ln_set2=ln_tcc2;
    %%analysis
    for k=radius+1:step:xlength-radius
        for j=radius+1:step:ylength-radius
            for i=radius+1:step:zlength-radius
                data_ball = data(k-radius:k+radius,j-radius:j+radius,i-radius:i+radius,:); % define small cubic for memory data)
                a=size(data_ball);
                b=a(1)*a(2)*a(3);
                v_data = reshape(data_ball,b,TN);
                if sum(std(v_data(:,:))==0)>epsilon
                    mem_r(k,j,i,:)=10;
                    ln_r(k,j,i,:)=10;
                else
                    xx=v_data';
                    data_ln=xx(1:96,:);
                    data_mem=xx(97:end,:);
		    yy1=data_ln([1:24 49:72],:);
                    m_ln_1=m_ln([1:24 49:72],:);                                                                                                   
                    tyy1=[yy1,m_ln_1];a=size(tyy1);ttyy1=sortrows(tyy1,a(2));data_ln_set1=ttyy1(:,[1:end-1]);                                                      

		    yy2=data_ln([25:48 73:96],:);
                    m_ln_2=m_ln([25:48 73:96],:);                                                                                                  
                    tyy2=[yy2,m_ln_2];a=size(tyy2);ttyy2=sortrows(tyy2,a(2));data_ln_set2=ttyy2(:,[1:end-1]);                                                      

                    tcc_ln_set1=1-pdist(data_ln_set1(:,:),'correlation');
                    tcc_ln_set2=1-pdist(data_ln_set2(:,:),'correlation');
		    zz1=data_mem([1:24 49:72],:);
                    m_mem_1=m_mem([1:24 49:72],:);                                                                                                 
                    tzz1=[zz1,m_mem_1];a=size(tzz1);ttzz1=sortrows(tzz1,a(2));data_mem_set1=ttzz1(:,[1:end-1]);                                                    
		    
		    zz2=data_mem([25:48 73:96],:);
                    m_mem_2=m_mem([25:48 73:96],:);                                                                                                
                    tzz2=[zz2,m_mem_2];a=size(tzz2);ttzz2=sortrows(tzz2,a(2));data_mem_set2=ttzz2(:,[1:end-1]);                                                    

                    tcc_mem_set1=1-pdist(data_mem_set1(:,:),'correlation');
                    tcc_mem_set2=1-pdist(data_mem_set2(:,:),'correlation');
		    for set=1:2; %
                    cc_encoding_ln_same(s)=eval(sprintf('1-pdist([ln_set%d;tcc_ln_set%d],''correlation'')',set,set));
                    cc_encoding_mem_same(s)=eval(sprintf('1-pdist([ln_set%d;tcc_mem_set%d],''correlation'')',set,set));
                    cc_encoding_ln_diff(s)=eval(sprintf('1-pdist([ln_set%d;tcc_ln_set%d],''correlation'')',set,3-set));
                    cc_encoding_mem_diff(s)=eval(sprintf('1-pdist([ln_set%d;tcc_mem_set%d],''correlation'')',set,3-set));
		    end
                    ln_r_same(k,j,i)=mean(cc_encoding_ln_same);
                    mem_r_same(k,j,i)=mean(cc_encoding_mem_same);
                    ln_r_diff(k,j,i)=mean(cc_encoding_ln_diff);
                    mem_r_diff(k,j,i)=mean(cc_encoding_mem_diff);
                end
            end %i
        end %j
    end %k
        filename=sprintf('%s/mem_same_sub%02d_%d.nii', resultdir,s,nt);
        data_all.img=squeeze(mem_r_same(:,:,:,:));
        data_all.hdr.dime.dim(5)=1; % dimension chagne to 1
        save_untouch_nii(data_all, filename);
        system(sprintf('gzip -f %s',filename));

        filename=sprintf('%s/mem_diff_sub%02d_%d.nii', resultdir,s,nt);
        data_all.img=squeeze(mem_r_diff(:,:,:,:));                                                                         
        data_all.hdr.dime.dim(5)=1; % dimension chagne to 1                                                                
        save_untouch_nii(data_all, filename);                                                                              
        system(sprintf('gzip -f %s',filename));

        filename=sprintf('%s/ln_same_sub%02d_%d.nii', resultdir,s,nt);                                                   
        data_all.img=squeeze(ln_r_same(:,:,:,:));                                                                        
        data_all.hdr.dime.dim(5)=1; % dimension chagne to 1                                                              
        save_untouch_nii(data_all, filename);                                                                            
        system(sprintf('gzip -f %s',filename)); 

        filename=sprintf('%s/ln_diff_sub%02d_%d.nii', resultdir,s,nt);
        data_all.img=squeeze(ln_r_diff(:,:,:,:));
        data_all.hdr.dime.dim(5)=1; % dimension chagne to 1
        save_untouch_nii(data_all, filename);
        system(sprintf('gzip -f %s',filename));
end %end sub
end %function
