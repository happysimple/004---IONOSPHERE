clear;clc;

dir1='F:\COSMIC TEC\Original Data\COSMIC1\';
myyear=2006:2020;
UT1=nan(50000000,6);
C1=nan(50000000,6);
u=0;
for i=1:length(myyear)
    % ����
    disp(num2str(myyear(i)));
    % �ļ�Ŀ¼
    mypath=[dir1,num2str(myyear(i)),'\'];
    mydir=dir([mypath,'*.????_nc']);
    % ѭ����ȡ�ļ�
    for j=1:length(mydir)
        Path1=[mypath,mydir(j).name];
        % ��ȡ����
        msl_alt=ncread(Path1,'MSL_alt');
        geo_lon=ncread(Path1,'GEO_lon');
        geo_lat=ncread(Path1,'GEO_lat');
        elec_dens1=ncread(Path1,'ELEC_dens');
        % ��ȡʱ������
        edmaxyear=double(ncreadatt(Path1,'/','year'));
        edmaxmonth=double(ncreadatt(Path1,'/','month'));
        edmaxday=double(ncreadatt(Path1,'/','day'));
        edmaxhour=double(ncreadatt(Path1,'/','hour'));
        edmaxminute=double(ncreadatt(Path1,'/','minute'));
        edmaxsecond=double(ncreadatt(Path1,'/','second'));
        % ��ȡ��������
        edmaxlon=ncreadatt(Path1,'/','edmaxlon');
        edmaxlat=ncreadatt(Path1,'/','edmaxlat');
        hmF2=ncreadatt(Path1,'/','edmaxalt');
        NmF2=ncreadatt(Path1,'/','edmax');
        tec0=ncreadatt(Path1,'/','tec0');  
        % ��������
        % �٣��ŵ㻬��ƽ��
        n=length(elec_dens1);
        elec_dens2=elec_dens1;
        for b=5:n-4
            elec_dens2(b)=mean(elec_dens1(b-4:b+4));
        end
        % �ڣ������ܶ�ƽ��ƫ�=0.1���޳�
        MD=sum(abs(elec_dens1-elec_dens2)./(n*elec_dens2));
        if MD>=0.1
            continue;
        end 
        % �ۣ�sigma>=0.05���޳�
        sigma=sum((elec_dens1-elec_dens2).^2)/(n*(NmF2^2));
        if sigma>=0.05
            continue;
        end
        % �ܣ�dne/dh>=0���޳���420km-490km��
        idx1=find(msl_alt>420,1);
        idx2=find(msl_alt>490,1);
        if isempty(idx2)
            continue;
        end
        k=(elec_dens2(idx2)-elec_dens2(idx1))/(msl_alt(idx2)-msl_alt(idx1));
        if k>=0
            continue;
        end
        % �ݣ�NmF2<0���޳�
        if NmF2<0
            continue;
        end
        % �ޣ�hmF2<200km���޳�
        if hmF2<200
            continue;
        end      
        % ����STEC
        idx1=find(msl_alt>110);
        stec=trapz(msl_alt(idx1),elec_dens2(idx1))*10^(-7);   
        % ����ӳ�亯��mz
        a=0.9782;
        H=450;
        R=6378.137;
        idx1=find(msl_alt>110,1);
        dh=msl_alt(end)-msl_alt(idx1);
        dlon=geo_lon(end)-geo_lon(idx1);
        dlat=geo_lat(end)-geo_lat(idx1);
        z=acosd(dh/sqrt(dlon^2+dlat^2+dh^2));
        if z>15
           continue;
        end
        mz=1/(sqrt(1-((R+110)/(R+H)*sind(a*z))^2));       
        % ����VTEC
        vtec=stec/mz;
        % �����������
        u=u+1;
        UT1(u,:)=[edmaxyear,edmaxmonth,edmaxday,edmaxhour,edmaxminute,edmaxsecond];
        C1(u,:)=[edmaxlon,edmaxlat,vtec,NmF2,hmF2,tec0];
    end
end
% �޳���������
idx=isnan(UT1(:,1));
UT1(idx,:)=[];
C1(idx,:)=[];
% �޳�VTEC��STEC����������
idx=find(C1(:,3)-C1(:,6)<-2);
UT1(idx,:)=[];
C1(idx,:)=[];
% �޳�STEC����
C1(:,6)=[];
% �޳�nan����
idx1=isnan(C1(:,3));
idx2=isnan(C1(:,4));
idx3=isnan(C1(:,5));
idx=union(union(idx1,idx2),idx3);
C1(idx,:)=[];
UT1(idx,:)=[];
% �޳�inf����
idx1=isinf(C1(:,3));
idx2=isinf(C1(:,4));
idx3=isinf(C1(:,5));
idx=union(union(idx1,idx2),idx3);
C1(idx,:)=[];
UT1(idx,:)=[];
% ��������
save UT1 UT1 -v7.3
save C1 C1 -v7.3






