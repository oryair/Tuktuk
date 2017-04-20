addpath('SegyMAT');
addpath('Connectivity');

close all
clear;

M           = 10;
K           = 300;
N           = 300;
vChannels   = [5, 7];

params.M            = M;
params.K            = K;
params.N            = N;
params.p            = 0.5;
params.noise        = 1.5;
params.vChannels    = vChannels;

[mX, vIdx]      = getDataTest(params);

%%
% paramsR.type    = 'connectivity'; 
paramsR.type    = 'covarianceFreq';
% paramsR.type    = 'covariance';
mS              = getRiemannianFeatures(mX, paramsR);

%%
temp = [mS; vIdx];
[trainedClassifier, validationAccuracy] = trainClassifierSvmSine(temp);
validationAccuracy

%%
params.vChannels    = vChannels + 2;
[mXTest, vIdxTest]  = getDataTest(params);
mSTest              = getRiemannianFeatures(mXTest, paramsR);
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
figure; plot(dataPlot); hold on; plot(realEvent,'g')
