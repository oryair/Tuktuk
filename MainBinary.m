close all;
clear;

%%
[~, ~, mXlsRaw] = xlsread('logbook - balmas.xlsx');

%%
mSplit = [1200, 1228, 0;
          1229, 1235, 1;
          1236, 1244, 0;
          1245, 1250, 1;
          1251, 1256, 1;
          1257, 1257, 0;
          1258, 1303, 1;
          1304, 1414, 0;
          1415, 1419, 1;
          1420, 1432, 0;
          1433, 1438, 1;
          1439, 1459, 0;
          1500, 1505, 1;
          1506, 1507, 0;
          1508, 1513, 1;
          1514, 1519, 1;
          1520, 1521, 0;
          1522, 1528, 1;
          1529, 1530, 0;
          ];
              
mTimeSplit = mSplit(:,[1,2]);
vTimeClass = mSplit(:,3);
              
eventsNum = size(mTimeSplit, 1);
%%
[tCov, vTime] = GetCov(mTimeSplit);

%%
% rawClass   = [[mXlsRaw{3:end,3}]', [mXlsRaw{3:end,4}]'];
% vTimeClass = [];
% for ii = 1 : eventsNum
%     vTimeClass(end+1) = c(rawClass(ii,:));
% end

%%
vClass = zeros(eventsNum, 1);
for ii = 1 : eventsNum
    a = mTimeSplit(ii,1);
    b = mTimeSplit(ii,2);
    
    vClass((vTime >= a)  & (vTime <= b)) = vTimeClass(ii);
end


%%
tC = tCov;
mRiemannianMean = RiemannianMean(tC);
mCSR            = mRiemannianMean^(-1/2);

K  = size(tC, 3);
M  = 25;
MM = M * (M + 1) / 2;
mS = zeros(MM, K);

mW = sqrt(2) * ones(M) - (sqrt(2) - 1) * eye(M);
for kk = 1 : K
    Skk = logm(mCSR * tC(:,:,kk) * mCSR) .* mW;
%     Skk = (mRiemannianMean^(1/2) * logm(mCSR * tC(:,:,kk) * mCSR) * mRiemannianMean^(1/2)) .* mW;
    mS(:,kk) = Skk(triu(true(size(Skk))));
%     MMM      = tC(:,:,kk) .* mW;
%     mS(:,kk) = MMM(triu(true(size(MMM))));
end

%%
mData  = [mS; vClass'];
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
% L           = size(mS, 2);
% vTestIdx    = randperm(L, round(L / 10));
% vTrainIdx   = setdiff(1 : L, vTestIdx);
% mTest       = mS(:, vTestIdx);
% vTestClass  = vClass(vTestIdx);
% mTrain      = mS(:, vTrainIdx);
% vTrainClass = vClass(vTrainIdx);
% 
% tTrain = [mTrain; vTrainClass];
% 
% trainedClassifierKnn = trainClassifier(tTrain);

%%
% vY = trainedClassifierKnn.predictFcn(mTest);
% 
% [~, vSortIdx] = sort(vTestIdx);
% 
% figure; hold on;
% plot(vTestClass(vSortIdx),  'b', 'LineWidth', 2);
% plot(vY(vSortIdx),         ':g', 'LineWidth', 2);
% 
% mean(vY == vTestClass')

%%
% mPhi = tsne(mS', vClass, 3);

%%
% figure; hold on; grid on;
% scatter3(mPhi(:,1), mPhi(:,2), mPhi(:,3), 100, vClass, 'Fill'); axis equal;