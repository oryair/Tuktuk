close all;
clear;

M = 1000;
A = randn(M, 25);

addpath('Connectivity');

% tic;
Paris = CalcPairs(A);
% toc;
% tic;
mSig  = CalcSig(Paris);
% toc;
