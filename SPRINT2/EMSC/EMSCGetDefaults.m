% File EMSCGetDefaults 280103.m
% Purpose: Set  the default inputs for EMSCISEC
% Made by: H.Martens January 2003
% (c) Consensus Analysis AS 2003
% Input: 
% .....
% Output: 
%.......
% Related files:
% Called from EMSCGetDefaultInputData.m
%
% Status: 020203 HM: Works

VersionDate='280103';
ProgName=['EMSCGetDefaults',VersionDate];

%disp([ProgName,' starts'])

    
% Define input data file:
ZFileName='EMSC_Z.MAT';

% Define model type, MSC/EMSC or ISC/EISC:
MscOrIsc=1 ;% ; Default is EMSC %% MSC/EMSC     % input('Define model type, 1=MSC/EMSC, -1=ISC/EISC ')
 

% Define model:
ModRef=1; %1=MSC/EMSC  or ISC/EISC , depending on MscOrIsc, 0=SIS( with MscOrIsc=1), 
%   2=EMSC b from sum(GoodC),3=EMSC, b from sum(GoodC)+sum(BadC)
ModOffset=1;% input('Define if offset is to be used; 0=no offset, 1=model and subtract, -1=model but not subtract ')    
ModChannel=1 ;%input('Define if the channel# is to be used; 0=no, 1=model and subtract, -1=model but not subtract '   
ModSqChannel=1; 

%1 ;% input('Define if the squared channel# is to be used; 0=no, 1=model and subtract, -1=model but not subtract ')
ModSqSpectrum=0 ;% % input('Define if a squared spectrum is to be used; 0=no, 1=model and subtract, -1=model but not subtract ')
  
% Define ModRefSpectrum
RefFileName=[];
% Alternatives:
%           RefFileName=[];RefName='Mean'; Default: mean is taken as the average over the samples available
%           RefFileName='Ref.mat'; % Reads from file Ref.mat
%           RefFileName='GlutenStarchRef.MAT' %  reads from file GlutenStarchRef.MAT

WgtFileName=[];
% Alternatives:
%       WgtFileName=[]; %Default: Set all weights to=1, do not read explicit weights in
%       WgtFileName='Wgt.mat'; Alternative
  
% Define files to read bad spectra to be modelled and subtracted
FileNameBad=[];  
% Alternatives: e.g.
%       FileNameBad=[]; % Default: no spectra to be modelled and subtracted
%       FileNameBad='BadSpectra.MAT'; 
%       FileNameBad='WaterSpectrum.MAT'; 

% Define files to read good spectra to be modelled but not  subtracted
FileNameGood=[]; 
% Alternatives:e.g.  
%       FileNameGood=[];% Default: no spectra to be modelled but not  subtracted
%       FileNameGood='GoodSpectra.MAT'; 
%       FileNameGood='GlutenStarchGood.MAT'; 


% Define Y input file
YFileName='EMSC_Y';,jY=1; % use constituent # 1 from matrix  named Matrix on file Y.mat

% Optimization strategy:
OptPar=0; % %Default: No optimzation
%       OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC


nWeightIter=0; % default: No  reweighting iterations




%.............. garbage: ................
ASearchDimInput=[]; % Dummy; Default: use the search dimension defined in file EMSCGetOptimizationDefaults.m
% Define the present working directory as default input /output directory:
DirectoryName=[]; %pwd,'\'];    

Y=[];GoodCName=[];BadCName=[];   RefName='Mean';
Z=[];
