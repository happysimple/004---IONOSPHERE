% 爬取普通网页上的数据

the_url='https://data.cosmic.ucar.edu/gnss-ro/cosmic1/postProc/level2/2016/';
for i=1:yeardays(str2double(the_url(end-4:end-1)))
    doy=sprintf('%03d',i);
    url=[the_url,doy,'/'];
    try
        contents=webread(url);
    catch
        continue;
    end
    hT=htmlTree(contents);
    % 定位
    A_label=findElement(hT,'a');
    % 获取链接
    url_download=getAttribute(A_label,'href');
    flag=cellfun(@isempty,regexp(url_download,'ionPrf'));
    url_download=url_download(~flag);
    url_download=url+url_download;
    % 获取文件名
    filename=extractHTMLText(A_label);
    flag=cellfun(@isempty,regexp(filename,'ionPrf'));
    filename=filename(~flag);
    % 下载数据
    options = weboptions('Timeout',Inf);
    websave(filename,url_download,options);
end
