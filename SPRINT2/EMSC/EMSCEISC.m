% function [ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,LocalEMSCResults] = EMSCEISC(OptionsEMSC,OptionPlot)
%   Purpose: Extended MSC or ISC  
%   Made by H. Martens January 2003
%       (c) Consensus Analysis AS 2002
% NB! the EMSC/EISC methodology is patented. 
%       Academic use of of this code is free, but
%       commercial use of it requires permission from the author.
%       Contact: StarkEdw@aol.com   or Harald.Martens@matforsk.no
%
% 
%   Input: ...
%       OptionsEMSC; Cell Array with parameters
%           OptionsEMSC = [ {Z}    {ChannelWeights}     {CondNumber}     {MscOrIsc}  ...
%               {ModRefSpectrum} {ModOffset}    {ModSqSpectrum}          {ModChannel}    {ModSqChannel} ...
%               {BadC}     {GoodC}];
%           OptionPlot 1= Plot (scalar); 1=plot results
%                       
%
%   Output:  ...
%       ZCorrected: corrected spectra, same size as input data Z(nObj,nZVar)
%           ModelParamNames char(M,:)name of M estimated model parameters,
%           ModelParam(nObj,M) estimated model parameters
%           SModelParam(nObj,M)) estimated standard uncertainty of model parameters
%           LocalEMSCResults[{ }{ }...]:
%               ZHat=LocalEMSCResults{1};  % (nObj x nZVar) EMSC-fitted Z spectra (NOT transformed)!
%               RHat=LocalEMSCResults{2};  % (nObj x nZVar) EISC-fitted Ref. spectra (NOT transformed)! 
%               EHat=LocalEMSCResults{3};  % (nObj x nZVar) EMSC- or EISC-fitted residual spectra (NOT transformed)!
%               LastCompBeforeChemConstit=LocalEMSCResults{4};  %(scalar) index of the last model parameter before the input model spectra
%               LastCompChemConstit=LocalEMSCResults{5};  %(scalar) index of the last input model spectrum
%               MeanTrunkatedTModelParam=LocalEMSCResults{6};  % ( 1 x nModelParam) mean trunkated t-value
%               MaxTrunkatedTModelParam=LocalEMSCResults{7};   % ( 1 x nModelParam) maximum trunkated t-value
%
%   Related files: 
%       Called from     EMSC_Main.m
%                       EMSCEISCOpt.m
%                       EMSCEISCEvalRMSEP.m

%                        

%   Status:  040103 HM:Third version, works
%               29.1.03 HM: SIS
% Remaining: Check effect of sign of parameters
%           Documentation and testing is not finished yet

%-------------------------------------------------------------------------------


function [ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,LocalEMSCResults] = EMSCEISC(OptionsEMSC,OptionPlot)

%OptionsEMSC = [ {Z}    {ChannelWeights}     {CondNumber}     {MscOrIsc}  ...
%                {ModRef} {ModOffset}    {ModSqSpectrum}          {ModChannel}    {ModSqChannel} ...
%                {RefSpectrum} {BadC}     {GoodC}  {BadCName}     {GoodCName}];

        
Z = OptionsEMSC{1};
ChannelWeights = OptionsEMSC{2}; 
CondNumber = OptionsEMSC{3};
MscOrIsc=OptionsEMSC{4}; % NB!
ModRef=OptionsEMSC{5}; 
ModOffset = OptionsEMSC{6}; % nB!
ModSqSpectrum = OptionsEMSC{7};
ModChannel = OptionsEMSC{8};
ModSqChannel = OptionsEMSC{9};
RefSpectrum=OptionsEMSC{10}; 
BadC=OptionsEMSC{11};
GoodC=OptionsEMSC{12};
BadCName=OptionsEMSC{13};
GoodCName=OptionsEMSC{14};
RefName=OptionsEMSC{15};      
PlotIt=OptionPlot{1};

% Defaults:
% Condition number:
DefaultCondNumberSqrt=10^6;
DefaultCondNumber=DefaultCondNumberSqrt^2;
if isempty(CondNumber),  CondNumber=DefaultCondNumber;end  % Default value of the condition number is used, if CondNumber=[]

ModRefFromConc=ModRef;
if ModRef==2|ModRef==3
    ModRef=0;
end % if ModRef
    
if MscOrIsc==1 % MSC/EMSC
    RHat=[];
elseif MscOrIsc==(-1) % ISC/EISC
    if ModRef~=1
            error('ModRef must be 1 for ISC/EISC (i.e. for MSCOrIsc= -1)')
    end % if ModRef
    ZHat=[];
