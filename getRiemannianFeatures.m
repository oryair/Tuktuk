function mS = getRiemannianFeatures(mX,params)

M = size(mX,1);
K = size(mX,3);
%%
tC = zeros(M, M, K);
for kk = 1 : K
    
    switch (params.type)
        case 'covariance'
            tC(:,:,kk) = cov(mX(:,:,kk)' );
            
        case 'covarianceFreq'
            D           = dftmtx(M);
            mCDft       = D*cov(mX(:,:,kk)')*D.';
            phaseX      = (angle(mCDft(1,2)) - angle(mCDft(1,1)))*M/(2*pi);
            phaseY      = (angle(mCDft(2,1)) - angle(mCDft(1,1)))*M/(2*pi);
            wx          = (0:2*pi:2*pi*(M-1))/M;
            [Wx,Wy]     = meshgrid(wx,wx); 
            phase       = angle(mCDft) - phaseX*Wx - phaseY*Wy;
%             mCDft       = abs(mCDft).*exp(1j*phase);
            mCDft       = abs(mCDft);
            tC(:,:,kk)  = real(D'*mCDft*conj(D)/M^2);
%             min(eig(tC(:,:,kk)))

        case 'connectivity'
            Pairs      = CalcPairs(mX(:,:,kk)');
            tC(:,:,kk) = CalcSig(Pairs);
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