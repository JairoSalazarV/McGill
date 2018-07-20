function [FVAL]=CheckDelta(D) 
% File: CheckDelta.m
% Purpose: Minimize MSC Error
% Made by: H.Martens 0203 
% Related files:
%       Called from ChangeSpectralUnitsForEMSC.m
%       Calls MSCPlots.m
%
% input: D (scalar) and globals
% OutpuT: FVal 
global X InputType TransformedTypeD ObjLabels YClass Groups RTMin PlotIt TransformMethod

[X2]= TransformSpectra(TransformMethod,X,D,RTMin);
        
[NotR2]=MSCPlots(X2,InputType,TransformedTypeD,ObjLabels,YClass,Groups,PlotIt);

FVAL=mean(NotR2);
   
