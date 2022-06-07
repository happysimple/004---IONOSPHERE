%% 读取2003-2021年的GIM TEC(CODE)
clear;clc;

% 设置数据结构
year=2003:2021;
n=length(year);
tec=zeros(71,73,25,365);% 4个维度依次是纬度、经度、世界时、年积日
code2(1:n)=struct('TEC',tec);

% 读取数据
f=waitbar(0);
for i=1:n
    waitbar(i/length(year),f,sprintf('%s',['已完成：',num2str(100*i/n),'%']));
    % 读取数据目录
    y=num2str(year(i));
    myPath=['F:\Data\CODE TEC\Original Data\',y,'\'];
    myDir=dir([myPath,'*.',y(3:4),'i']);
    % 开始遍历文件
    for j=1:length(myDir)
        fp=fopen([myPath,myDir(j).name],'r');
        u=0;
        while ~feof(fp)
            L=fgetl(fp);
            % 寻找TEC数据而非RMS数据      
            if contains(L,'START OF TEC MAP')~=0
                L=fgetl(fp);
                T=str2num(L(1:40));
                
                if u==0 % 如果是第一组数据
                   doy=day(datetime(T(1),T(2),T(3)),'dayofyear'); % 计算年积日索引
                end
                u=u+1;% 计算世界时索引
                
                % 读取TEC数据
                for k=1:71
                    fgetl(fp);
                    L1=str2num(fgetl(fp));
                    L2=str2num(fgetl(fp));
                    L3=str2num(fgetl(fp));
                    L4=str2num(fgetl(fp));
                    L5=str2num(fgetl(fp));
                    a(k,:)=[L1,L2,L3,L4,L5]*0.1;
                end 
                % 在2003-2014(291天),时间分辨率为2h,起点为00UT,终点是次日00UT
                if year(i)<2014 || (year(i)==2014 && doy<=291) 
                    code2(i).TEC(:,:,2*u-1,doy)=a;
                else
                % 在2014(292天)及以后,时间分辨率为1h,起点为00UT,终点是次日00UT
                    code2(i).TEC(:,:,u,doy)=a;
                end
            end
        end
        fclose(fp);
    end
end

% 本程序对2003-2014(291天)的数据进行插值，由时间分辨率为2h转化为1h
id=find(year==2014);
% 2014年以前
for i=1:id-1
    for ut=2:2:24
        code2(i).TEC(:,:,ut,:)=(code2(i).TEC(:,:,ut-1,:)+code2(i).TEC(:,:,ut+1,:))./2;
    end
end
% 2014年
for ut=2:2:24
    code2(id).TEC(:,:,ut,1:291)=(code2(id).TEC(:,:,ut-1,1:291)+code2(id).TEC(:,:,ut+1,1:291))./2;
end

% 保存
save code2 code2 -v7.3