else
    error('IllegaL MSCOrIsc')
end % if MSCOrISC
DF=sum(ChannelWeights.^2); % If weights other than 0 or 1 are given, this may not be the correct expression!


%...............................Check of input parameters
 % Not implemented yet!

[nBadC,dummy]=size(BadC);
[nGoodC,dummy]=size(GoodC);

%MSCExtraModPar=[BadC;GoodC];ModelParam=((nBadC+nGoodC)>0);[nExtraModPar,M2] = size(MSCExtraModPar);
[nObj,nZVar] = size(Z);
if (abs(ModChannel)+abs(ModSqChannel))>0 , dl=2/(nZVar-1); Channel=(-1:dl:1);end
if ModSqChannel, MeanChannel = mean(Channel'); ChannelSq = (Channel - MeanChannel).^2;end

% in case of EMSC with squared mean:
MeanRefSpectrum = mean(RefSpectrum);  DiffRefSpectrum= RefSpectrum - MeanRefSpectrum; SqRefSpectrum = DiffRefSpectrum.^2; 

ZMod = [];    ModelParamNames = [];

if MscOrIsc==1 % MSC EMSC MSC EMSC MSC EMSC  MSC EMSC MSC EMSC MSC EMSC  MSC EMSC MSC EMSC MSC EMSC 
    % MSC  or EMSC, Estimate all samples' parameters at the same time  
    
    % Define the regressors
    % Offset
    if abs(ModOffset) == 1
        ModelParamNames = [ModelParamNames;cellstr('ModOffset')];
        ZMod = [ZMod ones(1,nZVar)'];
    end
    % Channel #
    if abs(ModChannel) == 1
        ModelParamNames = [ModelParamNames;cellstr('Channel')];
        ZMod = [ZMod Channel'];
    end
    % Channel Squared
    if abs(ModSqChannel) == 1
        ModelParamNames = [ModelParamNames;cellstr('Channel^2')];
        ZMod = [ZMod ChannelSq'];
    end
    %  Reference spectrum squared
    if abs(ModSqSpectrum) == 1 % Using the mean spectrum as spectral square term
        ModelParamNames = [ModelParamNames;cellstr('RefSpectrum^2')];
        ZMod = [ZMod SqRefSpectrum'];
    end
    % Bad Model parameters
    if nBadC >0
       for j=1:nBadC, ModelParamNames = [ModelParamNames;cellstr(['-',BadCName(j,:)])];,end
        ZMod = [ZMod BadC']; 
    end 
    % Good Model parameters
    if nGoodC >0
       for j=1:nGoodC,ModelParamNames = [ModelParamNames;cellstr(['+',GoodCName(j,:)])];,end
        ZMod = [ZMod GoodC']; 
    end 
    % Slope 
    if abs(ModRef)==1
        ModelParamNames = [ModelParamNames;cellstr(RefName)];
        ZMod = [ZMod RefSpectrum'];
    end % if ModRef
 
    
    % Model: Z' = ZMod*B + E'
    [nVar,nModParam]=size(ZMod);
    if nModParam==0
        % No pretreatment!
        ZCorrected=Z;
        ModelParamNames=[];ModelParam=[];,CovModelParam=[];,SModelParam=[];ZHat=Z; EHat=Z*0;
        LastCompChemConstit=0; LastCompBeforeChemConstit=0;MaxTrunkatedTModelParam=[];
        MeanTrunkatedTModelParam=[];

        
    else
        % Perform estimation
    
        % Weighted least squares without using the huge matrix DiagW:
        %    DiagW = diag(ChannelWeights.^2);
        %     ZZ = ZMod'*DiagW*ZMod;
    
        ZModW=ZMod.*(ChannelWeights'*ones(1,nModParam));
        ZW=Z.*(ones(nObj,1)*ChannelWeights);
        ZZ=ZModW'*ZModW;
        % Ridging if CondNumber is specified. Calculation of inverse ZZ.
        if CondNumber>0
            [u,S,v]=svd(ZZ);s=diag(S)'; 
            sMinimum=s(1)/sqrt(CondNumber);
            sCorrected=max(s,sMinimum ); 
            ZZCorrected=u*(diag(sCorrected))*v';  
            InvZZ = inv(ZZCorrected);
        else
            InvZZ=inv(ZZ);
        end % CondNumber>0
    
        %   B = InvZZ*ZMod'*DiagW*Z'; % Involves the big matrix DiagW, so it is replaced by:
        B = InvZZ*ZModW'*ZW';
        ModelParam = B';
        
        % Residual statistics:
        ZHat=(ZMod*B)';
        EHat=Z-ZHat;
        EHatW= EHat.*(ones(nObj,1)*ChannelWeights);
        %   SSEW=EHat*DiagW*EHat';
        %   DF=sum(diag(DiagW))-nModParam;
    
        SSEW=EHat*EHat';
        S2Obj=diag(SSEW)/(DF-nModParam); 
        SObj =sqrt(S2Obj); 
        CovModelParam=InvZZ*mean(S2Obj);
        SModelParam=SObj*sqrt(diag(InvZZ))'; 
    
        % Correcting the spectra ........................................................
        ZCorrected = Z;  
        j = 0; % Model constituent #
        % ModOffset
        if  (ModOffset) == 1
            j = j+1; if ModOffset == 1, p = ModelParam(:,j);ZCorrected = ZCorrected-(p*ones(1,nZVar));,end
        end
        % Channel
        if  (ModChannel) == 1
            j = j+1; if ModChannel == 1, p = ModelParam(:,j);ZCorrected = ZCorrected-(p*Channel);,end
        end
        %Channel Squared
        if  (ModSqChannel) == 1
            j = j+1; if ModSqChannel == 1, p = ModelParam(:,j);ZCorrected = ZCorrected-(p*ChannelSq);,end
        end
        % Squared spectrum
        if  (ModSqSpectrum) == 1
            j = j+1; if ModSqSpectrum == 1, p = ModelParam(:,j);ZCorrected = ZCorrected-(p*SqRefSpectrum);,end
        end
    
        % Chemical constituents:
        LastCompBeforeChemConstit=j;
        % Bad model parameters
        if nBadC>0
            for iBad=1:nBadC,j=j+1; p = ModelParam(:,j);ZCorrected = ZCorrected-(p*BadC(iBad,:));
            end % for iBad     
        end % if nBadC
        % Good model parameters
        if nGoodC>0
            for iGood=1:nGoodC,j=j+1; p= ModelParam(:,j);             
            end % for iGood; not subtracted! 
        end % if nGoodC  
        LastCompChemConstit=j;

        if ModRefFromConc==2|ModRefFromConc==3 % Estimte b(i) from constituent sum
            ConstitConc=[];
            if ModRefFromConc==3 % sum up both good and bad constituents
                if nGoodC+nBadC>0
                    ConstSumName='SumBadGoodConst';
                    ConstitConc=ModelParam(:,LastCompBeforeChemConstit+1:LastCompChemConstit);
                    SConstitConc=SModelParam(:,LastCompBeforeChemConstit+1:LastCompChemConstit);
                 end % if nGoodC+nBadC
            elseif ModRefFromConc==2 % sum up  good  constituents
                if nGoodC>0
                    ConstSumName='SumGoodConst';
                    ConstitConc=ModelParam(:,LastCompBeforeChemConstit+1:LastCompBeforeChemConstit+nGoodC);
                    SConstitConc=SModelParam(:,LastCompBeforeChemConstit+1:LastCompBeforeChemConstit+nGoodC);
                end % if nGoodC+nBadC
            end % if ModRefFromConc 
            if size(ConstitConc,2)==0
                SumConstitConc=ones(nObj,1);
                SSumConstitConc=ones(nObj,1); 
                error('ModRefFromConc cannot be 2 or 3 when no constituents have been defined!')
            elseif size(ConstitConc,2)==1
                SumConstitConc=abs(ConstitConc);
                SSumConstitConc=SConstitConc;
            else
                SumConstitConc=sum(abs(ConstitConc)')';
                SSumConstitConc=sqrt(sum(SConstitConc.^2')');
            end % if size()
            nModParam=nModParam+1; % Add one column in ModelParam
            ModelParamNames=[ModelParamNames;cellstr(ConstSumName)];
            ModelParam(:,j+1)=SumConstitConc;
            SModelParam(:,j+1)=SSumConstitConc;
        end % if ModRefFromConc

        %Slope, SIS: ModRef=0 (or -1?)
        if  (ModRef)==1| ModRefFromConc==2|ModRefFromConc==3
            j=j+1; p = ModelParam(:,j);
            ZCorrected = ZCorrected./(p*ones(nZVar,1)');
        elseif ModRefFromConc
        end %if
        
        
        
    end %if nModParam

  
    
elseif MscOrIsc==(-1)% ISC EISC ISC EISC ISC EISC ISC EISC ISC EISC ISC EISC ISC EISC ISC EISC ISC EISC 
    %...........ISC or EISC, modelling each object separately ....................................
    % Define the regressors
    % Offset
    if abs(ModOffset) == 1
        ModelParamNames = [ModelParamNames;cellstr('ModOffset')];
        ZMod = [ZMod ones(1,nZVar)'];
    end
    % Channel #
    if abs(ModChannel) == 1
        ModelParamNames = [ModelParamNames;cellstr('Channel')];
        ZMod = [ZMod Channel'];
    end
    % Channel Squared
    if abs(ModSqChannel) == 1
        ModelParamNames = [ModelParamNames;cellstr('Channel^2')];
        ZMod = [ZMod ChannelSq'];
    end
    %  Reference spectrum squared
    
    if abs(ModSqSpectrum) == 1 % Using the mean spectrum as spectral square term
        ModelParamNames = [ModelParamNames;cellstr('RefSpectrum^2')];
        ZMod = [ZMod SqRefSpectrum']; % May be exchanged to using the square of the actual spectrum zi
    end
    % Bad Model parameters
    if nBadC >0
       for j=1:nBadC, ModelParamNames = [ModelParamNames;cellstr(['-',BadCName(j,:)])];,end
        ZMod = [ZMod BadC']; 
    end 
    % Good Model parameters
    if nGoodC >0
       for j=1:nGoodC,ModelParamNames = [ModelParamNames;cellstr(['+',GoodCName(j,:)])];,end
        ZMod = [ZMod GoodC']; 
    end 
    
        [nVar,nModParamM1]=size(ZMod);

    if abs(ModRef)==1    
        ModelParamNames = [ModelParamNames;cellstr('Spectum z_i')];
        nModParam=nModParamM1+1;
    else
        nModParam=nModParamM1;
    end %if abs(ModRef)
    
    
    %DiagW = diag(ChannelWeights.^2);
    %DF=sum(diag(DiagW))-nModParam;
    ZCorrected=ones(nObj,nZVar)*(-99); % set aside space
    CovModelParam=zeros(nModParam,nModParam);ZModTot=zeros(nZVar,nModParam);
    if nModParamM1>0
        ZModW=ZMod.*(ChannelWeights'*ones(1,nModParamM1)); % weighted version of the model regressors common to all samples
    else
        ZModW=[];
    end % if nModParamM1>0
        RefSpectrumW=RefSpectrum.*ChannelWeights;
    ZModi=ones(nZVar,nModParam);   ZModiW=ZModi;
                 
    jSquare=abs(ModOffset)+abs(ModChannel)+abs(ModSqChannel)+abs(ModSqSpectrum);
    %Use_zi_squared=input(' Use_zi_squared?') % 0 or 1;
    Use_zi_squared=1;
    
    for i=1:nObj % ............................................. model each spectrum .......................
        % Slope 
        zi=Z(i,:);
     
        % This spectrum
       
        if abs(ModRef)==1
            ziW=zi.*ChannelWeights;                 % Weighted version of spectrum
            ZModi = [ZMod zi'];                     %The last model spectrum is the input spectrum zi
        else
            ziW=[]; 
            ZModi = [ZMod]; %  spectrum zi not in the model
        end %if abs(ModRef)
        
        if abs(ModSqSpectrum)==1
            if Use_zi_squared==1
                MeanSpectrum = mean(zi);  DiffSpectrum= zi - MeanSpectrum; SqSpectrum = DiffSpectrum.^2; 
                SqSpectrumW=SqSpectrum.*ChannelWeights; 
                ZModi(:,jSquare)=SqSpectrum';
                ZModiW(:,jSquare)=SqSpectrumW';
            end %if
        end % if abs()

                
        ZModiW = [ZModW ziW'];                  % Weightd version of model

        % Model: RefSpectrum' = ZModi*bi + ei'
        
        % Perform estimation

        %   ZZ = ZModi'*DiagW*ZModi;
        ZZ=ZModiW'*ZModiW; % %To avoid big DiagW

        % Ridging if CondNumber is specified. Calculation of inverse ZZ.
        if CondNumber>0
            [u,S,v]=svd(ZZ);s=diag(S)'; 
            sMinimum=s(1)/sqrt(CondNumber);
            sCorrected=max(s,sMinimum ); 
            ZZCorrected=u*(diag(sCorrected))*v';  
            InvZZi = inv(ZZCorrected);
            %[u,S,v]=svd(ZZ);s=diag(S)';sCorrected=max(s, (s(1)/CondNumber)); 
            %ZZCorrected=u*(diag(sCorrected))*v'; InvZZi = inv(ZZCorrected);
        else
            InvZZi=inv(ZZ);
        end
        %B = InvZZi*ZModi'*DiagW*RefSpectrum';
        B = InvZZi*ZModiW'* RefSpectrumW';
        ModelParam(i,:) = B';
        
        % Residual statistics:
        rHati=(ZModi*B)';
        eHati =RefSpectrum-rHati;
        eHatiW=eHati.*ChannelWeights;                       % Weighted residual
        SSEWi=eHatiW* eHatiW';
        S2Obji=SSEWi/(DF-nModParam); 
        SObji =sqrt(S2Obji); 
        CovModelParami=InvZZi*S2Obji;
        SModelParam(i,:)=SObji*sqrt(diag(InvZZi))';
        CovModelParam=CovModelParam+CovModelParami;
        ZModTot=ZModTot+ZModi;

        % Correcting the spectra ........................................................
                % Physical Model: (m+cGood*KGood+cBad*KBad)=b*zi +a*1 + d*L+e*L^2+..., i.e.
                % EISC model: m= b*zi +a*1 + d*L+e*L^2+...,-cGood*KGood- cBad*KBad
                % Ideal reconstruction: (m+cGood*KGood) = b*zi +a*1 + d*L +e*L^2+..., cBad*KBad
               
        zci = zi;  % The input spectra
        
       
        if ModRef==1 %Slope  b*zi
            j=nModParam; p = ModelParam(i,j); 
            zci = p*zci;
        end %if ModRef
        
        j = 0; % Model constituent #
        % ModOffset a*1
        if (ModOffset) == 1
            j = j+1; if ModOffset == 1, p = ModelParam(i,j);zci = zci+(p*ones(1,nZVar));,end
        end
        % Channel d*L 
        if  (ModChannel) == 1
            j = j+1; if ModChannel == 1, p = ModelParam(i,j);zci = zci+(p*Channel);,end
        end
        %Channel Squared e*L^2
        if (ModSqChannel) == 1
            j = j+1; if ModSqChannel == 1, p = ModelParam(i,j);zci = zci+(p*ChannelSq);,end
        end
        % Squared spectrum
        if  (ModSqSpectrum) == 1
            j = j+1; if ModSqSpectrum == 1, p = ModelParam(i,j);zci = zci+(p*SqRefSpectrum);,end
        end
        
        % Chemical constituents
        LastCompBeforeChemConstit =j;
        % Bad model parameters
        if nBadC>0
            for iBad=1:nBadC,j=j+1; p = ModelParam(i,j);zci = zci+(p*BadC(iBad,:)); end % for iBad     
        end % if nBadC
        % Good model parameters
        if nGoodC>0
            for iGood=1:nGoodC,j=j+1; end % for iGood; not subtracted in ISC/EISC!     
        end % if nGoodC 
        LastCompChemConstit=j;
        
        RHat(i,:)=rHati;
        EHat(i,:)=eHati;
        ZCorrected(i,:)=zci;
        
        if 0 
            i
            figure
            plot(zi,'b:'), hold on, 
            plot(RefSpectrum,'b'),plot(zHati,'r'), plot(eHati,'k'), title([num2str(i)])
            Bt=B'
            keyboard
        end % if 0
        
    end % for i
    
    % Average covariance:
    CovModelParam=CovModelParam/nObj;
    ZMod=ZModTot/nObj;
    
    
else % if MscOrIsc, ........................Unknown MscOrIsc ...............................................................
    error('Unknown value of MscOrIsc')

    
end % if MscOrIsc ...........................................................................................


if nModParam>0
 
     ModelParamNames=char(ModelParamNames);
     MedianSModelParam=median(SModelParam);
     TrunkatedSModelParam=max(SModelParam, ones(nObj,1)*MedianSModelParam/2);
     TrunkatedTModelParam= ModelParam./TrunkatedSModelParam;      
     MeanTrunkatedTModelParam=mean(abs(TrunkatedTModelParam));
     MaxTrunkatedTModelParam=max(abs(TrunkatedTModelParam));
     ModelParamNames=char(ModelParamNames);
    
     MedianSModelParam=median(SModelParam);
     TrunkatedSModelParam=max(SModelParam, ones(nObj,1)*MedianSModelParam/2);
     TrunkatedTModelParam= ModelParam./TrunkatedSModelParam;      
     MeanTrunkatedTModelParam=mean(abs(TrunkatedTModelParam));
     MaxTrunkatedTModelParam=max(abs(TrunkatedTModelParam)); 
 else
 end % if
 
% Miscellaneous results:
LocalEMSCResults=[ {ZHat} {RHat} {EHat} {LastCompBeforeChemConstit} {LastCompChemConstit} {MeanTrunkatedTModelParam} {MaxTrunkatedTModelParam}  ];
 
 


       
   







