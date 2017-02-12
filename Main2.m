close all;
clear;

%%
[~, ~, mXlsRaw] = xlsread('logbook - balmas.xlsx');
c            = containers.Map;
% class        = 1;
% for ii = 3 : size(mXlsRaw, 1)
%     
%     rawClass = [mXlsRaw{ii,3}, mXlsRaw{ii,4}];
%     
%     if ~any(strcmp(keys(c), rawClass))
%         c(rawClass) = class;
%         class       = class + 1;
%     end
%     
% end

c('xv') = 1;
c('xd') = 2;
c('hx') = 3;
c('hv') = 4;
c('hd') = 5;
c('jx') = 6;
c('jv') = 7;
c('jd') = 8;
c('nx') = 9;
c('nv') = 10;
c('nd') = 11;


%%
vSH = str2num( datestr([mXlsRaw{3:end,7}]', 'HH') );
vSM = str2num( datestr([mXlsRaw{3:end,7}]', 'MM') );
vEH = str2num( datestr([mXlsRaw{3:end,8}]', 'HH') );
vEM = str2num( datestr([mXlsRaw{3:end,8}]', 'MM') );
mSplitTime = [vSH*100 + vSM, vEH*100 + vEM];

eventsNum = size(mSplitTime, 1);
%%
[tCov, vTime] = GetCov(mSplitTime);

%%
rawClass   = [[mXlsRaw{3:end,3}]', [mXlsRaw{3:end,4}]'];
vTimeClass = [];
for ii = 1 : eventsNum
    vTimeClass(end+1) = c(rawClass(ii,:));
end

%%
vClass = zeros(eventsNum, 1);
for ii = 1 : eventsNum
    a = mSplitTime(ii,1);
    b = mSplitTime(ii,2);
    
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