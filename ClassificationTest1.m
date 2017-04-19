close all;
clear;

load TuktukData.mat

nAll  = length(vClass);

%%
% h1 = figure;
% h2 = figure;
% for ii = [90 : 290, 800 : 1100]
%     figure(h1);
%     imagesc(tCov(:,:,ii)); title(num2str(vClass(ii))); colorbar;
%     figure(h2); plot(vClass); hold on; grid on; plot([ii, ii], [0, 12], ':r', 'LineWidth', 3); hold off;
%     drawnow; pause(0.01);
% end

%%
% tC = tCov;
% K  = size(tC, 3);
% for ii = 1 : K
%     tC(:,:,ii) = abs( fft2( tC(:,:,ii) ) );
% end
% 
% mRiemannianMean = real(RiemannianMean(tC));
% mCSR            = mRiemannianMean^(-1/2);
% 
% M  = 25;
% MM = M * (M + 1) / 2;
% % MM = M * M;
% mS = zeros(MM, K);
% 
% mW = sqrt(2) * ones(M) - (sqrt(2) - 1) * eye(M);
% for kk = 1 : K
%     Skk = real(logm(mCSR * tC(:,:,kk) * mCSR) .* mW);
%     mS(:,kk) = Skk(triu(true(size(Skk))));
% %       mS(:, kk) = reshape(tC(:,:,kk), [], 1);
% %     MMM      = tC(:,:,kk);
% %     mS(:,kk) = MMM(triu(true(size(MMM))));
% end

%%

figure; plot(vClass); hold on; grid on;

vIdx      = find(vClass == 4);
% vTestIdx  = vIdx(vIdx > 500);
vTestIdx  = vIdx(vIdx > 110 & vIdx < 150);

nTest     = length(vTestIdx);
vTrainIdx = setdiff(1 : nAll, vTestIdx)';
nTrain    = length(vTrainIdx);

mXtrain     = mS(:, vTrainIdx);
vTrainClass = vClass(vTrainIdx)';
mXtest      = mS(:, vTestIdx);
vTestClass  = vClass(vTestIdx);

mData   = [mXtrain; vTrainClass];

%%
[trainedClassifierKnn, score] = trainClassifierKnn(mData);
% [trainedClassifier, score] = trainClassifierLSVM(mData);
% [trainedClassifier, score] = trainClassifier(mData);
score

%%
vPredict = trainedClassifierKnn.predictFcn(mXtest);
% vPredict = trainedClassifier.predictFcn(mXtest);

mean(vPredict == vTestClass)