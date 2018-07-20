function   [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights,  ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
    DataCaseName,PredCaseName,DataCase, PlotIt]=EMSCGetInputDataForPrediction(DataCase,OptPar);
% Purpose: Manual control to read old model file and new input data for EMSC/EISC
% Made by: H.Martens January 2003
% (c) Consensus Analysis AS 2003
% Contact: Harald.Martens@mail.tele.dk
% Input:
% DataCase (scalar)
% OptPar (scalar), 0=no optimization, 1=optimise ref, 2=optimise bad spectrum, 3=optimise good spectrum
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
% MscOrIsc (scalar) 1=MSC (or EMSC), 0=ISC (or EISC)
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
% DataCaseName (char) % name of old EMSC/EISC model
% PredCaseName (char) % name of the input case
% GoodCName (nGoodComp x ?) char array with names of  the good components
% PlotIt (scalar) 1=plot all results, 0= reduced plots
%
% Method: 
%   1. Reads old EMSC/EISC model file
%   2. Reads input data Z and (optional) Y
%
%
% Related files:  Called from EMSCGetParametersAndData.m
%               Calls         EMSCFileReading.m
%                             EMSCGetReadDefaultInputData.m
% Used for the following values of DataCase:
%' -1          Interactive                            Interactive file name of old EMSC model  (for prediction) ')];
%' -2          Interactive                            Default:  old model EMSC_ZModel.mat      (for prediction) ')];
% Version: 020203 HM: Works
% Documentation not yet finished!
%...................................
disp(' GetInputDataForPrediction starts')
OK=0;
Iter=0;
while OK==0
    if DataCase==(-1)%
        PredCaseName='Interactive input of data and old EMSC model' ;
    elseif DataCase==(-2)%
        PredCaseName='Interactive input of data, default EMSC_ZModel'; 
    else
        PredCaseName= [];
    end % if 
      
    % Get old EMSC/EISC model
    if DataCase==(-1)% Interactive file name of old EMSC model 
        s=['Define old Matlab data file with the EMSC or EISC MODEL '];  
        disp(s),    disp(' ')
        [n,o]=uigetfile('EMSCModel_*.mat', 'Pick a Matlab model-file');
        n=cellstr(n);    o=cellstr(o);
        DirectoryName=char(o);    FileName=char(n);
        ModelFile=strcat(DirectoryName,FileName)
        %Read the file, just to check dimensions:
        load (ModelFile);
        PlotIt=1;
    elseif DataCase==(-2)| DataCase==(-3)| DataCase==(-4)  | DataCase==(-5) %Default:  old model EMSC_ZModel.mat 
        DirectoryName=' ';
        ModelFile='EMSCModel_Z.mat'
        load (ModelFile);
        PlotIt=1;
    else
         
    end %if DataCase

    ReadDataFromDefault=1;
    
    % Get data to be read
    disp('Give file of the input spectra Z to be changed:')
        [DirectoryName,ZFileName,ZInputFile,Z,ZChannelLabels,ZObjLabels]=EMSCFileReading;
    
    disp('Define if  Y is  to be used:')
    InputY=input('1= read from file,to check model; else give 0 ')
    if InputY
            disp('read Y-file')
            [DirectoryY, FileNameY ,YFileName ,Y ,YName ,ObjYNames]=EMSCFileReading;
    else
            DirectoryY=[]; FileNameY=[]; YFileName=[]; Y =[]; YName=[]; YName=[]; 
            jY=1; % dummy
    end % InputY

    if ReadDataFromDefault==1,
        
         [ZInputFile, Z,ZChannelLabels,ZObjLabels, ...
        ChannelWeights,WgtName, ...
        RefInputFile, RefSpectrum, RefName, ...
        BadCFileName,BadC,BadCName,GoodCFileName,GoodC,GoodCName, ...
        YInputFile,Y, YName]= EMSCGetReadDefaultInputData( ...
            DirectoryName,ZFileName,WgtFile,RefFileName,FileNameBad, FileNameGood,YFileName,jY, OptPar);

        %EMSCGetReadDefaultInputData
    end %  if ReadDataFromDefault==1
    
    % Plot control:
    PlotIt= input('Plot model= 0=no plots, 1=moderate, 2=plot a lot, 3=verbose!  ');   % 0 %1; (0 or 1)
    
    % Checking the compatability between data and model:
    [n1,nZVarMod]=size(RefSpectrum);

    [nObj,nZVar]=size(Z);
    OK=1;
    if nZVarMod~=nZVar
        disp('ERROR!')
        disp(['The input model has ',num2str(nZVarMod),' variables'])
        disp(['      while the input spectra have ',num2str(nZVar),' variables'])
        OK=0,    Iter=Iter+1
        if DataCase~=(-1)&DataCase~=(-2)
            OK=-1;
            error(' Incompatible model and input spectra')
        end % if DataCase
    end % if nZVarMod
    if Iter>5
        OK=-1;
        disp('We give up this, I think!')
    end % if Iter
    
    
end % while OK


disp(' GetInputDataForPrediction ends')



 