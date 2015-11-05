function get_peak_up_sep_run2(c)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/merged',basedir);

condname={'ERS_IBwc','ERS_DBwc','mem_DBwc','ln_DBwc'}
%%%%%%%%%
radius=3;
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
vvcdir=sprintf('%s/peak/VVC/data/vvc_data/sep_run/run2/%s',basedir,condname{c});
resultdir=sprintf('%s/peak/VVC/data/peak/sep_run/run2/%s',basedir,condname{c});
mkdir(resultdir);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
coords=[];tcoords=[];
kmax=112-radius;jmax=112-radius;imax=64-radius

for s=subs;
[idx_ERS_I1,idx_ERS_IB_all1,idx_ERS_IB_wc1,idx_ERS_D1,idx_ERS_DB_all1,idx_ERS_DB_wc1,idx_mem_D1,idx_mem_DB_all1,idx_mem_DB_wc1,idx_ln_D1,idx_ln_DB_all1,idx_ln_DB_wc1] = get_idx_sep_run(s,1);
[idx_ERS_I2,idx_ERS_IB_all2,idx_ERS_IB_wc2,idx_ERS_D2,idx_ERS_DB_all2,idx_ERS_DB_wc2,idx_mem_D2,idx_mem_DB_all2,idx_mem_DB_wc2,idx_ln_D2,idx_ln_DB_all2,idx_ln_DB_wc2] = get_idx_sep_run(s,2);
        %get fMRI data
        data_file=sprintf('%s/sub%02d.nii.gz',datadir,s);
        data_all=load_nii_zip(data_file);
        data=data_all.img;

	    vvcfile=sprintf('%s/sub%02d.nii.gz',vvcdir,s);
	    vvc_all=load_nii_zip(vvcfile);
	    vvc=vvc_all.img;
	    ss=size(vvc);
	    flag=1;
	    runtime=0;
	    tvvc=vvc;
	while flag
		max_vvc=max(tvvc(:));
		lmax=find(vvc==max_vvc);
		tlmax=find(tvvc==max_vvc);
		[k,j,i]=ind2sub(ss,lmax);
		tcoords(s,:)=[k,j,i];
		%remove max
		tvvc(tlmax)=[];

		if k<=kmax & j<=jmax & i<=imax
 		%define small cubic for memory data
		data_balls=vvc(k-radius:k+radius,j-radius:j+radius,i-radius:i+radius,:);
        a=size(data_balls);
        b=a(1)*a(2)*a(3);
		p=sum(find(data_balls)>=0.01)/b

            if p>=0.9
		    data_ball=data(k-radius:k+radius,j-radius:j+radius,i-radius:i+radius,:);
		    v_data = reshape(data_ball,b,TN);
		    xx=v_data';
       	    tcc=1-pdist(xx(:,:),'correlation');
       	    cc=0.5*(log(1+tcc)-log(1-tcc));
		    ERS_z1(s,1)=mean(cc(idx_ERS_I1));
            ERS_z1(s,2)=mean(cc(idx_ERS_IB_wc1));
            ERS_z1(s,3)=mean(cc(idx_ERS_IB_all1));
            ERS_z1(s,4)=mean(cc(idx_ERS_D1));
	        ERS_z1(s,5)=mean(cc(idx_ERS_DB_wc1));
       	    ERS_z1(s,6)=mean(cc(idx_ERS_DB_all1));

            mem_z1(s,1)=mean(cc(idx_mem_D1));
            mem_z1(s,2)=mean(cc(idx_mem_DB_wc1));
            mem_z1(s,3)=mean(cc(idx_mem_DB_all1));

       	    ln_z1(s,1)=mean(cc(idx_ln_D1));
      	    ln_z1(s,2)=mean(cc(idx_ln_DB_wc1));
	        ln_z1(s,3)=mean(cc(idx_ln_DB_all1));

		    ERS_z2(s,1)=mean(cc(idx_ERS_I2));
            ERS_z2(s,2)=mean(cc(idx_ERS_IB_wc2));
            ERS_z2(s,3)=mean(cc(idx_ERS_IB_all2));
            ERS_z2(s,4)=mean(cc(idx_ERS_D2));
	        ERS_z2(s,5)=mean(cc(idx_ERS_DB_wc2));
       	    ERS_z2(s,6)=mean(cc(idx_ERS_DB_all2));

            mem_z2(s,1)=mean(cc(idx_mem_D2));
            mem_z2(s,2)=mean(cc(idx_mem_DB_wc2));
            mem_z2(s,3)=mean(cc(idx_mem_DB_all2));

       	    ln_z2(s,1)=mean(cc(idx_ln_D2));
      	    ln_z2(s,2)=mean(cc(idx_ln_DB_wc2));
	        ln_z2(s,3)=mean(cc(idx_ln_DB_all2));

		    flag=0;
            runtime = runtime + 1
		    else
		    runtime = runtime + 1
		    end %if
        else
        runtime = runtime + 1
        end %if
		if runtime >= 100000
            flag = 0;
            break;
        end
	end %while
end%sub
	ERS1=[subs' ERS_z1(subs,:)];mem1=[subs' mem_z1(subs,:)];ln1=[subs' ln_z1(subs,:)];coords=[subs' tcoords(subs',:)];
	ERS2=[subs' ERS_z2(subs,:)];mem2=[subs' mem_z2(subs,:)];ln2=[subs' ln_z2(subs,:)];
	file_name=sprintf('%s/ERS1.txt', resultdir);
	eval(sprintf('save %s ERS1 -ascii',file_name));
    file_name=sprintf('%s/mem1.txt', resultdir);
    eval(sprintf('save %s mem1 -ascii',file_name));
    file_name=sprintf('%s/ln1.txt', resultdir);
    eval(sprintf('save %s ln1 -ascii',file_name));
	file_name=sprintf('%s/ERS2.txt', resultdir);
	eval(sprintf('save %s ERS2 -ascii',file_name));
    file_name=sprintf('%s/mem2.txt', resultdir);
    eval(sprintf('save %s mem2 -ascii',file_name));
    file_name=sprintf('%s/ln2.txt', resultdir);
    eval(sprintf('save %s ln2 -ascii',file_name));
    file_name=sprintf('%s/coordinate.txt', resultdir);
    eval(sprintf('save %s coords -ascii',file_name));
%end %end c
end %function
