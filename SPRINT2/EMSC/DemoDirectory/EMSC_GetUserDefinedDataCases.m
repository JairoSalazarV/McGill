% File EMSC_GetUserDefinedDataCases.m
% Purpose: Allows the user to define standard conditions for EMSC/EISC preprocessing
% Called from GetDefaultInputData.m if 0<DataCase<100.
% Made by: H. Martens January 2003
%
% Related files:
%       Called from EMSCGetDefaultInputData.m
%       seel also 
%
% Defaults values of all parameters have been set in functions 
%       EMSCGetOptimizationDefaults.m or EMSCGetDefaults.m
% Alternative EMSC/EISC calibration method combinations are defined in EMSCGetInternalDataCases.m  

% These defaults may here optionally  be modified here by the user:

%............................................................
%
% ZFileName(char): Name of file containing spectral data
% WgtFileName (char) name of weight file (default=[]; all elements in ChannelWeights =1), 
%                           The ChannelWeights may be modified  automatically if nWeightIter>0
% YFileName(char): Name of file containing spectral data (default=EMSC_Y.mat, jY=1; , i.e. Y= column 1 in the data matrix in file EMSC_Y.mat)
% jY (scalar) Index if there are more than one Y-variable read
% FileNameGood(char): name of file containing spectral data of the good components to be modelled but not subtracted (default=[], i.e. no good spectra to be modelled)
% FileNameBad(char): name of file containing spectral data of the bad components to be modelled and subtracted; (default=[], i.e. no bad spectra to be modelled)
% RefFileName (char): name of file containing reference spectrum (default=[]; i.e. defines reference spectrum internally, as mean(Z))
%
% Control parameters:
% MscOrIsc (scalar) 1=MSC (or EMSC), -1=ISC (or EISC) (Default=1)
% ModRef (scalar)  (Default=1)
%   MSC/ISC/EMSC/EISC:ModRef=1. 
%   SIS: MscOrIsc=1,ModRef=0
% ModOffset(scalar): offset in the model(Default=1)
%    0=  no offset modelling, 
%    1=  modell,  and subtract the estimated effect,
%    -1= model, but do not subtract the estimated effect, 
% ModChannel(scalar), channel vector (-1:1) in the model(Default=1)
%    0=  no channel vector modelling 
%    1=  model and subtract the estimated effect
%    -1= model, but do not subtract the estimated effect 
% ModSqChannel(scalar),squared channel vector (-1:1)^2 in the model(Default=1)
%    0=  no squared channel vector modelling 
%    1=  model and subtract the estimated effect
%    -1= model, but do not subtract the estimated effect 
% ModSqSpectrum(scalar)  a squared spectrum in the model (Default=0)
%   MSC/EMSC: squared reference, ISC/EISC: squared individual spectrum
%    0=  no squared spectrum  modelling 
%    1=  model and subtract the estimated effect
%    -1= model, but do not subtract the estimated effect
%
% OptPar=(scalar) defines optimization  /Default: 0, i.e. no optimzation)
%       OptPar=0 for no optimization, 
%       OptPar=1 for Ref,   
%       OptPar=2 for BadC, 
%       OptPar=3 for GoodC
%       
% nWeightIter (scalar) # of reweighted estimates of the parameters, 
%   using updated ChannelWeigths (default=0)
%
% Parameters not yet tested enough: 
% ASearchDim % number of svd dimensions in the raw data to be combined in SIMPLEX optimization (OptPar>0)
% CondNumber (scalar) condition number, e.g. 10^10 (default CondNumber=10^12)
% FactorNeeded(scalar) conservatism factor for finding optimal model rank,
% PunishLongC, PunishHighA, SamplingPrec, ToleranceRMSEP, 
% MaxIter maximum SIMPLEX iterations
% PlotIt (scalar) 1= plot all, 0=reduced plot
% AMax (max # of PCs in regression)
%..........................................................
% Comment:
% Status: 020203 HM: Works
%         100603 HM: Turned off example with non-standard input file names, to avoid dimensioning conflicts when the user changes the default files
%
%   Remaining issues: Documentation not yet finished


if DataCase==1 
    DataCaseName=' EMSC, opt. the Ref.spectrum, starting from the mean spectrum';
    OptPar=1 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
    
elseif DataCase==2
    DataCaseName=' EMSC, opt. a Bad comp.';
    OptPar=2 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
    
elseif DataCase==3
    DataCaseName=' EMSC, opt. a Good component';
    OptPar=3   ;   %OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
    
    
    % Turning off the examples that use non-default input file names, since they will conflict with the user's default file sizes. 
    % So the following is just for illustration of how things can be set up:
    %............................................................................
% elseif DataCase==4
    % DataCaseName=' EMSC, opt.the Ref.spectrum, starting from the file Ref.mat';
    % RefFileName='EMSC_Ref.MAT';
    % OptPar=1 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC

% elseif DataCase==5
    % DataCaseName=' EMSC, opt.an extra Bad spectrum, in addition to input BadSpectra';
    % FileNameBad='WaterSpectrum.MAT';   
    % OptPar=2 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC

% elseif DataCase==6
    % DataCaseName=' EMSC, opt. one good spectrum, in addition to input GoodSpectra';
    % FileNameGood='EMSC_GoodSpectra.MAT';
    % OptPar=3 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
% elseif DataCase==7
    % DataCaseName=' EMSC, opt. one bad spectrum, in addition to input GoodSpectra';
    % FileNameGood='EMSC_GoodSpectra.MAT';
    % OptPar=2 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
% elseif DataCase==8
    % DataCaseName=' EMSC, opt. one good spectrum, in addition to input BadSpectra';
    % FileNameBad='WaterSpectrum.MAT';   
    % OptPar=3 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC

% Reweighted fit:
% elseif DataCase==9
    % DataCaseName=' 3 x Reweighted MSC, ';
    % ModChannel=0;
    % ModSqChannel=0;
    % nWeightIter=3;

 % elseif DataCase==10
    % DataCaseName='5 x ReWeighted EMSC ';
    % nWeightIter=5;
    
 % elseif DataCase==11
    % DataCaseName='5 x ReWeighted EMSC with GoodSpectra and BadSpectra';
    % nWeightIter=5;
       
    %............................................................................

% Automatically estimated constituent difference spectra:
elseif DataCase==12
     DataCaseName='EMSC,Automatically estimated 1 GoodSpectra and 1 BadSpectra';
     OptPar=-1 ;   % One good and one bad spectum estimated by DoDo
elseif DataCase==13
    DataCaseName='EMSC,Automatically estimated 1 GoodSpectra and 2 BadSpectra';
     OptPar=-2 ;   % One good and one bad spectum estimated by DoDo

    
    
else
    DataCaseName=[];

end % if

