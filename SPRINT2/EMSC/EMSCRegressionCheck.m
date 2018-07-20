function [XMean,YMean,W,T,Q,P,E,F,YHat,YHatCV,RMSECY,RMSEPY]=EMSCRegressionCheck(X,Y,ChannelWeights,RegrMethod,AMax )
% File: EMSCRegressionCheck.m
% Purpose: Estimate the predictive performance of present X and Y data by a reduced-rank weighted least squares regression (PCR or PLSR)
% Made by. H. Martens (c) Consensus Analysis AS 2003
% Related files:
%   Called from EMSCEISCEvalRMSEP.m, EMSCPlotThisDataCase.m
%   Calls: EMSCPCR1B.m   (if RegrMethod==1 )
%       or EMSCPLSR1B.m   (if RegrMethod==2 )
% Input:
%   X(nObj x nXVar) regressors
%   Y(nObj x nXVar) regressands
%   ChannelWeights(1 x nXVar) statistical weights for pre-processing of X
%   RegrMethod(scalar)
%       1= leverage corrected PCR, (fast)
%       2= LOO cross-validated PLSR (slow)
%
%   AMax(scalar) max # of PCs to extract
% Ouput:
%...
% Method:
%           PCR once, and leverage corrects (if RegrMethod==1 )
%       or  PLSR repeatedly during cross-validation (if RegrMethod==2 )
% Version: 020203 HM: Works
%           130203 HM: Changed call to EMSCPCR1B and EMSCPLSR1B
%
 
     %ZW=Z.*(ones(nObj,1)*ChannelWeights);
     
     
[nObj,nXVar]=size(X);

% Weighting the X-variables:
X=X.*(ones(nObj,1)*ChannelWeights);

% Initialization:
YHatCV=zeros(nObj,AMax+1);
FHatCV=YHatCV;

U=zeros(nObj,AMax);
B=zeros(nXVar,AMax);
    


if RegrMethod==1 % leverage corrected PCR
    % Mean centring:
    XMean=mean(X);YMean=mean(Y);
    E=X-ones(nObj,1)*XMean;
    F=Y-ones(nObj,1)*YMean;
    h=ones(nObj,1)/nObj; %  leverage contribution from mean

    %   MSEC after 0 PCs:
    MSECY(1)=mean(F.^2);
        
    % MSEP   after 0 PCs:
    FALevCorr=F./(ones(nObj,1)-h);
    MSEPY(1)=mean(FALevCorr.^2);

    % Compute PCR model
    [B,W,T,P,Q,U,AMax]=EMSCPCR1B(E,F,AMax);
    
    % Prediction of Y, with leverage correction:
    for a=1:AMax
        FA=F-T(:,1:a)*Q(:,1:a)';
        YHat(:,1+a)=F-FA;
        MSECY(1+a)=mean(FA.^2);
        
        % Leverage correction:
        h=h + U(:,a).^2;
        FALevCorr=FA./(ones(nObj,1)-h);
        YHatCV(:,1+a)=F-FALevCorr;
        MSEPY(1+a)=mean(FALevCorr.^2);
    end % for a
    
elseif RegrMethod==2 % PLSR with full cross validation
    % Mean centring:
    XMean=mean(X);YMean=mean(Y);
    E=X-ones(nObj,1)*XMean;
    F=Y-ones(nObj,1)*YMean;
    
    %   MSEC after 0 PCs:
    MSECY(1)=mean(F.^2);
    
    % Compute the PLSR model:
    [B,W,T,P,Q,AMax]=EMSCPLSR1B(E,F,AMax);
    for a=1:AMax
      b=B(:,a); b0=YMean-XMean*b;
      YHat(:,1+a)=  b0 + X*b;
      FHat(:,1+a)= YHat(:,1+a) - Y;
      MSECY(1+a)=mean(FHat(:,1+a).^2);
    end % for a
    
    % Cross-validation:
    YHatCV=zeros(nObj,1+AMax);
    FHatCV=YHatCV;
    for i=1:nObj
        % Split the objects for this CV set
        Obj=ones(nObj,1); 
        Obj(i)=0;
        XMod=X((Obj==1),:); YMod=Y((Obj==1),:); % Local calibration modelling set
        [nObjMod,d]=size(XMod);
        
        % Mean centring of local set
        XModMean=mean(XMod);YModMean=mean(YMod); % Local means
        EMod=XMod-ones(nObjMod,1)*XModMean; FMod=YMod-ones(nObjMod,1)*YModMean;   
        XPred=X(i,:); YPred=Y(i,:);  % Data of pred. set
        YHatCV(i,1)=YModMean; % Prediction after 0 PCs in pred. set
        FHatCV(i,1)=YPred-YHatCV(i,1); % Error in Y- pred. after 0 PCs in pred. set

        % Compute the local PLSR model:
        [Bi,Wi,Ti,Pi,Qi ]=PLSR1B(EMod,FMod,AMax);
          
        for a=1:AMax
            b=Bi(:,a); b0=YModMean-XModMean*b;
            YHatCV(i,1+a)=  b0 + XPred*b;
            FHatCV(i,1+a)= YHatCV(i,1+a) - YPred;
        end %for a
    end % for i
    MSEPY=mean(FHatCV.^2);
     
end % if RegrMethod
    
RMSECY=sqrt(MSECY);
RMSEPY=sqrt(MSEPY);

