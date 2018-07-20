function [OptionsEMSC,OptionsSearch,OptionPlot,EMSCDataCases,DataCaseCal,DataCaseName]= EMSCGetParametersAndData(DataCase, EMSCDataCases,GraphicsResolutions);
% File: EMSCGetParametersAndData.m
% Purpose: Read parameters and data for EMSC/EISC
% Made by: H.Martens, (c) Consensus Analysis AS Februar 2003
% Purpose: Set parameters and get input data for EMSC/EISC
%
% Input:
% DataCase (Scalar) this data case
% EMSCDataCases=previous DataCases [EMSCDataCases;ThisDataCase];
% GraphicsResolutions(1 X 3)=[DFigH,DFigV,dFig]
%
% Output:
%   OptionsEMSC  
%    = [ {Z}            {ChannelWeights}        {CondNumber}     {MscOrIsc}         {ModRef} ...
%        {ModOffset}    {ModSqSpectrum}         {ModChannel}     {ModSqChannel}     {RefSpectrum} 
%        {BadC}         {GoodC}                 {BadCName}       {GoodCName}        {RefName}  ...
%        {DirectoryName}{ZFileName}             {RefFileName}    {FileNameBad}      {FileNameGood} 
%       {WgtFileName}       {YFileName}             {Y}              {YName}            {nWeightIter}];
%
% where
% OptionsEMSC{1}= Z (nObj x nZVar) spectra to be transformed
% OptionsEMSC{2}= ChannelWeights(1xnZVar) statistical weights of spectral channels
% OptionsEMSC{3}= CondNumber (scalar) Max Condition number to be accepted in EMSC/EISC regressions
% OptionsEMSC{4}= MscOrIsc (scalar) 1=EMSC, -1=EISC
% OptionsEMSC{5}= ModRef (scalar) 1=Treatment of reference spectrum effect in EMSC/EISC: 1=estimate and subtract, -1= estimate,but not subtract, 0=not modelled
% OptionsEMSC{6}= ModOffset (scalar) 1=Treatment of offset: 1=estimate and subtract, -1= estimate,but not subtract, 0=not modelled
% OptionsEMSC{7}= ModSqSpectrum (scalar) 1=Treatment of squared spectrum: 1=estimate and subtract, -1= estimate,but not subtract, 0=not modelled
% OptionsEMSC{8}= ModChannel (scalar) 1=Treatment of channel #: 1=estimate and subtract, -1= estimate,but not subtract, 0=not modelled
% OptionsEMSC{9}= ModSqChannel (scalar) 1=Treatment of squared channel #: 1=estimate and subtract, -1= estimate,but not subtract, 0=not modelled
% OptionsEMSC{10}= RefSpectrum (1 x nZVar) Reference spectrum
% OptionsEMSC{11}= BadC (nBadC x nZVar) bad spectra, to be modelled and subtracted in EMSC/EISC
% OptionsEMSC{12}= GoodC (nGoodC x nZVar) good spectra, to be modelled and retained
% OptionsEMSC{13}= BadCName char (nBadC x :) name of bad spectra 
% OptionsEMSC{14}= GoodCName char (nGoodC x :) name of good spectra 
% OptionsEMSC{15}= RefName char(1 x :)  name of reference spectrum
% OptionsEMSC{16}= DirectoryName char dummy for now
% OptionsEMSC{17}= ZFileName char(1 x :) name of input file for Z, to be used in  prefix for output files
% OptionsEMSC{18}= RefFileName  char(1 x :) Name of reference file read, (optional)
% OptionsEMSC{19}= FileNameBad  char(1 x :) Name of BadC file read, (optional)
% OptionsEMSC{20}= FileNameGood char(1 x :) Name of GoodC file read, (optional)
% OptionsEMSC{21}= WgtFileName char(1 x :) Name of weight file read, (optional)
% OptionsEMSC{22}= YFileName char(1 x :) Name of Y file read, (optional)
% OptionsEMSC{23}= Y (nObj x 1) Y-data to help optimise the EMSC/EISC (optional)
% OptionsEMSC{24}= YName char(nObj x nZVar) spectra to be transformed
% OptionsEMSC{25}= nWeightIter (integer) # of extra iterations with reestimation of ChannelWeights
%   
%   OptionsSearch 
%     = [{Y}            YName}             {SamplingPrec}      {ToleranceRMSEP}        {MaxIter}  ...
%       {ASearchDim}    {AMax}              {mdummy}            {mdummy}               { P}  ...
%       {PlotItDummy}   {SaveToFile}        {FilenameOut}       {ZObjLabels}            {ZChannelLabels} ...
%       {OptMethod}     {FactorNeeded}      {PunishLongC}       {PunishHighA}           {OptimizedPar}  ...
%       {OptStartVector} ]; 
%    where
% OptionsSearch{1}= Y (nObj x 1) Y-data to help optimise the EMSC/EISC (optional)
% OptionsSearch{2}= YName char(nObj x nZVar) spectra to be transformed
% OptionsSearch{3}= SamplingPrec (scalar) density of factorial design for avoiding local minima at the start of the SIMPLEX optimisation
% OptionsSearch{4}= ToleranceRMSEP (scalar) convergence criterion for SIMPLEX optimisation
% OptionsSearch{5}= MaxIter (scalar) max iterations in the  SIMPLEX optimisation
% OptionsSearch{6}= ASearchDim (scalar) # of PCs to be combined in the  SIMPLEX optimisation
% OptionsSearch{7}= AMax (scalar) max  # of PCs to be estimated in regression modelling of Y vs ZCorrected
% OptionsSearch{8}= mdummy (scalar) dummy
% OptionsSearch{9}= mdummy (scalar) dummy
% OptionsSearch{10}= P (nZVar x ASearchDim) Loadings of PCS to be searched by SIMPLEX optimisation
% OptionsSearch{11}= PlotItDummy dummy
% OptionsSearch{12}= SaveToFile (scalar) 1=save, 0=not save (i.e. SIMPLEX not converged yet)
% OptionsSearch{13}= FilenameOut char (1 x :) name of output file (????) 
% OptionsSearch{14}= ZObjLabels char (nObj x :) name of objects with spectra 
% OptionsSearch{15}= ZChannelLabels char(nZVar x :)  name of  spectral variables
% OptionsSearch{16}= OptMethod (scalar) 1= SIMPLEX optimization of Ref, 
%                                       2= SIMPLEX optimization of vector in BadC, 
%                                       3= SIMPLEX optimization of vector in GoodC, 
%                                       -n= Direct Orthogonalisation estimation of n   vectors in GoodC and  n vectors in BadC. (nb! check code!)
% OptionsSearch{17}= FactorNeeded (scalar) Factor needed for a PC (between its previous RMSEPY and its own RMSEPY )(???)to be taken as "significant"
% OptionsSearch{18}= PunishLongC  (scalar) factor used for punishing too long vectors in the SIMPLEX opt.
% OptionsSearch{19}= PunishHighA  (scalar) factor used for punishing too high optimal rank in the SIMPLEX opt.
% OptionsSearch{20}= OptimizedPar (1 x 3) , OptimizedPar(1)=1 if OptMethod=1,SIMPLEX optimization of Ref, 
%                                           OptimizedPar(2)=1 if OptMethod=2, -n if OptMethod=-n, SIMPLEX optimization of vector in BadC, 
%                                           OptimizedPar(3)=1 if OptMethod=3, -n if OptMethod=-n,SIMPLEX optimization of vector in GoodC, 
% OptionsSearch{21}= OptStartVector (1 x nZVar) start values of search vctor (OptMethod~=0)
%
% OptionPlot   = [{PlotIt} {DFigH} {DFigV} {dFig} {RegrMethod} {PCName}];
% where
% OptionPlot{1}= PlotIt (scalar) Plot control
% OptionPlot{2}= DFigH (scalar) assumed horisontal screen resolution
% OptionPlot{3}= DFigV (scalar) assumed vertical screen resolution
% OptionPlot{4}= dFig (scalar) assumed horisontal and vertical screen offset between plots
% OptionPlot{5}= RegrMethod (scalar) 1=PCR with leverage correction, 2=PLS1 with full cross-validation
% OptionPlot{6}= PCName (char)
%
%   EMSCDataCases=[EMSCDataCases;ThisDataCase];
%   DataCaseName (characters) name of the present data case, empty if DataCase is a number that has no method defined
%
% Related files:
% Called from: EMSC_Main.m
%       Calls   EMSCGetOptimizationDefaults.m and
%               EMSCGetInputData.m or 
%               EMSCGetDefaultInputData.m or 
%               EMSCGetInputDataForPrediction.m or 
%               EMSCGetDefaultInputDataForPred.m
% Status: 070203 HM: Works
%   
% Remaining issues:  Some dummy statements should be removed. Control structure for optimizations could be improved 
%....................................................

