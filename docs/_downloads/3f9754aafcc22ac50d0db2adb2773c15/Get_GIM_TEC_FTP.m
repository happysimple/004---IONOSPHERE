clear;clc;

ftpobj = ftp('ftp.aiub.unibe.ch');
% 更改FTP 服务器上的当前文件夹
cd(ftpobj,'/CODE/2021/');
% 读取当前文件夹的内容
t=dir(ftpobj);
for i=1:365
    ii=sprintf('%03d',i);
    name=['CODG',ii,'0.21I.Z'];
    % 从 FTP 服务器下载文件
    mget(ftpobj,name);
end
close(ftpobj)