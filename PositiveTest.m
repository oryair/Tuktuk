close all;
clear;

N = 10;
A = randn(N);
A = A * A';

D = dftmtx(N)

sort(eig(A))
% sort(real(eig(D * A * D'))) / N
sort(real(eig(fft2(A)))) / N

%%
v   = rand(N, 1);
DDD = abs(D * v - fft(v));
max(DDD(:))

%%
M   = randn(N, N);
F1  = fft2(M);;
% F2  = (D * (D * M).').';
F2  = (D * M * D.');


% DDD = abs(D * M * D' - fft(fft(M).').');
DDD = abs(F2 - F1);
max(DDD(:))

figure; imagesc(abs(F1)); colorbar;
figure; imagesc(abs(F2)); colorbar;

%%
