% File: PLSROneFactorW.m
% Purpose: Estimate parameters for one PLS1 or PLS2 factor
% Made by: H.Martens Jan 1998
% Matlab call: [w,t,q,u,p,E,F,Conv]=PLSROneFactorW(E,F,XWgt2,YWgt2)
% Input: E(nObj x nXVar), F(nObj x nYVar),
%	XWgt2(1 x nXVar),YWgt2(1 x nYVar): weights (NB! only values 0 or 1 works yet!)
% Output: w(nXVar x 1) Loading weight X
%		t(nObj x 1) X scores
%		q(nYVar x 1) Y loadings
%		u(nObj x 1) Y scores
%		p(nXvar x 1) X loadings
%		E (nObj x nXVar) X residuals after this factor
%		F(nObj x nYVar) Y residuals after this factor
%		Conv: Convergence: >0: # of iterations,normal convergence, 
%								 <0: # of iterations, stopped at max iterations
%								 =NaN: Factor is too small to be reliable!
% Remaining issues:
%		Only weights =0 or 1 have been implemented!
%
% Changes:
%	20.1.98 HM: Works
%	21.1.98 HM: Added Max Iterations and Conv output
% 25.4.98 HM: Adapted from PlsrOneFactor.m
% 3.12.98 HM: Changed documentation
% 10.12.98 HM: Forced max t to be positive, except for PLS1
% 10.12.98 HM: Changed conv.crit. computation to avoid division by zero
%  12.1.99 HM: Changed conv.crit. to avoid bad factors based on reg. on zeroes
% 14.1.99 HM: Estimate w by svd of covariance matrix, if not too many factors required
%.........................................................


function [w,t,q,p,E,F]=PLSROneFactor(E,F);

[nObj,nXVar]=size(E); 
[nObjY,nYVar]=size(F);

MaxDim=min(nXVar,nYVar);
if MaxDim<21                         %%%Changed from 10%%%------------

XtY=E'*F;

%if nXVar<=nYVar
%      [vv,ss,uu]=svd(XtY',0);

      %disp('Cov transp'),SizeXtY=size(XtY),ss %keyboard
      %else
[uu,ss,vv]=svd(XtY,0);

          %disp('Cov '),SizeXtY=size(XtY),ss,%keyboard

          %end % if nXVar

w=(uu(:,1));

t=E*w;
tt=t'*t;
invtt=1/max(tt,eps); % inv(tt+eps);
q = (invtt*t'*F)';
%u = ( (ones(nObj,1)*YWgt2).*F )  *q /(max(q'*diag(YWgt2)*q) + eps);
p=(invtt*t'*E)';
if nYVar>1
      	[dummy,itmax]=max(abs(t));
      	Signtmax=sign(t(itmax));
      	if Signtmax~=0
     	 	t=t/Signtmax;
       	w=w*Signtmax;
       	p=p*Signtmax;
       	q=q*Signtmax;
       	end % if Signtmax
 end % if nYVar

% Subtract this factor:
E=E-t*p';
F=F-t*q';
Conv=1;
 


else % use NIPALS       .............
   %disp('Nipals')
   
MaxIter=100; % % 30;
ConvCrit=0.000001 ;%0.01;
LimSqrtww=100*eps; % limit for sqrt (t'*t) for ok factors



% Start with column in Y with the largest variance, or with combination of 1st PC from X and Y

if nYVar > 1
  if 0
    [uy,sy,v]=svd(F.*(ones(nObj,1)*YWgt2),0); %WRONG!!! Wgt2: 2? % use principal component in F as start value
    uy=uy(:,1)*sy(1,1);
    [ux,sx,v]=svd(E.*(ones(nObj,1)*XWgt2),0); %WRONG!!! Wgt2: 2? % use principal component in F as start value
    ux=ux(:,1)*sx(1,1);
    wx=1;wy=1;
    u=(uy*wy+ux*wx)/(wy+wx);
  else
     ssY = sum(F.^2);
     ssY=ssY.*(YWgt2.^2);
    [ymax,j] = max(ssY);
    u = F(:,j)+randn(nObj,1)*max(ssY)*0.1;
  end % if 1
else % 1 y:
    u = F(:,1); 
end % if nYVar>1


  ConvErr = 1;
  told = ones(nObj,1);
  Iter=0;
  Conv=0;
  %  Specify the conversion tolerance 
  while Conv==0 
     Iter=Iter+1;
    % 1. estimate primary loading weights for X
    % Model: X = u*w + e, with ls solution inv(u'*u)*u'*X
    % but since we are going to scale w to length 1 afterwards in any way,
    % we just use:
    w = (u'*   ( E.*(ones(nObj,1)*XWgt2) )   )';
    %Iter,wRaw=w',keyboard
    
    % Then we scale w to length 1:
    Sqrtww=sqrt(w'*w);
    if Sqrtww>LimSqrtww
        FactorOK=1;
        w = w / Sqrtww;
        
        % 2. estimate scores t
        t=E*w;
        tt=t'*t;
        invtt=1/max(tt,eps); % inv(tt+eps);
     else
        FactorOK=0;
        %FactorOK,w,keyboard
        w = w / Sqrtww;
        t=E*w;%t=zeros(nObj,1);
        tt=t'*t;
        invtt=1/max(tt,eps);%invtt=0;
    end % if

    % 3. Estimate loadings Q for Y
         % Model: Y = tq + f:
    q = (invtt*t'*F)';
  
    % Skip iterations when pls1
      if (nYVar == 1)
        break
      end
     
     d=told-t;
      ssd=sum(d.^2)*FactorOK;
      ConvErr = ssd/max(sum(t.^2),10*eps) ;
    

      if ConvErr <= ConvCrit,
         Conv =Iter;
      end
      if Iter>=MaxIter,
         Conv=-Iter;%disp('Max Iter in PLSROneFactor')
         end
      if FactorOK==0
            Conv=NaN;
      end % if
         
      told = t;
      

    % Estimate new scores u, 
      u = ( (ones(nObj,1)*YWgt2).*F )  *q /(max(q'*diag(YWgt2)*q) + eps);
      
  end % while

    % Estimate loadings P for X 
      % Model: E = tp' + E :
      p=(invtt*t'*E)';
     
      % if more than 1 y-variable, then force max(abs(t(:,a)) to be positive:
      if nYVar>1
      	[dummy,itmax]=max(abs(t));
      	Signtmax=sign(t(itmax));
      	if Signtmax~=0
     	 	t=t/Signtmax;
       	w=w*Signtmax;
       	p=p*Signtmax;
       	q=q*Signtmax;
       	end % if Signtmax
   	 end % if nYVar
       
       if 0
       	Cov=diag(XWgt2)*E'*F*diag(YWgt2);
       	[uu,ss,vv]=svd(Cov,0);
       	wCov=(uu(:,1));
          qCov=vv(:,1);
          %model: w=wCov*sign(bw)+eps
          bw=pinv(wCov)*w;
          wCovHat=wCov*sign(bw);
          dw=w-wCovHat;
       	 sdw=sqrt(dw'*dw/sum(XWgt2));
          if sdw>0.2
             disp('error in Nipals!')
             wNipals=w',wEigEF=wCovHat'            
             dw=dw'
             sdw
             keyboard
          end % if
       end %if 0
       
      % Subtract this factor:
      E=E-t*p';
      F=F-t*q';
   end % if MaxDim .............................
   