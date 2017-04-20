function mS = getRiemannianFeatures(mX,params)

M = size(mX,1);
K = size(mX,3);
%%
tC = zeros(M, M, K);
for kk = 1 : K
    
    switch (params.type)
        case 'covariance'
            tC(:,:,kk) = cov(mX(:,:,kk)' );
            
        case 'connectivity'
            Pairs      = CalcPairs(mX(:,:,kk)');
            tC(:,:,kk) = CalcSig(Pairs);
            min(eig(tC(:,:,kk)));
    end
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