% File EMSCGetListAlternatives
% Purpose: Check and list input alternatives:
% Made by: H.Martens, (c) Consensus Analysis AS 2003
% Relatd files:
%   Called from  EMSC_Main.m
%   Calls EMSCGetDefaultInputData.m, EMSCGetDefaultInputDataForPred.m, 
% Version: 050203 HM: Works
%

    
    disp('__________________________________________________')
    
    DataCases =[(100:198)]; disp('Default EMSC data cases for calibration, defined in file EMSCGetDefaultInputData.m:')
    for DataCase=DataCases
     
     [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights,nWeightIter,  ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
            DataCaseName,ASearchDimInput,OptimizedPar,OptStartVector, PlotIt]=EMSCGetDefaultInputData(DataCase );
    if ~isempty(DataCaseName)
            Txt=['DataCase=',num2str(DataCase'),': ',DataCaseName];         disp(Txt)
        end % if
    end %for     
    disp('__________________________________________________')
    DataCases =[(201:298)]; disp('Default EISC data cases for calibration, defined in file EMSCGetDefaultInputData.m:')
    for DataCase=DataCases
      
     [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights,nWeightIter,  ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
            DataCaseName,ASearchDimInput,OptimizedPar,OptStartVector, PlotIt]=EMSCGetDefaultInputData(DataCase );
        if ~isempty(DataCaseName)
            Txt=['DataCase=',num2str(DataCase'),': ',DataCaseName];         disp(Txt)
        end % if
    end %for     
    disp('__________________________________________________')
    DataCases =[(301:398)]; disp('Cases published by Martens et al. 2003, defined in file EMSCGetDefaultInputData.m:')
    for DataCase=DataCases
         
     [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights,nWeightIter,  ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
            DataCaseName,ASearchDimInput,OptimizedPar,OptStartVector, PlotIt]=EMSCGetDefaultInputData(DataCase );
        if ~isempty(DataCaseName)
            Txt=['DataCase=',num2str(DataCase'),': ',DataCaseName];         disp(Txt)
        end % if
    end %for     
    
    disp('__________________________________________________')
    DataCases =[(401:500)]; disp('Illustration of some other control opportunities, defined in file EMSCGetDefaultInputData.m:')
    for DataCase=DataCases
         
     [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights,nWeightIter,  ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
            DataCaseName,ASearchDimInput,OptimizedPar,OptStartVector, PlotIt]=EMSCGetDefaultInputData(DataCase );
        if ~isempty(DataCaseName)
            Txt=['DataCase=',num2str(DataCase'),': ',DataCaseName];         disp(Txt)
        end % if
    end %for 
    
    disp('__________________________________________________')
    DataCases =[((-3):(-1):(-5))]; disp('Default data cases for prediction, defined in file EMSCGetDefaultInputDataForPred.m:')
    for DataCase=DataCases
        OptPar=0;
        [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights,  ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
            DataCaseName,PredCaseName,PlotIt]=EMSCGetDefaultInputDataForPred(DataCase,OptPar);
        if ~isempty(DataCaseName)
            Txt=['DataCase=',num2str(DataCase'),': ',DataCaseName,', PredCase=',PredCaseName];         disp(Txt)
        end % if
    end %for DataCase
    
    disp('__________________________________________________')
    DataCases =[(1:98)]; disp('User-defined cases defined in file EMSC_GetUserDefinedDataCases.m:')
    for DataCase=DataCases
        [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights,nWeightIter,  ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
            DataCaseName,ASearchDimInput,OptimizedPar,OptStartVector, PlotIt]=EMSCGetDefaultInputData(DataCase );
        if ~isempty(DataCaseName)
            Txt=['DataCase=',num2str(DataCase'),': ',DataCaseName];             disp(Txt)
        end % if
    end %for

    disp('__________________________________________________')
    disp('Summary demos:')
    Txt=['DataCase= ',num2str(99) ,': All demos of calibration, from file EMSC_GetUserDefinedDataCases.m '];         disp(Txt)
    Txt=['DataCase= ',num2str(199),': All demos of EMSC calibration, from file EMSCGetInternalDataCases.m '];         disp(Txt)
    Txt=['DataCase= ',num2str(299),': All demos of EISC calibration, from file EMSCGetInternalDataCases.m '];         disp(Txt)
    Txt=['DataCase= ',num2str(399),': All MSC/EMSC/EISC calibration examples from Martens et al. 2003, from file EMSCGetInternalDataCases.m '];         disp(Txt)
    Txt=['DataCase= ',num2str(499),': Some other demos of EMSC/EISC, from file EMSCGetInternalDataCases.m  '];         disp(Txt)
    Txt=['DataCase= ',num2str(599),': All demos of EMSC/EISC calibration, from files EMSCGetUserDefinedDataCases.m  and EMSCGetInternalDataCases'];         disp(Txt)

    Txt=['DataCase= ',num2str(-99),': Some prediction cases, def. in EMSC_GetUserDefPredDataCases.m(?)'];         disp(Txt)

    disp('__________________________________________________')
    
    disp('Interactive inputs: ')
    Txt=['DataCase= ',num2str(0),':  Interactive input for calibration'];         disp(Txt)
    Txt=['DataCase=',num2str(-1),':  Interactive input of prediction data and old cal. model file '];         disp(Txt)
    Txt=['DataCase=',num2str(-2),':  Interactive input of prediction data, default cal. file  EMSC_ZModel'];         disp(Txt)
    disp('__________________________________________________')
    