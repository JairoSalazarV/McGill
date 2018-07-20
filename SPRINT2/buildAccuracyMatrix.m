function [resultMatrix] =  buildAccuracyMatrix( y, p )
  %%=========================================================
  %%Build a Result Matrix
  %%=========================================================
  n = length(y);
  
  % Compute PF Matrix
  PP=0; PF=0;
  FP=0; FF=0;
  for i=1:n
    if (p(i)==1) && (y(i) == 1)
      PP++;
    end
    if (p(i)==1) && (y(i) == 0)
      PF++;
    end
    if (p(i)==0) && (y(i) == 1)
      FP++;
    end
    if (p(i)==0) && (y(i) == 0)
      FF++;
    end
  end
  resultMatrix    = [ PP        PF        (PP+PF)
                      FP        FF        (FP+FF) 
                      PP+FP     PF+FF     (PP+PF)+(FP+FF)];
end