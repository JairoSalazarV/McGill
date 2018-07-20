% function [rmsepMap,C] = EMSCEISEMapping(OptionsEMSC,OptionsSearch,OptionPlot)
%   Purpose: Mapping of RMSEP for a selection of linear combinations of P
%   Made By:
%       Morten Beck Rye and Harald Martens
%       (c) Consensus Analysis AS 2002
%   Matlab Call: [rmsepMap,C] = Mapping(OptionsEMSC, OptionsSearch)
% 
%   Input: OptionsEMSC; Cell Array, Parameters specified in RunOptEMSC
%          OptionsSearch; Cell Array, Parameters specified in RunOptEMSC
%
%   Output: rmsepMap; real vector, vector with calculated RMSEP values
%           C; real matrix(n,m), corresponding linear combinations
%
%   Related files: Called from: RunOptEMSC.m
%           Calls:
%                  EMSCDesign.m
%                  EMSCEISCEvalRMSEP.m
%
%   Method: A design or mapping of different linear combination of P is set
%           set up. For each linear combination, a corresponding RMSEP
%           is calculated using 'EvalRMSEP.m'. Returns the RMSEP values
%           and the corresponding linear combinations
%
%   Status: 020203 HM: Works
%
%-------------------------------------------------------------------------------

function [rmsepMap,C] = EMSCEISEMapping(OptionsEMSC,OptionsSearch,OptionPlot)


Precision = OptionsSearch{3};
ASearchDim = OptionsSearch{6}; 
W = OptionsSearch{10}; %11?
OptimizedPar=OptionsSearch{20};
OptStartVector=OptionsSearch{21};

% Selects a set of linear combinations of W in the loading space

C = EMSCDesign(ASearchDim,Precision); 

if sum(OptimizedPar)==1 % optimise something
    if (min(OptStartVector)~=0)|(max(OptStartVector)~=0)
        [c,d] = size(C);
        C=[zeros(1,d);C]; % Start with zero scores around the start vector
    end %if 
end % if sum(OptimizedPar)

[c,d] = size(C);
rmsepMap = zeros(1,c);

% Calculates RMSEP for Y for each linear combination

for i = 1:c
    c = C(i,:);
    RMSEPCrit = EMSCEISCEvalRMSEP(c,OptionsEMSC,OptionsSearch,OptionPlot);
    rmsepMap(i) = RMSEPCrit;
    i = i+1;
end
 



