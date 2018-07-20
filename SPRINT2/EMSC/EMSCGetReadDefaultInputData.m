function [ZInputFile, Z,ZChannelLabels,ZObjLabels, ...
        ChannelWeights,WgtName, ...
        RefInputFile, RefSpectrum, RefName, ...
        BadCFileName,BadC,BadCName,GoodCFileName,GoodC,GoodCName, ...
        YInputFile,Y, YName]= EMSCGetReadDefaultInputData( ...
    DirectoryName,ZFileName,WgtFile,RefFileName,FileNameBad, FileNameGood,YFileName,jY, OptPar)
 
% File: EMSCReadTheDefaultInputData(DirectoryName,ZFileName,WgtFile,RefFileName,FileNameBad, FileNameGood,YFileName, OptPar, .m
% Purpose: Script to read data for EMSCEISC
% Made by: H.Martens January 2003
% Related files:
%   Called from EMSCGetDefaultInputData.m


%disp(' EMSCReadTheDefaultInputData start')



% Get the input data:

% Read the input spectra Z:

ZInputFile=strcat(DirectoryName,ZFileName);
load (ZInputFile); Z=Matrix;ZChannelLabels=VarLabels; ZObjLabels=ObjLabels;
[nObj,nZVar]=size(Z);       
    
% If unweighted EMSC/EISC regression:
if isempty(WgtFile)==1
    ChannelWeights=ones(1,nZVar); WgtName=WgtFile;
else
    WgtInputFile=strcat(DirectoryName,WgtFile);, load (WgtFile); ChannelWeights=Matrix; WgtName=ObjLabels;
end % if  % Fix weights

% Reference spectrum:
if isempty(RefFileName)
     RefInputFile=[];RefName='Mean';
     RefSpectrum=mean(Z);% Use the mean of the input spectra as reference
else
     RefInputFile=strcat(DirectoryName,RefFileName);, load (RefFileName); RefSpectrum=Matrix; RefName=ObjLabels;
end % ifisempty(RefFileName)

 
 
% Bad constituents' spectra, to be subtracted:
if isempty(FileNameBad)
     BadCFileName=[]; BadC=[];  BadCName=[]; 
else
     BadCFileName=strcat(DirectoryName,FileNameBad); load (FileNameBad); BadC=Matrix;BadCName=ObjLabels;
end % ifisempty(RefFileName)

    % Good constituents' spectra, to be retained:
if isempty(FileNameGood)
        GoodCFileName=[]; GoodC=[]; GoodCName=[]; 
else
        GoodCFileName=strcat(DirectoryName,FileNameGood); load (FileNameGood); GoodC=Matrix;GoodCName=ObjLabels;
end % if isempty(RefFileName)
 

% Analyte concentration file:
if isempty(YFileName)
    if OptPar>0
        error('Optimised pre-processing requires YFileName defined')
    else % if PreprocMethod)
        Y=[]; YName=[]; YInputFile=[];
    end % if OptPar>0
else % A file name for Y has been specified explicitly
    YInputFile=YFileName; %strcat(DirectoryName,YFileName);
    load (YInputFile); 
    [nYObj,nYVar]=size(Matrix);
    if nYObj~=nObj,        error('Z and Y not the same number of rows!'),end
    if nYVar>1
        if ~exist('jY')==1
            NumberOfYVariables=nYVar
            VarLabels
            jY=input('Which of these do you want to use? ')
            if jY>nYVar              
                NumberOfYVariables=nYVar
                error('Too high number !')
            end % jY>nYVar
        end % if isempty
        Y=Matrix(:,jY);YName=VarLabels(jY,:); 
        
    else % nYVar=1
        Y=Matrix; YName=VarLabels;
    end % if nYVar
end % if isempty(YFileName)
 
 

% disp(' EMSCReadTheDefaultInputData end'),keyboard
