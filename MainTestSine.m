addpath('SegyMAT');
close all
clear;

M           = 10;
K           = 300;
N           = 300;
vChannels   = [5, 7];

params.M            = M;
params.K            = K;
params.N            = N;
params.p            = 0.1;
params.vChannels    = vChannels;

[mX, vIdx] = getDataTest(params);
mS         = getRiemannianFeatures(mX);
% %%
% tC = zeros(M, M, K);
% for kk = 1 : K
%     tC(:,:,kk) = cov(mX(:,:,kk)' );
% end
% 
% mRiemannianMean = RiemannianMean(tC);
% 
% %%
% mCSR = mRiemannianMean^(-1/2);
% 
% MM = M * (M + 1) / 2;
% mS = zeros(MM, K);
% 
% mW = sqrt(2) * ones(M) - (sqrt(2) - 1) * eye(M);
% for kk = 1 : K
%     Skk = logm(mCSR * tC(:,:,kk) * mCSR) .* mW;
%     mS(:,kk) = Skk(triu(true(size(Skk))));
% end

%%
temp = [mS; vIdx];
[trainedClassifier, validationAccuracy] = trainClassifierSvmSine(temp);
validationAccuracy

%%
params.vChannels    = vChannels;
[mXTest, vIdxTest]  = getDataTest(params);
mSTest              = getRiemannianFeatures(mXTest);
vY                  = trainedClassifier.predictFcn(mSTest);

testAccuracy        = 1 - sum(abs(double(vIdxTest) - vY'))/params.K

%%
temp     = permute(mXTest,[2 3 1]);
temp     = reshape(temp,[N*K, M]);
vStd     = std(temp);
temp     = bsxfun(@minus,   temp, mean(temp));
temp     = bsxfun(@rdivide, temp, 20*vStd);
temp     = bsxfun(@plus,    temp, (1:M) + 1);

predict     = kron(vY',ones(1,N));
realEvent   = kron(vIdxTest,ones(1,N));
dataPlot    = [temp predict'];

% figure; wiggle(dataPlot);
figure; plot(dataPlot); hold on; plot(realEvent,'k')
