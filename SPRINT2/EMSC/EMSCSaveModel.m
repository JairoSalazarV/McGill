function [OK]=EMSCSaveModel(ModelFileName,ZChannelLabels,MscOrIsc,WgtFile,ChannelWeights,nWeightIter, ...
                    CondNumber,ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel,RefFileName, ...
                    RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
                    DataCaseName,OptimizedPar,DataCase,PlotIt)

% File: EMSCSaveModel.m
% Purpose: Save all the model parameters controlling the EMSC/EISC, e.g. for future prediction use.
% Made by: H.Martens 2003
%   (c) Consensus Analysis AS 2003
% Related files:
%   Called from RunEMSCOpt.m
%
% Input:
%
% Output:
% OK(scalar) dummy
% 
% Method:
% Saves everything in the input to file <ModelFileName>
%
% Version: HM 020203  WORKS
%
% 
OK=0;
txt=(['save ',ModelFileName]);
eval(txt);

OK=1; 
%disp(' Model control structure  saved to file :')
%disp(ModelFileName)