% Default case names:    
DataCaseName=[];PredCaseName=[];ASearchDimInput=[];DataCaseCal=DataCase;
 
% Dummy optimization parameters:
[CondNumber, RegrMethod,PCName,OptMethod, ...
                FactorNeeded, PunishLongC, PunishHighA, SamplingPrec, ToleranceRMSEP, MaxIter, ...
                ASearchDim,AMax, P, SaveToFile, FilenameOut,PlotIt]= EMSCGetOptimizationDefaults;
    % Note: EMSCGetOptimizationDefaults is also called in EMSCGetDefaultInputData

        if DataCase==0 % Calibration, manual input
    
            [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFileName,ChannelWeights,nWeightIter,   ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
            DataCaseName,OptimizedPar,OptStartVector, PlotIt]=EMSCGetInputData;

        elseif DataCase>0  % Calibration, defining a new set of EMSC/EISC parameters
 
            [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFileName,ChannelWeights, nWeightIter,  ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
            DataCaseName,ASearchDimInput,OptimizedPar,OptStartVector,CondNumber, ...
            RegrMethod,PCName,OptMethod, FactorNeeded, PunishLongC, PunishHighA, SamplingPrec, ToleranceRMSEP, MaxIter, ...
            ASearchDim,AMax,  P, SaveToFile, FilenameOut,PlotIt]=EMSCGetDefaultInputData(DataCase);

        elseif DataCase<0
            nWeightIter=0; % No reweighted EMSC; use ChannelWeights from cal.model
            OptPar=0; OptimizedPar=[0 0 0]; OptStartVector=[];% no  optimization

            if DataCase==(-1)|DataCase==(-2) % Prediction, based on an old set of EMSC/EISC parameters
                [DirectoryName, ...
                ZFileName,Z,ZChannelLabels, ZObjLabels, ...
                YFileName, Y,YName ,...
                MscOrIsc,WgtFileName,ChannelWeights,   ...
                ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
                RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
                DataCaseName,PredCaseName,DataCaseCal,PlotIt]=EMSCGetInputDataForPrediction(DataCase,OptPar);

            elseif DataCase<(-2) % Prediction, based on an old set of EMSC/EISC parameters
                [DirectoryName, ...
                ZFileName,Z,ZChannelLabels, ZObjLabels, ...
                YFileName, Y,YName ,...
                MscOrIsc,WgtFileName,ChannelWeights,   ...
                ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
                RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
                DataCaseName,PredCaseName,DataCaseCal,PlotIt]=EMSCGetDefaultInputDataForPred(DataCase,OptPar);
            end % if DataCase==(-1)
    
        end % if DataCase
        
        if ~isempty(ASearchDimInput), ASearchDim=ASearchDimInput,end
        
        [nObj, nZVar]=size(Z);
        [nObjY, nYVar]=size(Y);
        % End of defined data and settings! .........................................................................
    
        
        if ~isempty(DataCaseName)
            ThisDataCase=cellstr(['DataCase= ',num2str(DataCase),'=' , DataCaseName,' ', PredCaseName]);
            EMSCDataCases=[EMSCDataCases;ThisDataCase];
            %end %if

        % Set up control parameter vectors: ................................................................................................
        nWeightIter=max(nWeightIter,0);    nWeightIter=min(nWeightIter,10);
   
        end %if~isempty(DataCaseName)
        

        OptionsEMSC = [ {Z}    {ChannelWeights}     {CondNumber}     {MscOrIsc}  ...
                {ModRef} {ModOffset}    {ModSqSpectrum}          {ModChannel}    {ModSqChannel} ...
                {RefSpectrum} {BadC}     {GoodC}  {BadCName}     {GoodCName} {RefName}  ...
                {DirectoryName} {ZFileName} {RefFileName} {FileNameBad} {FileNameGood} {WgtFileName} {YFileName} {Y} {YName} {nWeightIter}];
        
        
        % Check PlotIt and save plot information
        if PlotIt==0
        elseif  PlotIt==1
        elseif  PlotIt==2
        else
            PlotIt=1;
        end % if PlotIt

        DFigH=GraphicsResolutions(1);DFigV=GraphicsResolutions(2);dFig=GraphicsResolutions(3);
        OptionPlot= [{PlotIt} {DFigH} {DFigV} {dFig} {RegrMethod} {PCName}];
        
        PlotItDummy=[]; % Leftover, not removed yet
        mdummy=0;
        OptionsSearch = [{Y} {YName} {SamplingPrec} {ToleranceRMSEP} {MaxIter} {ASearchDim} {AMax}...
            {mdummy} {mdummy} {P} {PlotItDummy} {SaveToFile} {FilenameOut} {ZObjLabels} {ZChannelLabels} ...
            {OptMethod} {FactorNeeded} {PunishLongC} {PunishHighA} {OptimizedPar} {OptStartVector} ]; 
    
    
        % End of Set up control parameter vectors: ................................................................................................
     

