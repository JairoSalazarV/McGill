% function [OptC,OptRMSEP,EXITFLAGFminsearch,OUTPUT ] = EMSCEISCMinima(c,OptionsEMSC,OptionsSearch,OptionPlot)
%   Purpose: Finding the optimum linear combination of P
%   Made By:
%       Morten Beck Rye
%       (c) Consensus Analysis AS 2002
%   Matlab Call: [OptLinComb,OptRMSEP] = EMSCMinima(c, OptionsEMSC, OptionsSearch)
% 
%   Input: ... OptionsEMSC; Cell Array, Parameters specified in RunOptEMSC
%          OptionsSearch; Cell Array, Parameters specified in RunOptEMSC
%          c; real vector, initial linear combination of P
%
%   Output: ... OptLinComb; real vector, Optimum linear combination of P
%           OptRMSEP; real, RMSEP for Optimum linear combination
%
%   Related files: 
%           Called from EMSCEISCOpt.m
%                  calls fminsearch(EMSCEISCEvalRMSEP,...)
%
%   Method: Finds the optimum linear combination using the Matlab-fminsearch
%           function on the function 'simplexFunction.m' with starting point
%           'c'. Optimization is performed with respect to the calculated
%           RMSEP value of 'EvalRMSEP.m'. Returns the optimum linear 
%           combination of P, and the corrsponding RMSEP.
%
%   Status: 30.04.02 MBR: First spec
%           4.1.03 HM Slightly modified, WORKS
%   Remaining issues: Documentation not yet finished
%
%-------------------------------------------------------------------------------

function [OptC,OptRMSEP,EXITFLAGFminsearch,OUTPUT ] = EMSCEISCMinima(c,OptionsEMSC,OptionsSearch,OptionPlot)

%? X = OptionsEMSC{1};
%? Y = OptionsSearch{1};
ToleranceRMSEP = OptionsSearch{4};
MaxItera = OptionsSearch{5};
W = OptionsSearch{10};
PlotIt=OptionPlot{1};

% Sets parameters for 'Matlab-fminsearch'
options = optimset('Display','iter','MaxIter',MaxItera,'TolX',ToleranceRMSEP,'TolFun',1.000000e-004);

OPE = OptionsEMSC;
OPS = OptionsSearch;
OPI = OptionPlot;
%OPTIONS.TolX of 1.000000e-001 
 %and F(X) satisfies the convergence criteria using OPTIONS.TolFun of 1.000000e-004 

% Performs 'Matlab-fminsearch'
[OptC,OptRMSEP,EXITFLAGFminsearch,OUTPUT] = fminsearch(@EMSCEISCEvalRMSEP,c,options,OPE,OPS,OPI);


 