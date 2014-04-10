function [ c, alpha ] = bayesian_optimise(  i, j, Xt1, Xt2, C, alphaimg, maskimage, sigma, nbrSize, sigmaFalloff ) 

%obatain the number of channels in the input image
Nch = size( Xt1, 3 );

for ch = 1:Nch
   xt1( ch ) = Xt1( i, j, ch );
   xt2( ch ) = Xt2( i, j, ch );
end

xt1 = xt1';
xt2 = xt2';

[ Cnbr, Cwts, alphaavg ] = compute_nbrhood_data( i, j, nbrSize, sigmaFalloff, C, alphaimg, maskimage );

Nclusters = 4;
if( size( Cnbr, 1) < 100 )
    Nclusters = 1;
end

if( Nclusters <= 1 )
    Nclusters = 1;
    Cnbrlist{1} = Cnbr;
    Cwtslist{1} = Cwts;
else
    IDC = kmeans( Cnbr, Nclusters, 'EmptyAction', 'singleton');
    
    Cnbrlist = separateClusters( Cnbr, IDC, Nclusters );
    Cwtslist = separateClusters( Cwts, IDC, Nclusters );
end


for i = 1:Nclusters
   if( size( Cwtslist{i},1 ) ) % neighhood not empty
       %compute weighted mean and weighted covariance matrix from the neighbourhood pts
       [ Cmeanlist{i}, Csigmalist{i} ] = compute_mean_sigma( Cnbrlist{i}, Cwtslist{i} ); 
   else
       Cmeanlist{i} = [ 0 0 0 ]';
       Csigmalist{i} = eye( 3, 3 );
   end
end


%initialization

for i = 1:Nclusters
   Csigmainvlist{i} = inv( Csigmalist{i} ); 
end

I = eye( 3, 3 );
cbest = zeros( Nch, 1 );
alphabest = 0;
likelihoodbest = -9999999999;

%Optimization loop

for i = 1:Nclusters
   alpha = alphaavg;
   alphaprev = alpha;
   Cmean = Cmeanlist{i};
   Csigmainv = Csigmainvlist{i};
   satisfied = false;
   loopcount = 0;
   while( ~satisfied )
       term1 = Csigmainv * Cmean + ( xt2 * alpha ) / ( sigma^2 ) - ( I * alpha * ( 1 - alpha ) * xt1)/( sigma^2 );
       term2 = Csigmainv + I * ( alpha ^ 2) / ( sigma^2 );
       c = inv( term2 ) * term1;
       %c = term1 \ term2;
       
       alpha = dot( ( xt2 - xt1 )', ( c - xt1 )) / ( sum( ( c - xt1 ).^2 ));
       
       if( (abs(alphaprev-alpha)<.001 && loopcount>3) || loopcount>20 )
           satisfied = true;
       end
       alphaprev = alpha;
       loopcount = loopcount + 1;
   end
   likelihoodlvalue = likelihood( xt1, xt2, c, alpha, sigma, Cmean, Csigmainv );
   if( likelihoodlvalue > likelihoodbest )
       cbest = c;
       alphabest = alpha;
       likelihoodbest = likelihoodlvalue;     
   end
end

c = cbest;
alpha = alphabest;

