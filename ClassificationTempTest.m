close all;
clear;

load TuktukData.mat
nAll   = 1000;
vClass = [zeros(500, 1); ones(500, 1)];

figure; hold on; grid on; plot(vClass);

vIdx      = find(vClass == 1);
vTestIdx  = vIdx(vIdx > 900);
% vTestIdx  = vIdx(vIdx > 170 & vIdx < 230);

nTest     = length(vTestIdx);
vTrainIdx = setdiff(1 : nAll, vTestIdx)';
nTrain    = length(vTrainIdx);

mS = [randn(2, 500) - 2, randn(2, 500) + 2];

mXtrain     = mS(:, vTrainIdx);
vTrainClass = vClass(vTrainIdx)';
mXtest      = mS(:, vTestIdx);
vTestClass  = vClass(vTestIdx);

mData   = [mXtrain; vTrainClass];

%%
[trainedClassifierKnn, score] = trainClassifierKnnTemp(mData);
% [trainedClassifier, score] = trainClassifierSVM(mData);
score

%%
vPredict = trainedClassifierKnn.predictFcn(mXtest);
% vPredict = trainedClassifier.predictFcn(mXtest);

mean(vPredict == vTestClass)