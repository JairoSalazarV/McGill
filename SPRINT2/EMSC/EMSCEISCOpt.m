% function [cOpt,OptRMSEP,EXITFLAGFminsearch,OUTPUT,OptionsSearch, ...
%    ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,  ...
%      OptionsEMSC, LocalEMSCResults ] = EMSCEISCOpt(OptionsEMSC, OptionsSearch,OptionPlot)
%   Purpose: Performs a three step Optimized EMSC/EISC on spectra 
%   Made By:
%       Morten Beck Rye and Harald Martens
%       (c) Consensus Analysis AS 2002
% 
%   Input: OptionsEMSC; Cell Array, Parameters specified in RunOptEMSC
%          OptionsSearch; Cell Array, Parameters specified in RunOptEMSC
%       ...
%   Output:  ...
%  
%
%   Related files: 
%       Called from  EMSC_Main.m
%       Calls 
%                  EMSCPLSR2.m - Can be replaced by any PLSR or a PCA
%                  EMSCEISCMapping.m
%                  EMSCEISCMinima.m
%                  EMSCModifyModelSpectrum.m
%                  EMSCEISCEvalRMSEP.m
%                  EMSCEISC.m
%
%
%   Method: Performs a two step search for the optimum Extra Model Parameters
%           to use in an EMSC transformation of Z, with respect to the data
%           Y. The Extra Model Parameters are chosen as different linear 
%           combinations of the Loadings P from an initial PLSR or PCA analysis
%           on Z. In the first step the RMSEP for Y is mapped for a selection
%           of linear combinations of W. Then the linear combination with the 
%           lowest RMSEP for Y is selected as a starting point for minima search,
%           the goal being to obtain the lowest RMSEP for Y
%
%   Status: 30.04.02 MBR: First spec
%           5.1.03 HM: MOdified
%   Remaining issues: Documentation not yet finished
%
%-------------------------------------------------------------------------------

function [cOpt,OptRMSEP,EXITFLAGFminsearch,OUTPUT,OptionsSearch, ...
    ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam, ...
      OptionsEMSC, LocalEMSCResults] = EMSCEISCOpt(OptionsEMSC, OptionsSearch,OptionPlot)

global EMSCLog

X = OptionsEMSC{1};
Y = OptionsSearch{1};
ASearchDim = OptionsSearch{6};

[nObj,nXVar]=size(X);

if 0
    % Initial PLSR. Can be replaced by PCA or any other PLSR that returns Loadings P
    [XMean,YMean,W,T,Q,U,P,E,F]=EMSCPLSR2(X,Y,ASearchDim);
else
    % SVD: Non-centred
    if nObj>=nXVar 
        [U,S,V]=svd(X,0);

    else
        [V,S,U]=svd(X',0);
    end % if nObj 
    
    W=V(:,1:ASearchDim)*S(1:ASearchDim,1:ASearchDim);
    % Turn sign so that sum is positive:
    for a=1:ASearchDim
        w=W(:,a);
        s=sign(sum(w));
        if s~=0
            W(:,a)=w*s;
        end % if
    end %for a
end % if

OptionsSearch{10} = W;
PlotIt=OptionPlot{1}; 
OptionPlot{1}=0;%Temporarily turning off plots

% Initial mapping of RMSEP for different directions in the loadingspace

tic
[rmsepMap,C] = EMSCEISCMapping(OptionsEMSC, OptionsSearch,OptionPlot);
TimeForFindingStartPoint=toc

[nLastIter,nLog]=size(EMSCLog);
%EMSCLog(nLastIter,1)=EMSCLog(nLastIter,1);
if PlotIt>2
    TimeForFindingStartPoint
    disp('      1     2          3            4           5             6        7      ')
    disp('    Iter,  RMSEPCrit,  AOptp,  RMSEPAOptp, OtherPun., AOpt,  RMSEPAOpt')
    EMSCLog(:,1:7)

    disp('After initial mapping to find start values for optimization')
    pause(.1)
    %keyboard
end %if PlotIt>2

% Selects direction in loading space with lowest RMSEP  
[d,i] = min(rmsepMap);
c = C(i,:);
clear C
 

% Performs a search for minima around the point with lowest RMSEP from LoadinSearch
tic
[c,OptRMSEP,EXITFLAGFminsearch,OUTPUT ] = EMSCEISCMinima(c,OptionsEMSC,OptionsSearch,OptionPlot);
cOpt=c;
TimeForFindingOptimum=toc

OptimizedPar=OptionsSearch{20}; % optimise [ref, bad, good]
W = OptionsSearch{10};
OptStartVector=OptionsSearch{21};

% Modify the spectrum in question (ref, bad or good):
[NormC,SumSpectr,OptionsEMSC]=EMSCModifyModelSpectrum(OptStartVector,cOpt,W,OptionsEMSC,OptimizedPar);


 
% After convergence, Plot and save:

SaveToFile=0; % turned off
OptionsSearch{12}=SaveToFile; % removed

RMSEPCrit = EMSCEISCEvalRMSEP(cOpt,OptionsEMSC,OptionsSearch,OptionPlot);


OptionPlot{1}=PlotIt; % Turn on again the temporary plot hault
OptionsSearch{11}=PlotIt;

[ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,LocalEMSCResults] = EMSCEISC(OptionsEMSC,OptionPlot);

