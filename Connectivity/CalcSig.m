function mSig = CalcSig(Pairs)

    N      = length(Pairs);
    mAnorm = zeros(N, N);
    for ii = 1 : N
        mPi = Pairs{ii};
        for jj = (ii + 1) : N
            mPj = Pairs{jj};
            mAnorm(ii,jj) = norm(mPj * mPi' - mPi * mPj', 'fro');
            mAnorm(jj,ii) = mAnorm(ii,jj);
        end
    end
    
    eps  = median(mAnorm(:));
    mSig = exp( -mAnorm.^2 / eps^2 );
    
end