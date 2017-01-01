function M = RiemannianMean(tC)

M = mean(tC, 3);

for ii = 1 : 2
    S = zeros(size(M));
    A = M ^ (1/2);
    B = A ^ (-1);
    for jj = 1 : size(tC, 3)
        C = tC(:,:,jj);
        S = S + A * logm(B * C * B) * A;
    end
    M = A * expm(B * S * B) * A; 
    
    norm(S, 'fro')
end

end