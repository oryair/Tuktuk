close all;
clear;

M = 50;
N = 500;

tC = zeros(M,M,N);

for ii = 1 : N
    A          = 10 * rand(1) * randn(M, 1000) + 10 * rand(1);
    tC(:,:,ii) = cov(A');
end

RiemannianMean(tC);