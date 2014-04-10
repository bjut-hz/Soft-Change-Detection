function likelihood = likelihood( Xt1, Xt2, C, alpha, sigma, Cmean, Csigmainv )

term1 = -1 * ( sum(( Xt2 - alpha*C - ( 1-alpha ) * Xt1 ).^2 )) / ( sigma ^ 2 );
term2 = -(( C - Cmean )' * Csigmainv * ( C - Cmean )) / 2;

likelihood = term1 + term2;