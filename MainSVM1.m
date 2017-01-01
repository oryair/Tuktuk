close all;
clear;

D = 2;
Nburst  = 100;
Npoints = 1000;
Nclass  = 4;

mT = [10, 0;
      0, 1];

mX = zeros(D, 0);
vY = zeros(1, Npoints);
tC = zeros(D, D, Npoints);
% figure; hold on; axis equal; vC = 'bgrk';

kk = 0;
for ii = 1 : Nclass
    a    = pi / 16 * (ii - 1);
    mR   = [cos(a), -sin(a);
            sin(a),  cos(a)];
    for jj = 1 : (Npoints / Nclass)
        
        mXi        = mR * mT * randn(D, Nburst);
        mCi        = cov(mXi');
        kk         = kk + 1;
        tC(:,:,kk) = mCi;
        vY(kk)     = ii;
        
%     mX(:, end + 1 : end + Nburst) = mXi;
%     plot(mXi(1,:), mXi(2,:), ['+', vC(ii)]);
    end
end

mCref = RiemannianMean(tC);
B     = mCref^(-1/2);

mS = zeros(3, Npoints);
WW = triu(sqrt(2) * ones(D), 1) + eye(D);
      
for ii = 1 :Npoints
    S  = logm(B * tC(:,:,ii) * B);
    MM = WW .* S;
    mS(:,ii) = MM(triu(true(size(MM))));
end





%%
% M = 2;
% N = 1000;
% 
% mX1 = randn(M, N) + 1;
% mX2 = randn(M, N) - 1;
% mX3 = randn(M, N) - 0;
% 
% mX  = [mX1, mX2, mX3];
% mY  = [0 * ones(1, N), 1 * ones(1, N), 2 * ones(1, N)];
% 
% mX(end + 1, :) = mY;