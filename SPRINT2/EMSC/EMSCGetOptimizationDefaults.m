function [CondNumber,RegrMethod,PCName,OptMethod, FactorNeeded, PunishLongC, PunishHighA, SamplingPrec, ToleranceRMSEP, MaxIter, ...
   ASearchDim,AMax, P, SaveToFile, FilenameOut,PlotIt]= EMSCGetOptimizationDefaults
% File: EMSCSetOptimizationDefaults.m
% Purpose: Set default program parameters for the EMSCEISC operation
% Made by: H.Martens February 2003
%
% Input: 
%   None
%
% Output:
%   See definitions in EMSCGetParametersAndData.m
%
% Related files:
% Called from: EMSCGetParametersAndData.m and from EMSCGetDefaultInputData.m
% Status: 020203 HM: Works
%   Remaining issues: Documentation not yet finished

% Set general parameters:
CondNumber=10^12;% % Using default condition number in EMSC/EISC

% Method of checking relationship to Y, if Y has been read:
RegrMethod=1; 
PCName=' PCR';
%RegrMethod=2; PCName='PLSR';

% Set graphical controls and defaults:
PlotIt=1; % Default

% Set som control parameters for the optimization:

OptMethod=0; % 1=use 1 PC,
FactorNeeded=1.05;
PunishLongC=1; %1;
PunishHighA= 1; % 0.9;%  
SamplingPrec =  4; % 6
ToleranceRMSEP = 0.0001;
MaxIter = 50 ;% 100; % 50
ASearchDim = 3 ; %3; %2; % 3;
AMax = 10; % Max PCs to compute % 15
m = [];%10; % Dummy for now
n = []; %0; % Dummy for now
P = [];%  
SaveToFile=0; %Default
FilenameOut = 'OptEMSC';

