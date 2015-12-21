function caulate_ps_matrix_p95(subs)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/gitrepo/ISR_2015/behav
datadir=sprintf('%s/me/data/roi',basedir);
psdir=sprintf('%s/me/data/ps_matrix',basedir);
condname={'ln','mem'};
%%%%%%%%%
for s=subs
[idx_ERS_I,idx_ERS_IB_all,idx_ERS_IB_wc,idx_ERS_D,idx_ERS_DB_all,idx_ERS_DB_wc,idx_mem_D,idx_mem_DB_all,idx_mem_DB_wc,idx_ln_D,idx_ln_DB_all,idx_ln_DB_wc,m_ln,m_mem]= get_idx(s);
	for c=1:2
                xx=[];tmp_xx=[];
                load(sprintf('%s/p90_%s_sub%02d.mat',datadir,condname{c},s));
                eval(sprintf('tmp_xx=data_v%s;',condname{c}));
		xx=tmp_xx(:,:);
                %%analysis
                data_ln=xx(1:96,:);
                data_mem=xx(97:end,:);
                    yy11=data_ln([1:24],:);yy12=data_ln([25:48],:);yy21=data_ln([49:72],:);yy22=data_ln([73:96],:);
                    p_ln_11=m_ln([1:24],:);p_ln_12=m_ln([25:48],:);p_ln_21=m_ln([49:72],:);p_ln_22=m_ln([73:96],:);
                    zz11=data_mem([1:24],:);zz12=data_mem([25:48],:);zz21=data_mem([49:72],:);zz22=data_mem([73:96],:);
                    p_mem_11=m_mem([1:24],:);p_mem_12=m_mem([25:48],:);p_mem_21=m_mem([49:72],:);p_mem_22=m_mem([73:96],:);

                    tyy11=[yy11,p_ln_11];a=size(tyy11);ttyy11=sortrows(tyy11,a(2));data_ln_11=ttyy11(:,[1:end-1]);
                    tyy12=[yy12,p_ln_12];a=size(tyy12);ttyy12=sortrows(tyy12,a(2));data_ln_12=ttyy12(:,[1:end-1]);
                    tyy21=[yy21,p_ln_21];a=size(tyy21);ttyy21=sortrows(tyy21,a(2));data_ln_21=ttyy21(:,[1:end-1]);
                    tyy22=[yy22,p_ln_22];a=size(tyy22);ttyy22=sortrows(tyy22,a(2));data_ln_22=ttyy22(:,[1:end-1]);
                    data_ln_all=[data_ln_11;data_ln_12;data_ln_21;data_ln_22];

                    tzz11=[zz11,p_mem_11];a=size(tzz11);ttzz11=sortrows(tzz11,a(2));data_mem_11=ttzz11(:,[1:end-1]);
                    tzz12=[zz12,p_mem_12];a=size(tzz12);ttzz12=sortrows(tzz12,a(2));data_mem_12=ttzz12(:,[1:end-1]);
                    tzz21=[zz21,p_mem_21];a=size(tzz21);ttzz21=sortrows(tzz21,a(2));data_mem_21=ttzz21(:,[1:end-1]);
                    tzz22=[zz22,p_mem_22];a=size(tzz22);ttzz22=sortrows(tzz22,a(2));data_mem_22=ttzz22(:,[1:end-1]);
                    data_mem_all=[data_mem_11;data_mem_12;data_mem_21;data_mem_22];

                    data_all=[data_ln_all;data_mem_all];
                    cc_all=1-pdist(data_all(:,:),'correlation');                                                                                                         
                    tcc_all=squareform(cc_all);                                                                                                                          	
		tl=[tcc_all([1:24],[73:96]);tcc_all([25:48],[49:72])];                                                                                           	    
		cc_ln_ln(:)=tl(:);
		tm=[tcc_all(96+[1:24],96+[73:96]);tcc_all(96+[25:48],96+[49:72])]; 
		cc_mem_mem(:)=tm(:);             		
        file_name=sprintf('%s/%s_top90_mps_ln_sub%02d',psdir,condname{c},s);
        eval(sprintf('save %s cc_ln_ln',file_name));
        file_name=sprintf('%s/%s_top90_mps_mem_sub%02d',psdir,condname{c},s);
        eval(sprintf('save %s cc_mem_mem',file_name));
end %end for
end %end function
