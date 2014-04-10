function [ C, alphaimg ] = bayesian_change_detection( Xt1, Xt2, maskimage, alphaHard, sigma, nbrSize, sigmaFalloff )
%[ C, alpha ] = bayesian_change_detection( Xt1, Xt2, maskimage, alpha, sigma, nbrSize, sigmaFalloff );
%   Detailed explanation goes here

C = Xt2;
alphaimg = alphaHard;

boundaryimg = sparse( extractBoundary( maskimage ) );

boundarysize = 1;
while( boundarysize ),%loop till boundary vanishes, i.e. all values are determined
    counter = 0;
    [ boundaryListI, boundaryListJ ]=find( boundaryimg );%will give a list of points on the boundary
    boundarysize = size( boundaryListI, 1 );
    maskimageNext = maskimage;
    maskimageNext( boundaryimg(:) ) = 1;%maskimageNext will be the maskimage in the next iteration. Used for updateboundary
    for boundaryIndex = 1:boundarysize,
		% i and j denote the boundary index	
        i = boundaryListI( boundaryIndex );
        j = boundaryListJ( boundaryIndex );
        boundaryimg = updateboundary( i, j, maskimageNext, boundaryimg );%updates the boundaryimg by observing neighbourhood around (i,j)
        maskimage( i, j ) = 1;
        [ c, alpha ] = bayesian_optimise( i, j, Xt1, Xt2, C, alphaimg, maskimage, sigma, nbrSize, sigmaFalloff );%computes the MAP estimate C and alpha at (i,j)
       
        %update values
        C( i, j, : ) = c;
        alphaimg( i, j ) = alpha;     
        
        %display progress
        counter = counter + 1
        boundarysize 
    end  
end




