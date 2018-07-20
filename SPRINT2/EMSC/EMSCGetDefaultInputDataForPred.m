function   [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights,   ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
    DataCaseName,PredCaseName,DataCase,PlotIt]=EMSCGetDefaultInputDataForPred(DataCase,OptPar);
% Purpose: Read old model file and new input data for EMSC/EISC
% Made by: H.Martens January 2003
% (c) Consensus Analysis AS 2003
% Contact: Harald.Martens@mail.tele.dk
% Input:
% DataCase (scalar)
% OptPar (scalar)
%
% Output:
% DirectoryName: name of directory where data are read  and results written
% ZFileName(char): Name of file containing spectral data
% Z(nObj x nZVar): Spectral data (1 spectrum = 1 row)
% ZChannelLabels: Char array with names of Z-variables
% ZObjLabels (nObj x ?)(char array): name of objects
% YFileName(char): Name of file containing spectral data
% Y (optional)(nObj x 1) or []:  analyte concentration data  
% YName  (optional): Char array with name of Y-variable
%
% Control parameters:
% MscOrIsc (scalar) 1=MSC (or EMSC), -1=ISC (or EISC)
% WgtFile (char) name of weight file
% ChannelWeights(1 x nZVar) weights to be used in the least squares estimation, e.g. ones(1,nZVar)
% CondNumber (scalar) condition number, e.g. 10^10
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
% PlotThis (scalar) 1=plot all results, 0= reduced plots
%
% Method: 
%   1. Reads old EMSC/EISC model file
%   2. Reads input data Z and (optional) Y
%
%
% Related files:  
%   Called from EMSCGetParametersAndData.m
%   Calls       script   EMSC_GetUserDefPredDataCases.m
%               function EMSCGetReadDefaultInputData.m

% Used for the following values of DataCase:
%' -1          Interactive                            Interactive file name of old EMSC model  (for prediction) ')];
%' -2          Interactive                            Default:  old model EMSCModel_EMSC_Z.mat      (for prediction) ')];
%' -3          Default Z.mat, no Y                    Default:  old model EMSCModel_EMSC_Z.mat      (for prediction) ')];
%' -4          Default Z.mat,  Y.mat                  Default:  old model EMSCModel_EMSC_Z.mat      (for prediction) ')];
%' -5          Default Z.mat,  Y.mat  ,Reduced plot,  Default:  old model EMSCModel_EMSC_Z.mat      (for prediction) ')];
% < -5: User specification, defined in EMSC_GetUserDefPredDataCases.m

% Version: 020203 HM: Works
% Remaining Issues:Documentation not yet ready!
%
%...................................
%disp(' GetDefaultInputDataForPred  starts')

OK=0;
%Iter=0;
%while OK==0
    % Initialization:
    DirectoryName=[] ;%[pwd,'\'];% directory control is not good enough yet!
    DirectoryY=[];  
    PredCaseName=[]; 
    
    % Set defaults:
    EMSCGetDefaults % sets various defaults
    
    %ZFileName='EMSC_Z.MAT';  
    %YFileName='EMSC_Y';jY=1; % use constituent # 1 from matrix  named Matrix on file Y.mat
    YFileName=[];,jY=1;  % Ensure this default for prediction
    
    %OptPar=0;  % dummy values for defaults

    ModelFile='EMSCModel_Z.mat'; % Default EMSC old model file

    
    if   DataCase<(-5)&DataCase>(-99)%   % manual input for prediction
        
        EMSC_GetUserDefPredDataCases   % The user's predefined default pred. methods
        
    elseif DataCase==(-3) 
        PredCaseName='Pred. Defaults' ;

    elseif DataCase==(-4) 
        PredCaseName='Pred.Defaults + Y from EMSC_Y.mat ' ;
        YFileName='EMSC_Y';jY=1; % Read Y from EMSSC_Y.mat and use column 1
        
    elseif DataCase==(-5)  
        PredCaseName='Pred. Default EMSC_Z.mat, EMSC_Y.mat, use old EMSC_ZModel' ;
        ModelFile='EMSCModel_Z.mat';
        ZFileName='EMSC_Z.MAT';  
        YFileName='EMSC_Y';jY=1; % use constituent # 1 from matrix  named Matrix on file Y.mat

    else 
        PredCaseName=[];        
    end % if 

    % Get old EMSC/EISC model
    DataCaseName=[]; % To stop carry-over and user errors
    if ~isempty(PredCaseName)
        load (ModelFile); % sets also DataCaseName
      
    else
        DataCaseName=[]; % No pred. model to be read
        OK=1;
    end % if
    
        
        [ZInputFile, Z,ZChannelLabels,ZObjLabels, ...
        ChannelWeights,WgtName, ...
        RefInputFile, RefSpectrum, RefName, ...
        BadCFileName,BadC,BadCName,GoodCFileName,GoodC,GoodCName, ...
        YInputFile,Y, YName]= EMSCGetReadDefaultInputData(DirectoryName,ZFileName,WgtFile,RefFileName,FileNameBad, FileNameGood,YFileName, jY,OptPar);
        
       
    if ~isempty(DataCaseName) % A file   has been read
        % Checking the compatability between data and model:
        [n1,nZVarMod]=size(RefSpectrum);    [nObj,nZVar]=size(Z);
        OK=1;
        if nZVarMod~=nZVar
            disp('ERROR!')
            disp(['The input model has ',num2str(nZVarMod),' variables'])
            disp(['      while the input spectra have ',num2str(nZVar),' variables'])
            OK=0,    
            %Iter=Iter+1
            if DataCase~=(-1)&DataCase~=(-2)
                OK=-1;
                error(' Incompatible model and input spectra')
            end % if DataCase
        end % if nZVarMod
          
    end % if ~isempty
    %end % while OK





 