clear;clc;
% 读取Jason TEC

% 读取文件目录
mainDir='F:\JASON TEC\JASON1 TEC\';
ascFile=dir([mainDir,'*.asc']);
ascNum=length(ascFile);

% 正文
A1=ones(220000000,3)*nan;
UT1=ones(220000000,6)*nan;
k=0;
f=waitbar(0,'1','Name','进度');
for i=1:ascNum
    % 进度条
     waitbar(i/ascNum,f,sprintf('%s',['已完成: ',num2str(100*i/ascNum),'%']));
    
    % 打开文件
    Path1=[mainDir,ascFile(i).name];
    fp=fopen(Path1,'r');
    
    % 读取Eqsec
    for j=1:5
        fgetl(fp);
    end
    L=fgetl(fp);
    Eqsec=str2double(L(15:31));
    for j=1:7
        fgetl(fp);
    end
    
    % 读取TEC
    while ~feof(fp)
        L1=str2num(fgetl(fp));
        if isnan(L1(4))
            continue;
        end
        dacSec=L1(1);
        lat=L1(2);
        lon=L1(3);
        Jason=-L1(4)*(13.575*10^9)^2/(40.3*10^16);
        % 转化时间
        asSec=round(Eqsec+dacSec);
        t1=addtodate(datenum(1985,01,01,00,00,00),asSec,'sec');
        t2=datestr(t1,'yymmdd_HHMMSS');
        t3=datevec(t2,'yymmdd_HHMMSS');
        
        % 汇总数据
        k=k+1;
        UT1(k,:)=[t3(1),t3(2),t3(3),t3(4),t3(5),t3(6)];
        A1(k,:)=[lon,lat,Jason];
    end
    fclose(fp);  
end

% 剔除NAN数据
idx=find(isnan(A1(:,1))==1);
A1(idx,:)=[];
idx=find(isnan(UT1(:,1))==1);
UT1(idx,:)=[];

% 剔除小于0数据
idx=find(A1(:,3)<0);
UT1(idx,:)=[];
A1(idx,:)=[];

% 保存数据
save A1 A1 -v7.3
save UT1 UT1 -v7.3

