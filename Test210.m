close all;
clear;

N = 10;
for ii = 1 : N
    A{ii}      = rand(N);
    A{ii}      = A{ii} ./ sum(A{ii});
    
    [V{ii}, ~] = eigs(A{ii}, 1);
end

M = zeros(N);
for ii = 1 : N
    for jj = 1 : N
        M(ii, jj) = norm(A{ii} * V{jj} - A{jj} * V{ii});
    end
end
% M = M + M';

K = exp(-M.^2);

min(eig(K))