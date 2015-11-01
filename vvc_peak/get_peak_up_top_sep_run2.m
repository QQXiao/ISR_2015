function get_peak_up_top_sep_run2(c)
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
resultdir=sprintf('%s/peak/VVC/data/top/coordinate/sep_run_run2',basedir);
mkdir(resultdir);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
coords=[];tcoords=[];
kmax=112-radius;jmax=112-radius;imax=64-radius
nt=50; %100; 200; 500; 1000
for s=subs;
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
	    t=1;
	while flag
		max_vvc=max(tvvc(:));
		lmax=find(vvc==max_vvc);
		tlmax=find(tvvc==max_vvc);
		[k,j,i]=ind2sub(ss,lmax);
		%remove max
		tvvc(tlmax)=[];
		if k<=kmax & j<=jmax & i<=imax
 		%define small cubic for memory data
		data_balls=vcc(k-radius:k+radius,j-radius:j+radius,i-radius:i+radius,:);
        a=size(data_balls);
        b=a(1)*a(2)*a(3)*a(4);
		p=sum(find(data_balls)>=0.01)/b

            if p>=0.9
			tcoords(s,t,:)=[k,j,i];
			t=t+1
			else
			runtime = runtime + 1
			end %if
	    else
        runtime = runtime + 1
        end %if
		if t==nt | runtime >= 100000
            	flag = 0;
            	break;
        	end
	end %while
end%sub
        file_name=sprintf('%s/%s_%d.mat', resultdir,condname{c},nt);
        eval(sprintf('save %s tcoords',file_name));
%end %end c
end %function
