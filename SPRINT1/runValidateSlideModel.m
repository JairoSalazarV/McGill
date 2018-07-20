function [resultMatrix, y, p]  = runValidateSlideModel(dataPath, optimizerName, idSlide, theta)
  %%=========================================================
  %%Read Dataset
  %%=========================================================
  load( dataPath );
  data    = [allSlidesAVG.fertileEggsAVGSignatures{idSlide}.mean;...
             allSlidesAVG.nonfertileEggsAVGSignatures{idSlide}.mean];
  [n, L]  = size(data);
  X       = data(:,1:L-1);
  y       = data(:,L);
  
  %%=========================================================
  %%Validate Model
  %%=========================================================
  if strcmp(optimizerName, "multiRLR")
    p     = predict(theta, X);
  end    
  
  %%=========================================================
  %%Build a Result Matrix
  %%=========================================================
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
  %nF              = size( find(y == 1), 1 );
  %nNF             = size( find(y == 0), 1 );
  resultMatrix    = [ PP PF (PP+PF); FP FF (FP+FF) ];
end