function sigmaNew=addvariance(sigmaOrig, Csigma)
%
%sigmaNew=addvariance(sigmaOrig, Csigma)
%adds Csigma to the covariance matrix sigmaOrig to give sigmaNew

[U S V]=svd(sigmaOrig);

Nch=size(sigmaOrig,1);
for ch=1:Nch,
    S(ch,ch)=S(ch,ch)+Csigma^2;
end
sigmaNew=U*S*V';
