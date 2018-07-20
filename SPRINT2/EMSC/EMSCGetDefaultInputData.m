function   [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFileName,ChannelWeights,nWeightIter,  ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
            DataCaseName,ASearchDimInput,OptimizedPar,OptStartVector, ...
            CondNumber, RegrMethod,PCName,OptMethod, ...
            FactorNeeded, PunishLongC, PunishHighA, SamplingPrec, ToleranceRMSEP, MaxIter, ...
            ASearchDim,AMax, P, SaveToFile, FilenameOut,PlotIt]=EMSCGetDefaultInputData(DataCase);
% Purpose: Read input data for EMSC/EISC
% Made by: H.Martens January 2003
% (c) Consensus Analysis AS 2003
%
% Related files:
% Called from EMSCGetParametersAndData.m
% Calls  EMSCGetDefaults<date> : a set of defaults for all control parameters
%        EMSC_GetUserDefinedDataCases or EMSCGetInternalDataCases.m
%        EMSCGetReadDefaultInputData.m
%
% Input:
% DataCase (scalar)
%
% Output:
% DirectoryName: name of directory where data are read  and results written
% ZFileName(char): Name of file containing spectral data
% Z(nObj x nZVar): Spectral data (1 spectrum = 1 row)
% ZChannelLabels: Char array with names of Z-variables
% nWeightIter (scalar) # of  iterations with re-estimated ChannelWeights
% ZObjLabels (nObj x ?)(char array): name of objects
% YFileName(char): Name of file containing spectral data
% Y (optional)(nObj x 1) or []:  analyte concentration data  
% YName  (optional): Char array with name of Y-variable
%
% Control parameters:
% MscOrIsc (scalar) 1=MSC (or EMSC), 0=ISC (or EISC)
% WgtFileName (char) name of weight file
% ChannelWeights(1 x nZVar) weights to be used in the least squares estimation, e.g. ones(1,nZVar)
% ModRef (scalar) 
%   MSC/ISC/EMSC/EISC:ModRef=1. 
%   SIS: MscOrIsc=1,ModRef=0
% ModOffset(scalar): offset in the model
%    0=  no offset modelling, 
%    1=  modell,  and subtract the estimated effect,
%    -1= model, but do not subtract the estimated effect, 
% ModChannel(scalar), channel vector (-1:1) in the model
%    0=  no channel vector modelling 
%    1=  model and subtract the estimated effect
%    -1= model, but do not subtract the estimated effect 
% ModSqChannel(scalar),squared channel vector (-1:1)^2 in the model
%    0=  no squared channel vector modelling 
%    1=  model and subtract the estimated effect
%    -1= model, but do not subtract the estimated effect 
% ModSqSpectrum(scalar)  a squared spectrum in the model (MSC/EMSC: squared reference, ISC/EISC: squared individual spectrum)
%    0=  no squared spectrum  modelling 
%    1=  model and subtract the estimated effect
%    -1= model, but do not subtract the estimated effect
%
% Spectral data:
% RefSpectrum(1 x nZVar) spectrum of reference sample, to be used as a regressor in MSC/EMSC,  or as regressand in ISC/EISC
% BadCFileName(char): name of file containing spectral data of the bad components to be modelled and subtracted
% BadC(nBadComp x nZVar) spectra of bad components, 
% BadCName (nBadComp x ?) char array with names of bad components
% GoodCFileName(char): name of file containing spectral data of the good components to be modelled but not subtracted
% GoodC(nGoodComp x nZVar) spectra of good components, 
% GoodCName (nGoodComp x ?) char array with names of  the good components
% DataCaseName (char) name of this case
% ASearchDimInput(scalar) explicit search dimension, default=[];
% OptimizedPar (1 x 3) control of optimzation, 0 or 1, 
%       OptimizedPar(1) for Ref,OptimizedPar(2) for BadC, OptimizedPar(3) for GoodC
% PlotIt (scalar) 1= plot all, 0=reduced plot
% See also definitions in EMSCGetParametersAndData.m
%
% Method: 
% 1. Set the defaults by calling a default script:
% 2. Define deviations from the defaults
% 3. Read the actual data in according to these definitions, by calling script ReadTheDefaultInputData:
% 4. Reinterpret the control mechanisms for optimization:
%
% Related files:  Called from EMSCGetParametersAndData.m 
%                 Calls the function 
%                   EMSCGetOptimizationDefaults.m
%               as well as the scripts
%                   EMSCIESCDefaults.m   Default settings of file names and model def.
%                  
%                   EMSCDefineDataCases.m % Pre-defined examples, which in turn calls 
%              and finally calls function 
%                   EMSCReadTheDefaultInputData.m 
%
%...................................


% 1. Set the defaults by calling a default script:

 [CondNumber, RegrMethod,PCName,OptMethod, ...
                FactorNeeded, PunishLongC, PunishHighA, SamplingPrec, ToleranceRMSEP, MaxIter, ...
                ASearchDim,AMax, P, SaveToFile, FilenameOut,PlotIt]= EMSCGetOptimizationDefaults;
        
EMSCGetDefaults %280103


% 2. Define deviations from the defaults
if  (DataCase >0)&(DataCase<100)
    EMSC_GetUserDefinedDataCases  % or e.g. MyOwnDefaults
   
elseif (DataCase>=100)
    EMSCGetInternalDataCases
    
end % if 


% 3. Read the actual data in according to these definitions, by calling script ReadTheDefaultInputData:

 %EMSCReadTheDefaultInputData
  [ZInputFile, Z,ZChannelLabels,ZObjLabels, ...
        ChannelWeights,WgtName, ...
        RefInputFile, RefSpectrum, RefName, ...
        BadCFileName,BadC,BadCName,GoodCFileName,GoodC,GoodCName, ...
        YInputFile,Y, YName]= EMSCGetReadDefaultInputData(DirectoryName,ZFileName,WgtFileName,RefFileName,FileNameBad, FileNameGood,YFileName,jY, OptPar);



% 4. Reinterpret the control mechanisms for optimization:
[nObj,nZVar]=size(Z);
[nBadObj,nZVb]=size(BadC);
[nGoodObj,nZVg]=size(GoodC);

% OptPar=input('Optimize any of the model spectra? 0=n0, 1=Ref, 2= BadSpectrum, 3=GoodSpectrum')
if OptPar==1,
    OptimizedPar=[1 0 0 ];    RefName=['Opt.',RefName];    OptStartVector=RefSpectrum;
elseif OptPar==2
    OptimizedPar=[0 1 0]; 
    if nBadObj>0,    BadCName=char([cellstr(BadCName); cellstr('OptBad')]);
    else, BadCName= 'OptBad';
    end %if nBadObj;
    OptStartVector=zeros(1,nZVar);BadC=[BadC;OptStartVector];
    % [nBadObj,nZVb]=size(BadC);

elseif OptPar==3
    OptimizedPar=[0 0 1 ]; 
    if nGoodObj>0,    GoodCName=char([cellstr(GoodCName); cellstr('OptGood')]);
    else,  GoodCName= 'OptGood';
    end %if nGoodObj;
    OptStartVector=zeros(1,nZVar);GoodC=[GoodC;OptStartVector];
    % [nGoodObj,nZVb]=size(BadC);
elseif OptPar<0
    OptimizedPar=[0 OptPar OptPar ];OptStartVector=[];
    
else % no optimization!
    OptimizedPar=[0 0 0]; OptStartVector=[];
end %if 


