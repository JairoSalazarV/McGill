% File  EMSCGetInternalDataCases.m
% Purpose: Pre-define DataCases  for EMSC/EISC
% Made by: H. Martens Jan 2003
% (c) Consensus Analysis AS
% Related files: 
% Called from EMSCGetDefaultInputData.m 
%
% The defaults from the following may be modified here  :
% Doc. may still be inaccurate! See definitions in EMSCGetParametersAndData.m!
%
%............................................................
%
% DirectoryName: name of directory where data are read  and results written
% ZFileName(char): Name of file containing spectral data
% Z(nObj x nZVar): Spectral data (1 spectrum = 1 row)
% ZChannelLabels: Char array with names of Z-variables
% ZObjLabels (nObj x ?)(char array): name of objects
% YFileName(char): Name of file containing spectral data
% Y (optional)(nObj x 1) or []:  analyte concentration data 
% jY (scalar) Index if there are more than one Y-variable read
% YName  (optional): Char array with name of Y-variable
%
% Control parameters:
% MscOrIsc (scalar) 1=MSC (or EMSC), 0=ISC (or EISC)
% WgtFileName (char) name of weight file
% ChannelWeights(1 x nZVar) weights to be used in the least squares estimation, e.g. ones(1,nZVar)
% CondNumber (scalar) condition number, e.g. 10^10
% ModRef (scalar) 
%   MSC/ISC/EMSC/EISC:ModRef=1. 
%   2=estimate b(i) from sum of good constituents
%   3=estimate b(i) from sum of good and bad constituents
%   SIS: MscOrIsc=1,ModRef=0
%
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
%           if
% BadCFileName(char): name of file containing spectral data of the bad components to be modelled and subtracted
% BadC(nBadComp x nZVar) spectra of bad components, 
% BadCName (nBadComp x ?) char array with names of bad components
% GoodCFileName(char): name of file containing spectral data of the good components to be modelled but not subtracted
% GoodC(nGoodComp x nZVar) spectra of good components, 
% GoodCName (nGoodComp x ?) char array with names of  the good components
% OptPar=(scalar) defines optimization  Default: 0=No optimzation
%       OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
% PlotIt (scalar) 1= plot all, 0=reduced plot
%
%
% Modifications: 
%
% Version: January 20 2003  HM: first version
%           Jan 28 2003 HM : New methods
%           Febr 2 2003 HM: New file name
%           March 6th 2003 HM: documentation
%


% Simplest methods: .................................................................
if DataCase==    (100)
        DataCaseName='No pre-treatment';
        ModOffset=0;
        ModRef=0;
        ModChannel=0;    
        ModSqChannel=0;     
        ModSqSpectrum= 0;
elseif DataCase==(101)   
        DataCaseName='Spectral Interference Subtraction (SIS)';
        FileNameGood='EMSC_GoodSpectra.MAT';  
        FileNameBad='EMSC_BadSpectra.MAT';   
        ModChannel=0;        
        ModSqChannel=0;      
        ModRef=0; 
