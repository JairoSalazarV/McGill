function [meanCenterData] = dataMeanCenter( DATA )
  [R C]             = size(DATA);
  dataMean          = mean(DATA,1);
  dataStd           = mean(DATA,1);
  meanCenterData    = [];
  for i=1:R
    x = DATA(i,:);
    meanCenterData  = [meanCenterData; (x-dataMean)./dataStd];
    %meanCenterData  = [meanCenterData; (x-dataMean)];
  end
end