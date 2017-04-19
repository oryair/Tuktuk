function Pairs = CalcPairs(mS)

    for ii = 1 : size(mS, 2)
       
        vS = mS(:,ii);
        mD = squareform( pdist(vS) );
        
        eps = median(mD(:));
        
        Pairs{ii} = exp( -mD.^2 / eps^2 );
        
    end

end