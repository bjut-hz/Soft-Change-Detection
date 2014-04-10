function [ Cnbr, Cwts, alphaavg ] = compute_nbrhood_data( i, j, nbrSize, sigmaFalloff, C, alphaimg, maskimage )


%Nr: row of C
%Nc: column of C
%Nch: number of channel
Nr = size( C, 1 );
Nc = size( C, 2 );
Nch = size( C, 3 );

imin = max( 1, i - floor( nbrSize / 2 ) );
imax = min( Nr, i + floor( nbrSize / 2 ) );

jmin = max( 1, j - floor( nbrSize / 2 ) );
jmax = min( Nc, j + floor( nbrSize / 2 ) );

alphaavg = 0;
nbrCount = 0;

Cnbr( nbrSize * nbrSize, 3 ) = 0;
Cwts( nbrSize * nbrSize, 1 ) = 0;

Csize = 0;

for c = jmin:jmax
    for r = imin:imax
        if( maskimage( r, c) )
            %evaluate values at pt( r, c )
            nbrCount = nbrCount + 1;
            alpha = alphaimg( r, c );
            gaussFalloff = exp( -( ((r-i)^2 + (c-j)^2)/(  2*(sigmaFalloff^2)  ) )  );
            Cwt = ( alpha^2 ) * gaussFalloff;
            for ch = 1:Nch
                Cpt( ch ) = C( r, c, ch );
            end
            
            alphaavg = alphaavg + alpha;
            if( alpha ~= 0 )
                Csize = Csize + 1;
                Cnbr( Csize, : ) = Cpt;
                Cwts( Csize ) = Cwt;
            end
            
        end
    end
end

Cnbr = Cnbr( 1:Csize, : );
Cwts = Cwts( 1:Csize );

if( nbrCount )
    alphaavg = alphaavg / nbrCount;
end


