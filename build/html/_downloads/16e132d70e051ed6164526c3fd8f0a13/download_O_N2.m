clc,clear;
num = 1:366;
% num = [152:181,335:364];
% num = [182:211,1:30];
URLs = cell(size(num));
folder_filenames = cell(size(num));
filenames = cell(size(num));

for idx  = 1:length(num)
%    URLs{idx} = sprintf(['http://guvitimed.jhuapl.edu/data/level3/guvi_on2/data/NetCDF/2007/ON2_2007_%03dm.ncdf.gz'],num(idx));
    URLs{idx} = sprintf('http://guvitimed.jhuapl.edu/data/level3/guvi_on2/data/IDLsave/2014/ON2_2014_%03dm.sav',num(idx));
    filenames{idx} = sprintf('ON2_2014_%03dm.sav',num(idx));
end

tic;
rnum=0;
for idx = 1:length(num)
    fprintf(1,'loading%s...\n',filenames{idx});
    [f, status] = urlwrite(URLs{idx},filenames{idx});
    if status == 1
        fprintf(1,'%sOK\n',filenames{idx});
        rnum=rnum+1;
    else
        fprintf(1,'%sFault\n',filenames{idx});
    end
end
etime = toc;

fprintf('Wanted file number: %d, loaded file number: %d, time: %fs\n',length(num),rnum,etime);
