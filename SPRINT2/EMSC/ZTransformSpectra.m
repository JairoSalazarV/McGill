function [X2]= ZTransformSpectra(TransformMethod,X,D,RTMin);
if TransformMethod==1
    ZMinusSpecular=max(X-D,RTMin);
    X2=-log10(ZMinusSpecular);
elseif TransformMethod==2
    ZMinusSpecular=max(X-D,RTMin);
    X2=(1-ZMinusSpecular)./(2*ZMinusSpecular);
    elseif TransformMethod==3
    ZMinusSpecular=max(X-D,RTMin);
    X2=((1-ZMinusSpecular)./(2*ZMinusSpecular));
    X2=X2.*( (ones(size(X2))*6)./(5*ZMinusSpecular) );

else
    
    TransformMethod
    error('Wrong TransformMethod')
end %if