function [OptionsEMSC,OptionsSearch,OptionPlot,EMSCDataCases,DataCaseName]= EMSCGetParametersAndData(DataCase, EMSCDataCases,GraphicsResolutions);
% File: EMSCGetParametersAndData.m
% Purpose: Read parameters and data for EMSC/EISC
% Made by: H.Martens, (c) Consensus Analysis AS Februar 2003
% Purpose: Set parameters and get input data for EMSC/EISC
% Input:
% DataCase (Scalar) this data case
% EMSCDataCases=previous DataCases [EMSCDataCases;ThisDataCase];
% GraphicsResolutions(1 X 3)=[DFigH,DFigV,dFig]
%
% Output:
%   OptionsEMSC  
%    = [ {Z}    {ChannelWeights}     {CondNumber}     {MscOrIsc}  ...
%                {ModRef} {ModOffset}    {ModSqSpectrum}          {ModChannel}    {ModSqChannel} ...
%                {RefSpectrum} {BadC}     {GoodC}  {BadCName}     {GoodCName} {RefName}  ...
%                {DirectoryName} {ZFileName} {c} {FileNameBad} {FileNameGood} {WgtFile} {YFileName} {Y} {YName} {nWeightIter}];
%   
%   OptionsSearch 
%     = [{Y} {YName} {SamplingPrec} {ToleranceRMSEP} {MaxIter} {ASearchDim} {AMax}...
%            {mdummy} {mdummy} {P} {PlotItDummy} {SaveToFile} {FilenameOut} {ZObjLabels} {ZChannelLabels} ...
%            {OptMethod} {FactorNeeded} {PunishLongC} {PunishHighA} {OptimizedPar} {OptStartVector} ]; 
%    
%   OptionPlot  
%         = [{PlotIt} {DFigH} {DFigV} {dFig} {RegrMethod} {PCName}];
%
%   EMSCDataCases=[EMSCDataCases;ThisDataCase];
%   DataCaseName (characters) name of the present data case, empty if DataCase is a number that has no method defined
%
% where
% OptionsEMSC{1}= Z (nObj x nZVar) spectra to be transformed
% OptionsEMSC{2}= ChannelWeights(1x nZVar) statistical weights of spectral channels
% OptionsEMSC{3}= CondNumber (nObj x nZVar) spectra to be transformed
% OptionsEMSC{4}= MscOrIsc (nObj x nZVar) spectra to be transformed
% OptionsEMSC{5}= ModRef (nObj x nZVar) spectra to be transformed
% OptionsEMSC{6}= ModOffset (nObj x nZVar) spectra to be transformed
% OptionsEMSC{7}= ModSqSpectrum (nObj x nZVar) spectra to be transformed
% OptionsEMSC{8}= ModChannel (nObj x nZVar) spectra to be transformed
% OptionsEMSC{9}= ModSqChannel (nObj x nZVar) spectra to be transformed
% OptionsEMSC{10}= RefSpectrum (nObj x nZVar) spectra to be transformed
% OptionsEMSC{11}= BadC (nObj x nZVar) spectra to be transformed
% OptionsEMSC{12}= GoodC (nObj x nZVar) spectra to be transformed
% OptionsEMSC{13}= BadCName (nObj x nZVar) spectra to be transformed
% OptionsEMSC{14}= GoodCName (nObj x nZVar) spectra to be transformed
% OptionsEMSC{15}= RefName (nObj x nZVar) spectra to be transformed
% OptionsEMSC{16}= DirectoryName (nObj x nZVar) spectra to be transformed
% OptionsEMSC{17}= ZFileName (nObj x nZVar) spectra to be transformed
% OptionsEMSC{18}= ZFileName (nObj x nZVar) spectra to be transformed
% OptionsEMSC{19}= FileNameGood (nObj x nZVar) spectra to be transformed
% OptionsEMSC{20}= WgtFile (nObj x nZVar) spectra to be transformed
% OptionsEMSC{21}= YFileName (nObj x nZVar) spectra to be transformed
% OptionsEMSC{22}= Y (nObj x nZVar) spectra to be transformed
% OptionsEMSC{23}= YName (nObj x nZVar) spectra to be transformed
% OptionsEMSC{24}= nWeightIter (nObj x nZVar) spectra to be transformed
%
        
        
     
    
% Called from: EMSC_Main.m
% Related files:
%       Calls   EMSCGetOptimizationDefaults.m and
%               EMSCGetInputData.m or 
%               EMSCGetDefaultInputData.m or 
%               EMSCGetInputDataForPrediction.m or 
%               EMSCGetDefaultInputDataForPred.m
% Status: 020203 HM: Works
%   
% Remaining issues:  
%....................................................

% Default case names:    
DataCaseName=[];PredCaseName=[];ASearchDimInput=[];
 
% Dummy optimization parameters:
[CondNumber, RegrMethod,PCName,OptMethod, ...
                FactorNeeded, PunishLongC, PunishHighA, SamplingPrec, ToleranceRMSEP, MaxIter, ...
                ASearchDim,AMax, P, SaveToFile, FilenameOut,PlotIt]= EMSCGetOptimizationDefaults;
    % Note: EMSCGetOptimizationDefaults is also called in EMSCGetDefaultInputData

        if DataCase==0 % Calibration, manual input
    
            [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights,nWeightIter,   ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
            DataCaseName,OptimizedPar,OptStartVector, PlotIt]=EMSCGetInputData;

        elseif DataCase>0  % Calibration, defining a new set of EMSC/EISC parameters
 
            [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights, nWeightIter,  ...
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
                MscOrIsc,WgtFile,ChannelWeights,   ...
                ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
                RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
                DataCaseName,PredCaseName,PlotIt]=EMSCGetInputDataForPrediction(DataCase,OptPar);

            elseif DataCase<(-2) % Prediction, based on an old set of EMSC/EISC parameters
                [DirectoryName, ...
                ZFileName,Z,ZChannelLabels, ZObjLabels, ...
                YFileName, Y,YName ,...
                MscOrIsc,WgtFile,ChannelWeights,   ...
                ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
                RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
                DataCaseName,PredCaseName,PlotIt]=EMSCGetDefaultInputDataForPred(DataCase,OptPar);
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
                {DirectoryName} {ZFileName} {RefFileName} {FileNameBad} {FileNameGood} {WgtFile} {YFileName} {Y} {YName} {nWeightIter}];
        
        DFigH=GraphicsResolutions(1);DFigV=GraphicsResolutions(2);dFig=GraphicsResolutions(3);
        OptionPlot= [{PlotIt} {DFigH} {DFigV} {dFig} {RegrMethod} {PCName}];
        
        PlotItDummy=[]; % Leftover, not removed yet
        mdummy=0;
        OptionsSearch = [{Y} {YName} {SamplingPrec} {ToleranceRMSEP} {MaxIter} {ASearchDim} {AMax}...
            {mdummy} {mdummy} {P} {PlotItDummy} {SaveToFile} {FilenameOut} {ZObjLabels} {ZChannelLabels} ...
            {OptMethod} {FactorNeeded} {PunishLongC} {PunishHighA} {OptimizedPar} {OptStartVector} ]; 
    
    
        % End of Set up control parameter vectors: ................................................................................................
     

