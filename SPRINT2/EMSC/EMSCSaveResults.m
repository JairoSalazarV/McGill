function [OK]=EMSCSaveResults(DataCase,DataCaseCal,DataCaseName,ZCorrected, ...
    ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,OptionsEMSC,OptionsSearch,LocalEMSCResults,CorrectedChemModelParam,PlotIt);

% File: EMSCSaveResults.m
% Purpose: Save results from EMSC/EISC preprocessing of spectra
% Made by: H.Martens (c) Consensus Analysis AS 020203 
% Input: ...
% Output: ...
%
% Related files:
%   Called from RunEMSCOpt.m
%   Calls EMSCSaveModel.m
%
% Status: HM 020203: Works

                %               but OptionsEMSC{2}=the re-estimated ChannelWeights;, to be saved to file EMSC_ReEstWgts_<InputFileName>(num2str(DataCase) if nWeightIter=OptionsEMSC{25}>0

%
Z=OptionsEMSC{1}; 
ChannelWeights=OptionsEMSC{2};
CondNumber=OptionsEMSC{3};    MscOrIsc= OptionsEMSC{4};   
ModRef=OptionsEMSC{5};        ModOffset=OptionsEMSC{6};     ModSqSpectrum=OptionsEMSC{7};
ModChannel=OptionsEMSC{8};    ModSqChannel=OptionsEMSC{9};  RefSpectrum=OptionsEMSC{10};
BadC=OptionsEMSC{11};         GoodC=OptionsEMSC{12};       
BadCName=OptionsEMSC{13};     GoodCName=OptionsEMSC{14};
RefName=OptionsEMSC{15};      DirectoryName=OptionsEMSC{16};
ZFileName=OptionsEMSC{17};    RefFileName=OptionsEMSC{18};    
FileNameBad=OptionsEMSC{19};  FileNameGood=OptionsEMSC{20};        
WgtFile=OptionsEMSC{21};      YFileName=OptionsEMSC{22};    
Y=OptionsEMSC{23};            YName=OptionsEMSC{24}; 
nWeightIter=OptionsEMSC{25};

ZObjLabels=OptionsSearch{14};
ZChannelLabels=OptionsSearch{15}; 

ZDataCaseName=DataCaseName;                
ZDataCaseCal=DataCaseCal;

[nObj,nXVar]=size(Z);


OptimizedPar=OptionsSearch{20};
EHat=LocalEMSCResults{3};  % (nObj x nZVar) EMSC- or EISC-fitted residual spectra (NOT transformed)!
          
ClockSaved=clock;
ModPName=[];for j=1:size(ModelParam,2),m=ModelParamNames(j,:);ModPName=[ModPName;cellstr(m)];end
for j=1:size(ModelParam,2),m=['s',ModelParamNames(j,:)];ModPName=[ModPName;cellstr(m)];end,ModPName=char(ModPName);
                
ZFileNameIn=ZFileName;ZDataCase=DataCase;

% Remove characters "EMSC_" from input file name:
n=length(ZFileName);
n2=5;
if n>n2
    FirstName=ZFileName(1:n2);
    if sum(FirstName=='EMSC_')==n2|sum(FirstName=='emsc_')==n2
        ZFileName=ZFileName(n2+1:n);
    end % if sum
end % if n>n2


% 1a) Save the  matrix of corrected data:
ZFileName1=['EMSCTreated_',ZFileName];  OutputFile1=strcat(DirectoryName,ZFileName1);
Matrix=ZCorrected; ObjLabels=ZObjLabels; VarLabels=ZChannelLabels; 
txt=['save ',OutputFile1,' Matrix  ObjLabels VarLabels ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];,eval(txt)
                
% 1b) Save the  matrix of weighted corrected data:
% Weighting the X-variables:
ZCorrWgtd=ZCorrected.*(ones(nObj,1)*ChannelWeights);
ZFileName1=['EMSCTreatedWgtd_',ZFileName];  OutputFile1=strcat(DirectoryName,ZFileName1);
Matrix=ZCorrWgtd; ObjLabels=ZObjLabels; VarLabels=ZChannelLabels; 
txt=['save ',OutputFile1,' Matrix  ObjLabels VarLabels ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];,eval(txt)

% 2) Save the  matrix of spectral residuals of the input data after EMSC/EISC  modelling:
ZFileName2=['EMSCRes_',ZFileName];  OutputFile2=strcat(DirectoryName,ZFileName2);
txt=['save ',OutputFile2,' EHat  ZObjLabels ZChannelLabels ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];,eval(txt)
                
                
% 3) Save the matrix of estimated EMSC/EISC model parameters for the samples :
ZFileName4=['EMSCModParam_',ZFileName];  OutputFile4=strcat(DirectoryName,ZFileName4);
ModParamAndTheirStd=[ModelParam, SModelParam]; 
txt=['save ',OutputFile4,'  ModParamAndTheirStd ZObjLabels ModPName ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];,eval(txt)

% 3b) Save multiplicatively corrected component parameter estimates
[nObjC,nComp]=size(CorrectedChemModelParam);
if nComp>0
    ZFileName4b=['EMSCEstCompConc_',ZFileName];  OutputFile4b=strcat(DirectoryName,ZFileName4b);
    nCompBad=size(BadC,1); nCompGood=size(GoodC,1);
    CompLabels=[];
    if nCompBad>0
        for j=1:nCompBad
            CompLabels=[CompLabels;cellstr(['C',BadCName(j,:)])];
        end % for j
    end %if nCompBad
    if nCompGood>0
        for j=1:nCompGood
            CompLabels=[CompLabels;cellstr(['C',GoodCName(j,:)])];
        end %if nCompGood
    end %if nCompGood
    CompLabels=char(CompLabels);
    txt=['save ',OutputFile4b,'  CorrectedChemModelParam ZObjLabels CompLabels ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];
    eval(txt)
end % if

            
% 4) Save calibration modelling results:
if DataCase>=0
   % 4a) Save the matrix of EMSC/EISC model spectra :
   ZFileName3=['EMSCModSpectra_',ZFileName];  OutputFile3=strcat(DirectoryName,ZFileName3);
   txt=['save ',OutputFile3,' ZMod  ModelParamNames ZChannelLabels ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];,eval(txt)
                
   % 4b) Save the control parameters required for predictive EMSC/EISC of future data sets
   ZFileName5=['EMSCModel_',ZFileName];  ModelFileName=strcat(DirectoryName,ZFileName5);
                [OK]=EMSCSaveModel(ModelFileName,ZChannelLabels,MscOrIsc,WgtFile,ChannelWeights,nWeightIter, ...
                    CondNumber,ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel,RefFileName, ...
                    RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
                    DataCaseName,OptimizedPar,DataCase,PlotIt);
                
                
        
   % 5) Save optimized results
   
   % 5a) Re-estimated weights:
   if nWeightIter>0  % Save the new channel weights
       ZFileName6=['EMSC_EstWgt_',ZFileName];  OutputFile6=strcat(DirectoryName,ZFileName6);
       ObjLabels=['WgtReest.',num2str(nWeightIter)];Matrix=ChannelWeights;VarLabels=ZChannelLabels;
       txt=['save ',OutputFile6,' Matrix ObjLabels  VarLabels ZDataCase ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];
       eval(txt)
   end % if nWeightIter

   % 5b) Estimated bad spectra:
   if OptimizedPar(2)<0 % BadC has been estimated by direct orthogonalization
        % OptionsEMSC{11}=BadC;
        % OptionsEMSC{13}=BadCName;
       Matrix= BadC;  ObjLabels=BadCName;VarLabels=ZChannelLabels;
       ZFileName7=['EMSC_EstBadSpectra_',ZFileName];  OutputFile=strcat(DirectoryName,ZFileName7);
       txt=['save ',OutputFile,' Matrix ObjLabels  VarLabels ZDataCase ZDataCase ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];
       eval(txt)
    
                              

   end % if OptimizedPar(2)==1 % BadC has been estimated by direct orthogonalization
      
   % 5c) Estimated good spectra:
   if OptimizedPar(3)<0 % BadC has been estimated by direct orthogonalization
        %OptionsEMSC{14}=GoodCName;
       %OptionsEMSC{12}=GoodC;
       Matrix= GoodC;  ObjLabels=GoodCName;VarLabels=ZChannelLabels;
       ZFileName7=['EMSC_EstGoodSpectra_',ZFileName];  OutputFile=strcat(DirectoryName,ZFileName7);
       txt=['save ',OutputFile,' Matrix ObjLabels  VarLabels ZDataCase ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];
       eval(txt)
           
   end % if OptimizedPar(2)==1 % BadC has been estimated by direct orthogonalization
  
      
   % 5c) Optimized reference spectrum:
   if OptimizedPar(1)==1 % Ref has been optimized by simplex opt.
       ObjLabels=['OptimizedRef'];VarLabels=ZChannelLabels;
       Matrix=RefSpectrum; % OptionsEMSC{10};;
       ZFileName9=['EMSC_OptRef_',ZFileName];  OutputFile=strcat(DirectoryName,ZFileName9);
       txt=['save ',OutputFile,' Matrix ObjLabels  VarLabels ZDataCase ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];
       eval(txt)
   end % if OptimizedPar(1)==1 % Ref has been optimized

   % 5d) Optimized bad spectrum:
    if OptimizedPar(2)==1 % BadC has been optimized by simplex opt.
       Matrix= BadC; %=OptionsEMSC{11};
       ObjLabels=BadCName;VarLabels=ZChannelLabels;

       ZFileName10=['EMSC_OptBadSpectra_',ZFileName];  OutputFile=strcat(DirectoryName,ZFileName10);
       txt=['save ',OutputFile,' Matrix ObjLabels  VarLabels ZDataCase ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];
       eval(txt)
   end % if OptimizedPar(2)==1 % BadC has been optimized
      
   % 5d) Optimized good spectrum:
   if OptimizedPar(3)==1 % GoodC has been optimized by simplex opt.
       Matrix=  GoodC;% =  OptionsEMSC{12};
       ObjLabels=GoodCName;VarLabels=ZChannelLabels;
       ZFileName11=['EMSC_OptGoodSpectra_',ZFileName];  OutputFile=strcat(DirectoryName,ZFileName11);
       txt=['save ',OutputFile,' Matrix ObjLabels  VarLabels ZDataCase ZFileNameIn ZDataCase ZDataCaseName ZDataCaseCal ClockSaved'];
       eval(txt)
   end % if OptimizedPar(2)==1 % GoodC has been optimized
   
  
   
 end %if DataCase>=0
 
 
 
 
 
 OK=1;
            