% File: EMSCPLSR2.m
% Purpose: Weighted PLS1 and PLS2 regression
% Matlab call: [XMean,YMean,W,T,Q,U,P,E,F,BAllA,b0AllA,Conv]=PLSRW(X,Y,AMax,XWgt2,YWgt2);
% Input: X(nObj x nXVar), Y(nObj x nYVar) uncentered (?), but weighted data
%	AMax (Scalar) Max number of factors to be computed
% XWgt2(1 x nXVar), YWgt2(1 x nYVar) Squared weights to be used for est. scores (nb! only 0 or 1 allowed yet) 
% Output:
%	XMean,YMean,W,T,Q,U,P,
%	E,F
% BAllA(1:AMax,nXVar*nYVar): B coefficients for 0:AMax factors
% b0AllA(1:AMax,nYVar): b0 coefficients for 0:AMax factors.
% Conv(1:AMax) convergence:  >0: # of iterations,normal convergence, 
%								 	  <0: # of iterations, stopped at max iterations
%								 	  =NaN: Factor is too small to be reliable!
% Remaining issues: Only weights 0 or 1 allowed yet!
%Changes:
% 25.4.98 HM: ADAPTED FROM Plsr.m
% 3.12.98 HM: Changed doc.
%   13.2.03 HM: Changed file name
%.................................


function [XMean,YMean,W,T,Q,U,P,E,F]=EMSCPLSR2(X,Y,AMax);

%JackKnifeB=1;

[nObj,nXVar]=size(X);
[nObjY,nYVar]=size(Y);

%if nObj ~=nObjY,error('X and Y not same number of objects')
%   nObjX=nObj,nObjY
%end % if nObj


 XMean=mean(X); 
 YMean=mean(Y);
 E=X-ones(nObj,1)*XMean; 
 F=Y-ones(nObj,1)*YMean;
 W=[];T=[];Q=[];U=[];P=[];
 

% E0=E;F0=F; BFullRAnk=pinv(E0)*F0;
 
 %if JackKnifeB==1
 %  BAllA=zeros(AMax,nXVar*nYVar);
 %  b0AllA=zeros(AMax,nYVar);
 %  %BAllA(1,:)=zeros(1,nXVar*nYVar);
 %  b0AllA(1,:)=YMean;   
 %else
 %   BAllA=[];b0AllA=[];
 %end % if JackKnifeB

 
 for a=1:AMax
      % Calibrate:
      [w,t,q,p,E,F]=PLSROneFactor(E,F);
      
      W=[W w];
      T=[T t];
      Q=[Q q];
      %U=[U u];
      P=[P p];

 %     Conv(a)=Conva;
      
 %     if JackKnifeB==1
 %        PWa=P'*W;
 %        PWa=PWa+eye(a)*max(abs(PWa(:)))/1000;
 %        InvPWa=inv(PWa );
 %        Ba=W*InvPWa*Q';
 %        b0a=YMean-XMean*Ba;
 %        BAllA(a,:)=reshape(Ba,1,nXVar*nYVar);
 %        b0AllA(a,:)=b0a;
 %    end  % if JackKnifeB

end % for a
   
