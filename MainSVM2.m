close all;
clear;

N       = 3;
D       = 25;
M       = 2000;
Npoints = N * 200;
vT      = linspace(0, 1, M + 1); vT(end) = [];
f0      = 100;
f1      = 10;

noiseStd = .1;

vY = zeros(1, Npoints);
tC = zeros(D, D, Npoints);
kk = 0;
for ii = 1 : N
    for jj = 1 : (Npoints / N)
        
        switch ii
            case 1
                mXi = noiseStd * randn(D, M);
            case 2
                f   = (1 + .5 * randn(1)) * f0;
                mXi = bsxfun(@plus, noiseStd * randn(D, M), sin(2 * pi * f * vT));
            case 3
                f   = (1 + .5 * randn(1)) * f1;
                mXi = bsxfun(@plus, noiseStd * randn(D, M), sin(2 * pi * f * vT) .* exp(-3 * vT));
        end
                
        mCi        = cov(mXi');
        kk         = kk + 1;
        tC(:,:,kk) = mCi;
        vY(kk)     = ii;
        
    end
end

mCref = RiemannianMean(tC);
B     = mCref^(-1/2);

mS = zeros(D * (D + 1) / 2, Npoints);
WW = triu(sqrt(2) * ones(D), 1) + eye(D);
      
for ii = 1 :Npoints
    S  = logm(B * tC(:,:,ii) * B);
    MM = WW .* S;
    mS(:,ii) = MM(triu(true(size(MM))));
end

mX = [mS; vY];

%%
mW  = squareform( pdist(mS') );
eps = 10 * median(mW(:));
mK  = exp( -mW.^2 / eps.^2 );
mA  = bsxfun(@rdivide, mK, sum(mK, 2));
[mPhi, mLam] = eig(mA);

%%
figure; scatter3(mPhi(:,2), mPhi(:,3), mPhi(:,4), 100, vY, 'Fill'); colorbar;
