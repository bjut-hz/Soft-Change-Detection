%read the input image
[Xt1, map1] = imread( 'cuts80.gif', 'gif', 'frame', 'all' );
[Xt2, map2] = imread( 'cuts90.gif', 'gif', 'frame', 'all' );

Xt1_RGB = ind2rgb( Xt1, map1 );
Xt2_RGB = ind2rgb( Xt2, map2 );

%lightness normalization
New_Xt2_RGB = Xt2_RGB .* ( sum(Xt1_RGB(:)) / sum(Xt2_RGB(:)) );

%difference image
Xd = abs( rgb2gray( Xt1_RGB ) - rgb2gray( New_Xt2_RGB ) );

%obtain three regions by the threshold selection method
%threshold value: (definitely unchanged region) Tn = Md * ( 1 - beta )
%(definitely changed region) Tc = Md * ( 1 + beta ), beta is on the inteval (0, 1)
%Md denotes the median.
beta = 0.1;
Md = ( max( Xd(:)) + min( Xd(:))) / 2;
Tn = Md * ( 1 - beta );
Tc = Md * ( 1 + beta );
Sn = sparse( Xd < Tn );
Sc = sparse( Xd > Tc );

%alpha image initialization
%we assign th initial estimate of alpha with 1; whereas 0 is assigned to
%the definitely unchanged region.
alpha = Xd;
alpha( Sc ) = 1;
alpha( Sn ) = 0;

C = New_Xt2_RGB;
sigma = 1;





