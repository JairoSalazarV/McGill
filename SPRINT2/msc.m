function [MSC_X] = msc(X)
  %%REFERENCE
  %Input:  NxL (N samples, L dimensions)
  %Output: Corrected X using Multiplicative Scaller Correction
  %A user‐friendly guide to multivariate calibration and classification, 
  %Tomas Naes, Tomas Isakson, Tom Fearn and Tony Davies, NIR Publications, 
  %Chichester, 2002
  x           = mean(X,1);
  MSC_X       = [];
  for i=1:size(X,1)
    y         = X(i,:);
    [a b]     = slr(x,y);
    yCalc     = (y-a) / b;
    MSC_X     = [MSC_X;yCalc];
  end
end
