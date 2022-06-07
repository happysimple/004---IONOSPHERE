clear;clc;

dir1='F:\COSMIC TEC\Original Data\COSMIC1\';
myyear=2006:2020;
UT1=nan(50000000,6);
C1=nan(50000000,6);
u=0;
for i=1:length(myyear)
    % 进度
    disp(num2str(myyear(i)));
    % 文件目录
    mypath=[dir1,num2str(myyear(i)),'\'];
    mydir=dir([mypath,'*.????_nc']);
    % 循环读取文件
    for j=1:length(mydir)
        Path1=[mypath,mydir(j).name];
        % 获取变量
        msl_alt=ncread(Path1,'MSL_alt');
        geo_lon=ncread(Path1,'GEO_lon');
        geo_lat=ncread(Path1,'GEO_lat');
        elec_dens1=ncread(Path1,'ELEC_dens');
        % 获取时间属性
        edmaxyear=double(ncreadatt(Path1,'/','year'));
        edmaxmonth=double(ncreadatt(Path1,'/','month'));
        edmaxday=double(ncreadatt(Path1,'/','day'));
        edmaxhour=double(ncreadatt(Path1,'/','hour'));
        edmaxminute=double(ncreadatt(Path1,'/','minute'));
        edmaxsecond=double(ncreadatt(Path1,'/','second'));
        % 获取其他属性
        edmaxlon=ncreadatt(Path1,'/','edmaxlon');
        edmaxlat=ncreadatt(Path1,'/','edmaxlat');
        hmF2=ncreadatt(Path1,'/','edmaxalt');
        NmF2=ncreadatt(Path1,'/','edmax');
        tec0=ncreadatt(Path1,'/','tec0');  
        % 质量控制
        % ①：九点滑动平均
        n=length(elec_dens1);
        elec_dens2=elec_dens1;
        for b=5:n-4
            elec_dens2(b)=mean(elec_dens1(b-4:b+4));
        end
        % ②：电子密度平均偏差＞=0.1则剔除
        MD=sum(abs(elec_dens1-elec_dens2)./(n*elec_dens2));
        if MD>=0.1
            continue;
        end 
        % ③：sigma>=0.05则剔除
        sigma=sum((elec_dens1-elec_dens2).^2)/(n*(NmF2^2));
        if sigma>=0.05
            continue;
        end
        % ④：dne/dh>=0则剔除（420km-490km）
        idx1=find(msl_alt>420,1);
        idx2=find(msl_alt>490,1);
        if isempty(idx2)
            continue;
        end
        k=(elec_dens2(idx2)-elec_dens2(idx1))/(msl_alt(idx2)-msl_alt(idx1));
        if k>=0
            continue;
        end
        % ⑤：NmF2<0则剔除
        if NmF2<0
            continue;
        end
        % ⑥：hmF2<200km则剔除
        if hmF2<200
            continue;
        end      
        % 计算STEC
        idx1=find(msl_alt>110);
        stec=trapz(msl_alt(idx1),elec_dens2(idx1))*10^(-7);   
        % 计算映射函数mz
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
        % 计算VTEC
        vtec=stec/mz;
        % 汇总输出数据
        u=u+1;
        UT1(u,:)=[edmaxyear,edmaxmonth,edmaxday,edmaxhour,edmaxminute,edmaxsecond];
        C1(u,:)=[edmaxlon,edmaxlat,vtec,NmF2,hmF2,tec0];
    end
end
% 剔除多余数据
idx=isnan(UT1(:,1));
UT1(idx,:)=[];
C1(idx,:)=[];
% 剔除VTEC与STEC相差过大数据
idx=find(C1(:,3)-C1(:,6)<-2);
UT1(idx,:)=[];
C1(idx,:)=[];
% 剔除STEC数据
C1(:,6)=[];
% 剔除nan数据
idx1=isnan(C1(:,3));
idx2=isnan(C1(:,4));
idx3=isnan(C1(:,5));
idx=union(union(idx1,idx2),idx3);
C1(idx,:)=[];
UT1(idx,:)=[];
% 剔除inf数据
idx1=isinf(C1(:,3));
idx2=isinf(C1(:,4));
idx3=isinf(C1(:,5));
idx=union(union(idx1,idx2),idx3);
C1(idx,:)=[];
UT1(idx,:)=[];
% 保存数据
save UT1 UT1 -v7.3
save C1 C1 -v7.3






