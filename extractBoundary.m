function boundary=extractBoundary(maskimage)
%
%boundary=extractBoundary(maskimage)
%extracts boundary points of a maskimage
%
%maskimage: any boolean image
%
%boundary: boolean image with 1 at boundary points and 0 elsewhere

[Nr, Nc]=size(maskimage);
rowzero(1:Nc)=0;
colzero(1:Nr)=0;
colzero=colzero';

boundary1=diff(maskimage, 1, 1);
boundary1_1=boundary1<0;
boundary1_2=boundary1>0;
boundary1_1=[rowzero;boundary1_1];
boundary1_2=[boundary1_2;rowzero];

boundary1=boundary1_1 | boundary1_2;

boundary2=diff(maskimage, 1, 2);
boundary2_1=boundary2<0;
boundary2_2=boundary2>0;
boundary2_1=[colzero, boundary2_1];
boundary2_2=[boundary2_2, colzero];

boundary2=boundary2_1 | boundary2_2;

boundary=boundary1 | boundary2;
