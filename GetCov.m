function [tCov, vTime] = GetCov(vSplitTimes)

addpath('SegyMAT');
dirPath  = 'E:\Elbit\Data\';
files    = dir([dirPath, '*\*.SGY']);
filesNum = length(files);

startTime = min(vSplitTimes(:));
endTime   = max(vSplitTimes(:));

tCov  = zeros(25, 25, 0);
vTime = zeros(0);

for ii = 1 : filesNum
%     ii
    fileName = [files(ii).folder, '\', files(ii).name];
    [~, header, ~] = ReadSegy_nadav(fileName, 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
    fileTime = 100 * header(1).HourOfDay + 1 * header(1).MinuteOfHour
    
    if fileTime < startTime
        continue
    end
    
    if fileTime > endTime
        break;
    end
    
    if any(fileTime >= vSplitTimes(:,1) & fileTime <= vSplitTimes(:,2))
        mX    = ReadSegy_nadav(fileName, 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
        mX    = mX(:,8:32);
        tCov(:,:,end+1) = cov(mX);
        vTime(end+1) = fileTime;
    end
end

end