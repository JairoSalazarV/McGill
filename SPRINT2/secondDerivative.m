function [derivatedVector] = secondDerivative( vector )
  n                   = length(vector);
  expandedVector      = [ ones(1,3)*vector(1) vector ones(1,3)*vector(end) ];
  coeficients         = [5 0 -3 -4 -3 0 5];
  derivatedVector     = [];
  for pos=4:(3+n)
    tmpWindow         = expandedVector(pos-3:pos+3);
    derivatedVector   = [derivatedVector ((tmpWindow * coeficients')/42)];
  end
end