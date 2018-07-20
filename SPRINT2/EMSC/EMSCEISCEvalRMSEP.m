% function RMSEPCrit = EMSCEISCEvalRMSEP(c,OptionsEMSC,OptionsSearch,OptionPlot)
%   Purpose: Calculating the RMSEPCrit value for a linear combination c of W.
%            Saving Data and Parameters to a file
%   Made By:
%       Morten Beck Rye
%       (c) Consensus Analysis AS 2002
%   Matlab Call: RMSEPCrit = EMSCEISCEvalRMSEP(c,OptionsEMSC,OptionsSearch,OptionPlot)
% 
%   Input: OptionsEMSC; Cell Array, Parameters specified in RunOptEMSC
%          OptionsSearch; Cell Array, Parameters specified in RunOptEMSC
%          c; real vector, linear combination of loadings to be used
%
%   Output: RMSEP; real, RMSEP for linear combination c of  loadings W
%
%   Related files: (starting at RunOptEMSC.m):
%       Called from: EMSCEISCMinima.m
%                    EMSCEISCOpt.m
%
%       Calls:  EMSCModifyModelSpectrum.m
%               EMSCEISC.m
%               EMSCRegressionCheck.m
%               EMSCFindAOpt.m
%
%
%   Method: Uses linear combinations c of loadings W as Extra Model Parameters
%           in an EMSC transformation of Z with respect to Y. PLSR with Cross
%           Validation  or PCR with leverage correction is then used to calculate 
%           RMSEP for the EMSC transformed data. 
%
%           Adds various punishments into an RMSEP criterion:
%           ... (more details required later)
%   
%           Returns the RMSEPCrit value.
%           Writes the transformed data to a file, together with the parameters
%           used in the transformation.  
%
%   Status: 30.04.02 MBR: First spec
%           020203 HM: Works, but why SaveToFile==1 and save ZCorrected from here?

%-------------------------------------------------------------------------------

function RMSEPCrit = EMSCEISCEvalRMSEP(c,OptionsEMSC,OptionsSearch,OptionPlot);
global EMSCLog

Z = OptionsEMSC{1};
ChannelWeights = OptionsEMSC{2}; 
Y = OptionsSearch{1};
YLabels = OptionsSearch{2};
AMax = OptionsSearch{7};
m = OptionsSearch{8};
n = OptionsSearch{9};
W = OptionsSearch{10};
PlotIt=OptionsSearch{11};  
ObjLabels = OptionsSearch{14};
VarLabels = OptionsSearch{15};
OptMethod=OptionsSearch{16}; % 1=use 1 PC,
FactorNeeded=OptionsSearch{17};
PunishLongC=OptionsSearch{18};
PunishHighA=OptionsSearch{19};
OptimizedPar=OptionsSearch{20}; % optimise [ref, bad, good]
OptStartVector=OptionsSearch{21};
RegrMethod=OptionPlot{5}; % 1=PCR
            
ModRef=OptionsEMSC{5};% 0,1,2 or 3

% Modify the spectrum in question (ref, bad or good):
[NormC,SumSpectr,OptionsEMSC]=EMSCModifyModelSpectrum(OptStartVector,c,W,OptionsEMSC,OptimizedPar);

% Performs EMSC on X
% [Matrix, VarLabels] = EMSC(OptionsEMSC);
[ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,LocalEMSCResults] = EMSCEISC(OptionsEMSC,OptionPlot);

%               ZHat=LocalEMSCResults{1} ; % (nObj x nZVar) EMSC-fitted Z spectra (NOT transformed)!
%               RHat=LocalEMSCResults{2} ; % (nObj x nZVar) EISC-fitted Ref. spectra (NOT transformed)! 
%               EHat=LocalEMSCResults{3} ; % (nObj x nZVar) EMSC- or EISC-fitted residual spectra (NOT transformed)!
%               LastCompBeforeChemConstit=LocalEMSCResults{4}  ;%(scalar) index of the last model parameter before the input model spectra
%               LastCompChemConstit=LocalEMSCResults{5}  ;%(scalar) index of the last input model spectrum
%               MeanTrunkatedTModelParam=LocalEMSCResults{6}; % ( 1 x nModelParam) mean trunkated t-value

MaxTrunkatedTModelParam=LocalEMSCResults{7}; % ( 1 x nModelParam) maximum trunkated t-value

% Estimate minimization criterion:.............................................

