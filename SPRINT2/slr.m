function [a b] = slr( x, y )
  %%REFERENCE
  %Forecasting: Methods and Applications Hardcover – Dec 29 1997
  %by Spyros G. Makridakis (Author), Steven C. Wheelwright (Author), Rob J. Hyndman (Author) 
  meanX     = mean(x);
  meanY     = mean(y);
  b         = ((x - meanX) * (y - meanY)') / ((x - meanX) * (x - meanX)');
  a         = meanY - ( b * meanX );
end
