function [mX, vIdx] = getDataTest(params)

M           = params.M;
K           = params.K;
N           = params.N;
p           = params.p;
vChannels   = params.vChannels;
t           = linspace(0, 1, N + 1); t(end) = [];

p1 = 1;
vChannelsDistract = 3;
%%
mX           = params.noise*randn(M, N, K);
vIdx         = rand(1, K) < p;
vIdxDistarct = vIdx;%rand(1, K) < p1;


% mEvent = zeros(size(mX));
% mEvent = reshape([sin(2 * pi * 30 * t); sin(2 * pi * 60 * t)], 2, [], 1);
mEvent = reshape([sin(2 * pi * 30 * t); sin(2 * pi * 30 * (t + 10/N))], 2, [], 1);
mEvent = repmat(mEvent, 1, 1, sum(vIdx));

mX(vChannels, :,  vIdx) = mX(vChannels, :, vIdx) + mEvent;

mDistract = reshape(sin(2 * pi * 50 * (t + 5/N)), 1, [], 1);
mDistract = repmat(mDistract, 1, 1, sum(vIdxDistarct));

mX(vChannelsDistract, :,  vIdxDistarct) = mX(vChannelsDistract, :, vIdxDistarct) + mDistract;


