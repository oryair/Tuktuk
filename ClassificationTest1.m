close all;
clear;

load TuktukData.mat

nAll  = length(vClass);
CovarianceInFreqFlag = true;
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
if (CovarianceInFreqFlag)
    
[M,~,K]         = size(tCov);
tC              = zeros(M, M, K);
minEig          = inf;
for kk = 1 : K
    
            D           = dftmtx(M);
            mCDft       = D*tCov(:,:,kk)*D.';
            phaseX      = (angle(mCDft(13,14)) - angle(mCDft(13,13)))*M/(2*pi);
            phaseY      = (angle(mCDft(14,13)) - angle(mCDft(13,13)))*M/(2*pi);
            wx          = (0:2*pi:2*pi*(M-1))/M;
            [Wx,Wy]     = meshgrid(wx,wx); 
            phase       = angle(mCDft) - phaseX*Wx - phaseY*Wy;
%             mCDft       = abs(mCDft).*exp(1j*phase);
            mCDft       = abs(mCDft);
            tC(:,:,kk)  = real(D'*mCDft*conj(D)/M^2);
            
            if (min(eig(tC(:,:,kk))) < minEig)
                minEig = min(eig(tC(:,:,kk)));
            end

            
end
tC              = tC - repmat(1.001*minEig*eye(M),[1 1 K]);
mRiemannianMean = RiemannianMean(tC);
mCSR            = mRiemannianMean^(-1/2);

MM = M * (M + 1) / 2;
mS = zeros(MM, K);

mW = sqrt(2) * ones(M) - (sqrt(2) - 1) * eye(M);
for kk = 1 : K
    Skk = logm(mCSR * tC(:,:,kk) * mCSR) .* mW;
    mS(:,kk) = Skk(triu(true(size(Skk))));
end

end

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