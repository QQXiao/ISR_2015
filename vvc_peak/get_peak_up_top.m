function get_peak_up_top(c)
%%%%%%%%%
basedir='/seastor/helenhelen/ISR_2015';
addpath /seastor/helenhelen/scripts/NIFTI
datadir=sprintf('%s/data_singletrial/ref_space/zscore/beta/merged2',basedir);

condname={'ERS_IBwc','ERS_DBwc','mem_DBwc','ln_DBwc','ERS_ID'}
%%%%%%%%%
radius=3;
TN=192;
subs=setdiff(1:21,2);
%for c=1:4
vvcdir=sprintf('%s/peak/VVC/data/vvc_data/%s',basedir,condname{c});
resultdir=sprintf('%s/peak/VVC/data/top/coordinate',basedir);
mkdir(resultdir);
ERS=[];mem=[];ln=[];
ERS_z=[];mem_z=[];ln_z=[];
kmax=112-radius;jmax=112-radius;imax=64-radius
kmin=1+radius;jmin=1+radius;imin=1+radius
nt=5000; %50; 100; 200; 500; 1000
coords=zeros(21,nt,4);
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
	    t=0;
	while flag
		max_vvc=max(tvvc(:));
		if isempty(max_vvc);
		flag=0;
		else
		lmax=find(vvc==max_vvc);
		nmax=length(lmax);
		tlmax=find(tvvc==max_vvc);
		[kk,jj,ii]=ind2sub(ss,lmax);
		%remove max
		tvvc(tlmax)=[];
		for tt=1:nmax
		k=kk(tt);j=jj(tt);i=ii(tt);
		if k<=kmax & j<=jmax & i<=imax & k>=kmin & j>=jmin & i>=imin 		
		%define small cubic for memory data
		data_balls=vvc(k-radius:k+radius,j-radius:j+radius,i-radius:i+radius,:);
        	a=size(data_balls);
        	b=a(1)*a(2)*a(3);
		p=sum(find(data_balls)>=0.01)/b

            		if p>=0.9
			t=t+1
            		runtime = runtime + 1
			coords(s,t,[1:3])=[k,j,i];
			coords(s,t,4)=runtime;
			else
			runtime = runtime + 1
			end %if
		else
       		runtime = runtime + 1
        	end %if
		end %end for
		end %end if
		if t==nt | runtime >= 1000000
            	flag = 0;
            	break;
        	end
	end %while
end%sub
        file_name=sprintf('%s/%s_%d.mat', resultdir,condname{c},nt);
        eval(sprintf('save %s coords',file_name));
%end %end c
end %function
