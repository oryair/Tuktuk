close all
clear;

M = 10;
K = 300;
N = 300;

p = 0.1;

t = linspace(0, 1, N + 1); t(end) = [];

vChannels = [5, 7];

%%
mX   = 1*randn(M, N, K);
vIdx = rand(1, K) < p;

% mEvent = zeros(size(mX));
mEvent = reshape([sin(2 * pi * 30 * t); sin(2 * pi * 60 * t)], 2, [], 1);
mEvent = repmat(mEvent, 1, 1, sum(vIdx));

mX(vChannels, :,  vIdx) = mX(vChannels, :, vIdx) + mEvent;

%%
tC = zeros(M, M, K);
for kk = 1 : K
    tC(:,:,kk) = cov(mX(:,:,kk)' );
end

mRiemannianMean = RiemannianMean(tC);

%%
mCSR = mRiemannianMean^(-1/2);

MM = M * (M + 1) / 2;
mS = zeros(MM, K);

mW = sqrt(2) * ones(M) - (sqrt(2) - 1) * eye(M);
for kk = 1 : K
    Skk = logm(mCSR * tC(:,:,kk) * mCSR) .* mW;
    mS(:,kk) = Skk(triu(true(size(Skk))));
end

%%
mData = [mS; vIdx];