% Estimate RMSEP at the "optimal" rank, RMSEPAOptp:
[XMean,YMean,WBLM,T,Q,P,E,F,YHat,YHatCV,RMSECY,RMSEPY]=EMSCRegressionCheck(ZCorrected,Y,ChannelWeights,RegrMethod,AMax);
RMSEPY1PC=RMSEPY(2);
[RMSEPYMin, AMin ]=min(RMSEPY);
if OptMethod==1
    AUse=1;
    RMSEPOpt=RMSEPY(1+AUse);
    RMSEPOptp=RMSEPOpt;
    AOptp=AUse;
elseif OptMethod==0
    MSEP=RMSEPY.^2;
    [AOpt,MSEPAOpt]=EMSCFindAOpt(MSEP ,FactorNeeded);    RMSEPAOpt=sqrt(MSEPAOpt);
    MSEPPunished=MSEP.*(1+[0 0 (1:AMax-1)*PunishHighA]);
    [AOptp,MSEPAOptp]=EMSCFindAOpt(MSEPPunished,FactorNeeded);
    if AOptp==0  % At least  1 PC
        AOptp=1; MSEPAOptp=MSEPPunished(AOptp+1);
    end % if AOptp
    AUse=AOptp;
    RMSEPAOptp=sqrt(MSEPAOptp);
else
    error('Wrong OptMethod'),keyboard
end % if
        

% Add punishment due to high norm of the estimated c-vector
%   as a factor proportional to RMSEPAOptp and control parameter PunishLongC
if   (min(OptStartVector)~=0)|(max(OptStartVector)~=0) % not just zeroes in the start vector
         OtherPunishment=RMSEPAOptp*(PunishLongC*(NormC).^2);
     else
         OtherPunishment=RMSEPAOptp*(PunishLongC*(NormC-1).^2);
end % if sum(OptimizedPar)

% Add punishment due to high uncertainty of the estimated c-vector
%   as a factor proportional to RMSEPAOptp and control parameter PunishLongC
TTestLim=2;
BadTTests=max(TTestLim-MaxTrunkatedTModelParam,0) ;
BadTTestPunishment=RMSEPAOptp*sum(BadTTests)*0.1;
%if BadTTestPunishment>0,
%    disp(['BadTTestPunishment=',num2str(BadTTestPunishment)])
%end% if
OtherPunishment=OtherPunishment+BadTTestPunishment;

if 0
% Add punishment due to  negative sum of the estimated spectrum
%   as a factor proportional to RMSEPAOptp and control parameter PunishLongC
if SumSpectr<0
    SumSpectr,keyboard
    OtherPunishment=OtherPunishment + RMSEPAOptp*max(0, -SumSpectr)*0.01;% Force positive sum
end % if 
end % if 0

%.............................................


% Summarize the RMSEP and the other punishments.
RMSEPCrit= RMSEPAOptp + OtherPunishment;


% ............................................

% Save results from this iteration:
[nLastIter,nLog]=size(EMSCLog);
if nLastIter==0
    Iter=1;
else
    Iter=EMSCLog(nLastIter,1)+1;
end % if nLastIter
%         1     2          3       4           5           6        7        8        9         10        ...   ....
LogHere=[Iter,RMSEPCrit,AOptp,RMSEPAOptp, OtherPunishment, AOpt,RMSEPAOpt, RMSEPY1PC,RMSEPYMin,AMin,c,  RMSEPY];
EMSCLog=[EMSCLog;LogHere];


if 0
figure(1),clf
subplot(121)
RMSEPPunished=sqrt(MSEPPunished);
plot((0:AMax),RMSEPY,'b')
hold on
plot((0:AMax),RMSEPPunished,'r')
plot((AOptp),RMSEPPunished(1+AOptp),'r*')
plot((AOptp),OtherPunishment,'k*')
plot((AOptp),RMSEPCrit,'g*')

xlabel('PC#'),ylabel('RMSEP')
title(['AOpt=',num2str(AOpt),', AOptp=',num2str(AOptp),'k=other,g=crit'])

subplot(122)
if OptimizedPar(2)==1
    Sp=OptionsEMSC{11};% =BadC ; % Bad EMSC parameter
else 
    Sp=OptionsEMSC{12};% =GoodC ; 
end %if
plot(Sp')
title(['c=',num2str(c)])
  pause(.1)
end % if 1

