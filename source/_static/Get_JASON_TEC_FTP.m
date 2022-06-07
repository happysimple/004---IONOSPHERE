% 基于Matlab爬取FTP上的数据

ftpobj = ftp('ftp-access.aviso.altimetry.fr','1292584987@qq.com','123456');
% 更改FTP 服务器上的当前文件夹
cd(ftpobj,'/geophysical-data-record/jason-2/gdr_d/cycle_000');
% 读取当前文件夹的内容
t=dir(ftpobj);
for i=1:length(t)
    % 从 FTP 服务器下载文件
    mget(ftpobj,t(i).name);
end
close(ftpobj)