elseif DataCase==    (102)
        DataCaseName='MSC';
        ModChannel=0  ;     % Linear "wavelength" (=channel #) effect modelled but not subtracted
        ModSqChannel=0;     % Squared "wavelength" (=channel #) effect modelled but not subtracted
        ModSqSpectrum= 0 ;
        
% EMSC of various sorts:.................................................................
elseif DataCase==(103)   
        DataCaseName='EMSC physical,default';
elseif DataCase==(106)   
        DataCaseName='EMSC, physical & input Good Spectra from file';
        FileNameGood='EMSC_GoodSpectra.MAT';  
elseif DataCase==(107)   
        DataCaseName='EMSC, physical & input Bad Spectra from file';
        FileNameBad='EMSC_BadSpectra.MAT';   
elseif DataCase==(108)   
        DataCaseName='EMSC, physical & Good & Bad Spectra from file';
        FileNameGood='EMSC_GoodSpectra.MAT';  
        FileNameBad='EMSC_BadSpectra.MAT';   
elseif DataCase==(109) 
        DataCaseName='Default EMSC with modelling of Ref^2';
        ModSqSpectrum= 1 ;  % Squared intensity effect   modelled 
elseif DataCase==(110) 
        DataCaseName='Default EMSC with modelling of Ref^2,but not subtraction';
        ModSqSpectrum= -1  ; % Squared intensity effect   modelled but not subtracted
elseif DataCase==(111) 
        DataCaseName='Default EMSC, but no subtraction of physical effects' ;     
        ModChannel=-1  ;     % Linear "wavelength" (=channel #) effect modelled but not subtracted
        ModSqChannel=-1;     % Squared "wavelength" (=channel #) effect modelled but not subtracted
        ModSqSpectrum= -1 ;  % Squared intensity effect   modelled but not subtracted

% Automatically estimated constituent difference spectra:....................................... 
elseif DataCase==121
        DataCaseName='EMSC,Automatically estimated 1 GoodSpectra and 1 BadSpectra';
        OptPar=-1 ;   % One good and one bad spectum estimated by DoDo
elseif DataCase==122
        DataCaseName='EMSC,Automatically estimated 1 GoodSpectra and 2 BadSpectra';
        OptPar=-2 ;   % One good and one bad spectum estimated by DoDo
        
% Weighted and reweighted fit:.................................................................
elseif DataCase==(131) 
        DataCaseName='MSC, Weights from file Wgt.mat';
        WgtFileName='EMSC_Wgt.mat';
        ModChannel=0    ;    % No linear "wavelength" (=channel #) effect
        ModSqChannel=0  ;    % No squared "wavelength" (=channel #) effect 
elseif DataCase==(132) 
        DataCaseName='EMSC default, Weights from file Wgt.mat';
        WgtFileName='EMSC_Wgt.mat';
elseif DataCase==133
        DataCaseName='3 x Reweighted MSC, ';
        ModChannel=0;
        ModSqChannel=0;
        nWeightIter=3;
 elseif DataCase==134
        DataCaseName='5 x ReWeighted EMSC ';
        nWeightIter=5;   
 elseif DataCase==135
        DataCaseName='5 x ReWeighted EMSC with GoodSpectra and BadSpectra';
        nWeightIter=5;
    
% Nonlinear optimization:.................................................................
elseif DataCase==151 
        DataCaseName=' EMSC, opt. the Ref.spectrum, starting from the mean spectrum';
        OptPar=1 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
        ASearchDim=3;
elseif DataCase==152
        DataCaseName=' EMSC, opt. a Bad comp.';
        OptPar=2 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
        ASearchDim=3;
elseif DataCase==153
        DataCaseName=' EMSC, opt. a Good comp.';
        OptPar=3   ;   %OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC    
elseif DataCase==154
        DataCaseName=' EMSC, opt.the Ref.spectrum, starting from the file Ref.mat';
        RefFileName='EMSC_Ref.MAT';
        OptPar=1 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
elseif DataCase==155
        DataCaseName=' EMSC, opt.an extra Bad spectrum, in addition to input BadSpectra';
        FileNameBad='EMSC_BadSpectra.MAT';     
        OptPar=2 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
elseif DataCase==156
        DataCaseName=' EMSC, opt. one good spectrum, in addition to input GoodSpectra';
        FileNameGood='EMSC_GoodSpectra.MAT';
        OptPar=3 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
elseif DataCase==157
        DataCaseName=' EMSC, opt. one bad spectrum, in addition to input GoodSpectra';
        FileNameGood='EMSC_GoodSpectra.MAT';
        OptPar=2 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
elseif DataCase==158
        DataCaseName=' EMSC, opt. one good spectrum, in addition to input BadSpectra';
        FileNameBad='EMSC_BadSpectra.MAT';     
        OptPar=3 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
        
elseif DataCase==159
        DataCaseName=' EMSC, opt. one good spectrum, in addition to input BadSpectra';
        FileNameBad='EMSC_BadSpectra.MAT';     
        OptPar=3 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
 elseif DataCase==160
        DataCaseName=' EMSC, opt. 2D one good spectrum, in addition to input GoodSpectra and BadSpectra';
        FileNameBad='EMSC_BadSpectra.MAT';          FileNameGood='EMSC_GoodSpectra.MAT';
        OptPar=3 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
        %ASearchDimInput=2; % default
   
elseif DataCase==161
        DataCaseName=' EMSC, opt. 3D one good spectrum, in addition to input GoodSpectra and BadSpectra';
        FileNameBad='EMSC_BadSpectra.MAT';          FileNameGood='EMSC_GoodSpectra.MAT';
        OptPar=3 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
        ASearchDimInput=3;

elseif DataCase==162
        DataCaseName=' EMSC, opt. 3D ref spectrum, in addition to input GoodSpectra and BadSpectra';
        FileNameBad='EMSC_BadSpectra.MAT';          FileNameGood='EMSC_GoodSpectra.MAT';  
        OptPar=1 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
        ASearchDimInput=3;
elseif DataCase==163
        DataCaseName=' EMSC, opt. 3D ref spectrum, in addition to input GoodSpectra and BadSpectra';
        FileNameBad='EMSC_BadSpectra.MAT';          FileNameGood='EMSC_GoodSpectra.MAT';  
        OptPar=1 ;     % OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
        ASearchDimInput=3;
%...................................       
        
elseif DataCase==    (201)
        DataCaseName='ISC';
        MscOrIsc=-1 ;  

elseif DataCase==(202)   
        DataCaseName='EISC physical,default';
        MscOrIsc=-1;

elseif DataCase==(203)   
        DataCaseName='EISC physical & opt. Good spectrum';
        OptPar=3  ;    %OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
        MscOrIsc=-1 ;
elseif DataCase==(204)   
        DataCaseName='EISC physical & opt. mean Ref spectrum';
        OptPar=1 ;     %OptPar=0 for no optimization, OptPar=1 for Ref,   OptPar=2 for BadC, OptPar=3 for GoodC
        MscOrIsc=-1 ;
elseif DataCase==(205)   
        DataCaseName='EISC, physical & input Good Spectra from file';
        FileNameGood='EMSC_GoodSpectra.MAT'; 
        MscOrIsc=-1 ;
elseif DataCase==(206)   
        DataCaseName='EISC, physical & input Bad Spectra from file';
        FileNameBad='EMSC_GoodSpectra.MAT'; 
        MscOrIsc=-1 ;
elseif DataCase==(207)   
        DataCaseName='EISC, physical & Good & Bad Spectra from file';
        FileNameGood='EMSC_GoodSpectra.MAT';  
        FileNameBad='EMSC_BadSpectra.MAT';
        MscOrIsc=-1 ;
elseif DataCase==(208) 
    DataCaseName='Default ESC with modelling of Ref^2';
        ModSqSpectrum= 1 ;  % Squared intensity effect   modelled 
        MscOrIsc=-1 ;
elseif DataCase==(209) 
        DataCaseName='Default EISC with modelling of Ref^2,but not subtraction';
        ModSqSpectrum= -1 ;  % Squared intensity effect   modelled but not subtracted
        MscOrIsc=-1 ;
elseif DataCase==(210) 
        DataCaseName='Default EISC, but no subtraction of physical effects'      ;
        ModChannel=-1;       % Linear "wavelength" (=channel #) effect modelled but not subtracted
        ModSqChannel=-1;     % Squared "wavelength" (=channel #) effect modelled but not subtracted
        ModSqSpectrum= -1 ;  % Squared intensity effect   modelled but not subtracted
        MscOrIsc=-1; 
elseif DataCase==(211) 
        DataCaseName='ISC, Weights from file Wgt.mat';
        WgtFileName='EMSC_Wgt.mat';
        ModChannel=0;        % No linear "wavelength" (=channel #) effect
        ModSqChannel=0;      % No squared "wavelength" (=channel #) effect 
        MscOrIsc=-1; 
elseif DataCase==(212) 
        DataCaseName='EISC default, Weights from file Wgt.mat';
        WgtFileName='EMSC_Wgt.mat';
        MscOrIsc=-1;
        

%...................................       

elseif DataCase==(301) 
    DataCaseName='MSC, as published by Martens et al. in Analytical Chemistry 2003' ;   
    ModChannel=0 ;      
    ModSqChannel=0 ;    
    ZFileName='GlutenStarchOD.MAT';   
    %RefFileName='GlutenStarchRef.MAT';  % (Z3+Z93)/2    
    FileNameGood='GlutenStarchGood.MAT';% (Z3-Z93)/2, not (Z3-Z93) as used in the original paper
    YFileName='GlutenConc.mat';
elseif DataCase==(302) 
    DataCaseName='EMSC, as published by Martens et al. in Analytical Chemistry 2003';
    ZFileName='GlutenStarchOD.MAT';   
    RefFileName='GlutenStarchRef.MAT';  % (Z3+Z93)/2    
    FileNameGood='GlutenStarchGood.MAT';% (Z3-Z93)/2, not (Z3-Z93) as used in the original paper
    YFileName='GlutenConc.mat';

elseif DataCase==(303) 
    DataCaseName='EMSC, as published by Martens et al. in Analytical Chemistry 2003';
    MscOrIsc=-1   ;
    ZFileName='GlutenStarchOD.MAT';   
    RefFileName='GlutenStarchRef.MAT';  % (Z3+Z93)/2    
    FileNameGood='GlutenStarchGood.MAT';% (Z3-Z93)/2, not (Z3-Z93) as used in the original paper
    YFileName='GlutenConc.mat';
 
elseif DataCase==(304)  
        DataCaseName='Spectral Interference Subtraction (SIS)';
        ZFileName='GlutenStarchOD.MAT';   
        FileNameGood='GlutenSpectrum.MAT';  
        FileNameBad='StarchWaterSpectra.MAT'; 
        YFileName='GlutenStarchDesign.MAT';jY=8; % reads the whole design file
        ModChannel=0;        
        ModSqChannel=0;      
        ModRef=0; 
        

%........................ files for further illustrations: ..................
 
elseif DataCase==(401) 
    DataCaseName='EMSC default, reduced plot';
    PlotIt=0; 
elseif DataCase==(402) 
    DataCaseName='EMSC default; reads no Y';
    YFileName=[]; 
elseif DataCase==(403) 
    DataCaseName='EISC; reads no Y' ;
    YFileName=[];
elseif DataCase==(404) 
    DataCaseName='EISC explicit default';
    MscOrIsc=-1  ;        
    ZFileName='EMSC_Z.MAT';   
    RefFileName='EMSC_Ref.mat';     
    FileNameBad='EMSC_BadSpectra.MAT';   
    FileNameGood='EMSC_GoodSpectra.MAT';  
    
elseif DataCase==(405) 
    DataCaseName='EMSC,  explicit default';
    ZFileName='EMSC_Z.MAT';   
    RefFileName='EMSC_Ref.mat';     
    FileNameBad='EMSC_BadSpectra.MAT';   
    FileNameGood='EMSC_GoodSpectra.MAT'; 
    WgtFileName='EMSC_Wgt.mat';
elseif DataCase==(406)  
    DataCaseName='EMSC other Good and Bad spectum files';
    ZFileName='GlutenStarchOD.MAT';   
    YFileName='GlutenStarchDesign.MAT';j=8; % reads the whole design file
    WgtFileName='GlutenStarchWgt.mat';
    FileNameGood='WaterSpectrum.MAT'; 
    FileNameBad='RandomSpectrum.MAT'; 
    
%.........................................................
    
elseif DataCase==(407)  % 
    DataCaseName='EMSC,  b(i) =sum(good constituent conc.) ';
    FileNameGood='PureGoodConstitSpectra.mat'; % 'PureGlutenAndStarchOD.MAT'; 
    ModRef=2;
    %ModOffset=0;    
    ModChannel=0 ;      
    ModSqChannel=0 ;   
elseif DataCase==(408)  % 
    DataCaseName='EMSC,  b(i) =sum(all constituent conc.) ';
    FileNameGood='PureAnalyteSpectum.mat' ; %'PureGlutenOD.MAT'; 
    FileNameBad='PureInterferantSpectrum.mat' ;% 'PureStarchOD.MAT'; 
    ModRef=3;   
    %ModOffset=0;    
    ModChannel=0 ;      
    ModSqChannel=0 ;   

elseif DataCase==(409)  % 
    DataCaseName='EMSC,   b(i) =sum(all constituent conc.),but 1 unknown interferant opt. and removed';
    FileNameGood='PureAnalyteSpectum.mat'; % 'PureGlutenOD.MAT'; 
    OptPar=2; % find the bad spectrum
    ModRef=2; % b(i)=sum good and bad spectra
    ModOffset=0;   
    ModChannel=0 ;      
    ModSqChannel=0 ;   
  
elseif DataCase==(410)  % 
    DataCaseName='EMSC,   b(i) =sum(all constituent conc.),but 1 unknown analyte opt. ';
    ZFileName='EMSC_Z.MAT';   
    FileNameGood='PureAnalyteSpectum.mat'; % 'PureGlutenOD.MAT'; 
    OptPar=3; % find an extra good spectrum 
    ModRef=3;  % b(i)=sum good  spectra
    ModOffset=0;    
    ModChannel=0 ;      
    ModSqChannel=0 ;  
elseif DataCase==(411)  % 
    DataCaseName='EMSC,   input good  spectra, no offset ';
    ZFileName='EMSC_Z.MAT';   
    FileNameGood='EMSC_GoodSpectra.MAT'; 
    %ModOffset=0;      
    ModChannel=0 ;      
    ModSqChannel=0 ; 

else
    DataCaseName=[];
    
end % if DataCase
 

