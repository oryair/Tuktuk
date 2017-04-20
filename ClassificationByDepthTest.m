close all;
clear;

load TuktukData.mat

% vDepthClass = [0, 0, 0, 0, 0, ...
%                1,             ...
%                2, 2, 2, 2,    ...
%                3, 3, 3, 3, 3, 3, 3, 3, 3, ...
%                1, 1, ...
%                3, 3, 3, ...
%                2, 2, 2, ...
%                4, 4, 4, 4, 4, 4, ...
%                ];
               
vDepthClass = [1, 1, 1, 1, 1, ...
               0,             ...
               4, 4, 4, 4,    ...
               2, 2, 2, 2, 2, 2, 2, 2, 2, ...
               1, 1, ...
               2, 2, 2, ...
               4, 4, 4, ...
               3, 3, 3, 3, 3, 3, ...
               ];
           
eventsNum = length(vDepthClass);
vClass    = zeros(eventsNum, 1);
for ii = 1 : eventsNum
    a = mSplitTime(ii,1);
    b = mSplitTime(ii,2);
    
    vClass((vTime >= a)  & (vTime <= b)) = vDepthClass(ii);
end

mData   = [mS; vClass'];