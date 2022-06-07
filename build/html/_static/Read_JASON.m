clear;clc;
% ��ȡJason TEC

% ��ȡ�ļ�Ŀ¼
mainDir='F:\JASON TEC\JASON1 TEC\';
ascFile=dir([mainDir,'*.asc']);
ascNum=length(ascFile);

% ����
A1=ones(220000000,3)*nan;
UT1=ones(220000000,6)*nan;
k=0;
f=waitbar(0,'1','Name','����');
for i=1:ascNum
    % ������
     waitbar(i/ascNum,f,sprintf('%s',['�����: ',num2str(100*i/ascNum),'%']));
    
    % ���ļ�
    Path1=[mainDir,ascFile(i).name];
    fp=fopen(Path1,'r');
    
    % ��ȡEqsec
    for j=1:5
        fgetl(fp);
    end
    L=fgetl(fp);
    Eqsec=str2double(L(15:31));
    for j=1:7
        fgetl(fp);
    end
    
    % ��ȡTEC
    while ~feof(fp)
        L1=str2num(fgetl(fp));
        if isnan(L1(4))
            continue;
        end
        dacSec=L1(1);
        lat=L1(2);
        lon=L1(3);
        Jason=-L1(4)*(13.575*10^9)^2/(40.3*10^16);
        % ת��ʱ��
        asSec=round(Eqsec+dacSec);
        t1=addtodate(datenum(1985,01,01,00,00,00),asSec,'sec');
        t2=datestr(t1,'yymmdd_HHMMSS');
        t3=datevec(t2,'yymmdd_HHMMSS');
        
        % ��������
        k=k+1;
        UT1(k,:)=[t3(1),t3(2),t3(3),t3(4),t3(5),t3(6)];
        A1(k,:)=[lon,lat,Jason];
    end
    fclose(fp);  
end

% �޳�NAN����
idx=find(isnan(A1(:,1))==1);
A1(idx,:)=[];
idx=find(isnan(UT1(:,1))==1);
UT1(idx,:)=[];

% �޳�С��0����
idx=find(A1(:,3)<0);
UT1(idx,:)=[];
A1(idx,:)=[];

% ��������
save A1 A1 -v7.3
save UT1 UT1 -v7.3

