function [mData, vS, vM, vH] = GetEventsData(vSplitTimes)

addpath('SegyMAT');
% dirPath  = 'E:\Elbit\Data\';
dirPath  = 'C:\Users\Oryair\Desktop\Workarea\Elbit\Data\';
files    = dir([dirPath, '*\*.SGY']);
filesNum = length(files);

startTime = min(vSplitTimes(:));
endTime   = max(vSplitTimes(:));

mData = zeros(0, 25);
vTime = zeros(0);
vS    = zeros(0);
vM    = zeros(0);
vH    = zeros(0);
for ii = 1 : filesNum
%     ii
    fileName = [files(ii).folder, '\', files(ii).name];
    [~, header, ~] = ReadSegy_nadav(fileName, 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
    fileTime = 10000 * header(1).HourOfDay + 100 * header(1).MinuteOfHour + ...
               header(1).SecondOfMinute
    
    if fileTime < startTime
        continue
    end
    
    if fileTime > endTime
        break;
    end
    
    if any(fileTime >= vSplitTimes(:,1) && fileTime <= vSplitTimes(:,2))
        mX    = ReadSegy_nadav(fileName, 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
        mX    = mX(:,8:32);
        mData = cat(1, mData, mX);
        
        L   = size(mX, 1);
        s1   = header(1).SecondOfMinute;
        m1   = header(1).MinuteOfHour;
        h1   = header(1).HourOfDay;
        
        vS  =        cat(1, vS, linspace(s1, s1 + 5, L)');
        vM  = floor( cat(1, vM, linspace(m1, m1,     L)'));
        vH  = floor( cat(1, vH, linspace(h1, h1,     L)'));
%         vFileTime = linspace(fileTime, fileTime + 5, L + 1)'; vFileTime(end) = [];
%         vTime     = cat(1, vTime, vFileTime);
    end
end

end