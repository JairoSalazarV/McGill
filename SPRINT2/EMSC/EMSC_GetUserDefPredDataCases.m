% file: EMSC_GetUserDefPredDataCases.m
% Purpose: User-defined default methods for EMSC/EISC prediction
% Made by. H.Martens, 2003, (c) Consensus Analysis AS
% Suitable for defining DataCases from -6 to -98

% Output:
% PredCaseName (text, char) Name of this prediction method. MUST be given
% ModelFile (char)(Optional), name of old EMSC calibration file
%             if not given: default= ModelFile='EMSCModel_EMSC_Z.mat';
% ZFileName (char) (Optional) Name of input spectra to be transformed
%             if not given: default= ZFileName='EMSC_Z.MAT';  
% YFileName (char) (Optional) Name of input Y-data 
% jY (Scalar) column # in Matrix in YFileName to be used as Y
%             if not given: default= YFileName='EMSC_Y';jY=1;
% Example:
% if DataCase==(-6) % defaults:
%        PredCaseName='Pred. Default EMSC_Z.mat, EMSC_Y.mat, use old EMSC_ZModel' ;
%        ModelFile='EMSCModel_EMSC_Z.mat';
%        ZFileName='EMSC_Z.MAT';  
%        YFileName='EMSC_Y';,j=1; % use constituent # 1 from matrix  named Matrix on file Y.mat
% elseif DataCase==(-10)
%        PredCaseName='My Pred. Default: ' ;
%        ZFileName='MyNewSpectra_Z.MAT'; A new file with the same number of columns as in My_Z.mat
%           This file must contains the three elements, as exported e.g. from The Unscrambler: 
%               Matrix(nObjPred x nZVar), 
%               ObjLabels(nObjPred,:) and VarLabels(nZVar,:) char. arrays with object and variable names
%
%        ModelFile='EMSCModel_My_Z.mat'; An EMSC/EISC model saved after using cal. data My_Z.mat
%  
%        YFileName='MyNewYData_Y'; 
%           This file must contains the three elements, as exported e.g. from The Unscrambler: 
%               Matrix(nObjPred x nYVar), 
%               ObjLabels(nObjPred,:) and VarLabels(nYVar,:) char. arrays with object and variable names
%        jY=1; Use constituent # 1: Y=Matrix(1:nObjPred,jY)
%   elseif ...
%       Other methods....
%       ...
% end % if

% Related files: Called from GetDefaultInputDataForPred.m

if DataCase==(-6) % the default example
        PredCaseName='Pred. Default EMSC_Z.mat, EMSC_Y.mat, use old EMSC_ZModel' ;
        ModelFile='EMSCModel_Z.mat';
        ZFileName='EMSC_Z.MAT';  
        YFileName='EMSC_Y';,j=1; % use constituent # 1 from matrix  named Matrix on file Y.mat
    
% elseif DataCase== ....
        %....
end %if DataCase
       
% End of EMSC_GetUserDefPredDataCases.m
