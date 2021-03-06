close all;
clear;

addpath SegyMAT\
dirPath = 'C:\Users\Oryair\Desktop\Workarea\Elbit\Data\Test1\';
% fileName = '10298.SGY';

% startTime = 27;
% endTime   = 37;

startTime = 1227;
endTime   = 1559;

files = dir([dirPath, '*.SGY']);
[~, fileIndex] = sortrows({files.name}.');
files          = files(fileIndex);

time = 0;
fileStartIdx = 0;
while time < startTime
    fileStartIdx = fileStartIdx + 1;
    [~, header, ~] = ReadSegy_nadav([dirPath, files(fileStartIdx).name], 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
    time = header(1).MinuteOfHour + 100 * header(1).HourOfDay
end
display('=========================================');

%%
% eventStart = 29;
% eventEnd   = 35;

timeStart = time;
vChannels = 8:32;
M         = length(vChannels);

tC    = zeros(M, M, 0);
vType = zeros(1, 0);

% L  = 10001;
% mY = zeros(M, 10 * L);

% figure;
fileIdx = fileStartIdx;
time    = timeStart;
vTime   = time;
while time < endTime
    
    [mX, ~, ~] = ReadSegy_nadav([dirPath, files(fileIdx).name], 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
    mX         = mX(:, vChannels);
    tC(:, :, end + 1) = cov(mX);
%     if time >= eventStart && time <= eventEnd
%         vType(end+1) = 1;
%     else
%         vType(end+1) = 0;
%     end    
   
%     mY = cat(2, mY, mX');
%     mY(:, 1:L) = [];
%     wiggle(mY'); title(['Time - ', num2str(time), '. Class - ', num2str(vType(end))]);
%     drawnow;

    fileIdx = fileIdx + 1;
    [~, header, ~] = ReadSegy_nadav([dirPath, files(fileIdx).name], 'revision' , 1 , 'dsf' , 5 , 'endian' , 'l');
    time = header(1).MinuteOfHour + 100 * header(1).HourOfDay
    
    vTime(end+1) = time;
    
end

vTime(end) = [];

%%
vTimeSplit = [1200, 1229, 1235, 1245, 1250 1251 1256 1258 1303 1415 1419  1433 1438 1554 1559];
% vTimeClass = [     0,    1,    0,    2,   0,   2,   0,   2,   0,   3,   0     4    0    1];
vTimeClass = [     0,    1,    0,    1,   0,   1,   0,   1,   0,   1,   0     0    0    1];

% vTimeSplit = [0, 29, 35, 45, 50];
% vTimeClass = [  0,  1,  0,  2];

vClass = zeros(size(vTime));
for ii = 1 : (length(vTimeSplit) - 1)
    a = vTimeSplit(ii);
    b = vTimeSplit(ii+1);
    
    vClass((vTime > a)  & (vTime <= b)) = vTimeClass(ii);
    
end



%%
mRiemannianMean = RiemannianMean(tC);
mCSR            = mRiemannianMean^(-1/2);

K  = size(tC, 3);
MM = M * (M + 1) / 2;
mS = zeros(MM, K);

mW = sqrt(2) * ones(M) - (sqrt(2) - 1) * eye(M);
for kk = 1 : K
    Skk = logm(mCSR * tC(:,:,kk) * mCSR) .* mW;
%     Skk = (mRiemannianMean^(1/2) * logm(mCSR * tC(:,:,kk) * mCSR) * mRiemannianMean^(1/2)) .* mW;
    mS(:,kk) = Skk(triu(true(size(Skk))));
end

%%
mData  = [mS; vClass];
% mData3 = [abs(fft(mS)); vClass];

%%
% mW  = squareform( pdist(mS') );
% eps = 10 * median(mW(:))
% mK  = exp( -mW.^2 / eps^2 );
% % D   = diag( sum(mK, 2) );
% % mK  = D^-1 * mK * D^-1;
% mA  = bsxfun(@rdivide, mK, sum(mK, 2));
% [mPhi, mLam] = eig(mA);
% 
% vTestIdx = vClass ~= 0;
% mPhi = mPhi(vTestIdx, :);
% vClass2 = vClass(vTestIdx);
% 
% figure; scatter3(mPhi(:,2), mPhi(:,3), mPhi(:,4), 100, vClass2, 'Fill'); colorbar; axis equal;

%%
% mPCA = pca(mS);
% figure; scatter3(mPCA(:,1), mPCA(:,2), mPCA(:,3), 100, vClass, 'Fill'); colorbar; axis equal;

%%
% mZ = zeros(25^2, 0);
% for ii = 1 : size(tC, 3)
%    mZ(:,end+1) = reshape(tC(:,:,ii), [], 1);
% end
% 
% mData2 = [mZ; vClass];

%%
L           = size(mS, 2);
vTestIdx    = randperm(L, round(L / 10));
vTrainIdx   = setdiff(1 : L, vTestIdx);
mTest       = mS(:, vTestIdx);
vTestClass  = vClass(vTestIdx);
mTrain      = mS(:, vTrainIdx);
vTrainClass = vClass(vTrainIdx);

tTrain = [mTrain; vTrainClass];

trainedClassifierKnn = trainClassifier(tTrain);

%%
vY = trainedClassifierKnn.predictFcn(mTest);

[~, vSortIdx] = sort(vTestIdx);

figure; hold on;
plot(vTestClass(vSortIdx),  'b', 'LineWidth', 2);
plot(vY(vSortIdx),         ':g', 'LineWidth', 2);

mean(vY == vTestClass')

%%
% mPhi = tsne(mS', vClass, 3);

%%
% figure; hold on; grid on;
% scatter3(mPhi(:,1), mPhi(:,2), mPhi(:,3), 100, vClass, 'Fill'); axis equal;