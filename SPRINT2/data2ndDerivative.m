function [secondData] = data2ndDerivative( DATA )
  [R C] = size(DATA);
  secondData = [];
  for i=1:R
    secondData  = [secondData; secondDerivative( DATA(i,:) )];
  end
end