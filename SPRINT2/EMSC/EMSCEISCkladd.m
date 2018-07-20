% function [ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,EHat] = EMSCEISC(OptionsEMSC,OptionPlot)
%   Purpose: Extended MSC or ISC  
%   Made by H. Martens January 2003
%       (c) Consensus Analysis AS 2002
% NB! the EMSC/EISC methodology is patented. 
%       Academic use of of this code is free, but
%       commercial use of it requires permission from the author.
%       Contact: Harald.Martens@matforsk.no

%   Matlab Call: [Matrix, VarLabels] = EMSCEISC(Options)
% 
%   Input: OptionsEMSC; Cell Array with parameters
%           OptionsEMSC = [ {Z}    {ChannelWeights}     {CondNumber}     {MscOrIsc}  ...
%               {ModRefSpectrum} {ModOffset}    {ModSqSpectrum}          {ModChannel}    {ModSqChannel} ...
%               {BadC}     {GoodC}];
%           OptionPlot 1= Plot (scalar); 1=plot results
%                       2= 
%
%   Output: ZCorrected: corrected spectra, same size as input data Z(nObj,nZVar)
%           ModelParamNames char(M,:)name of M estimated model parameters,
%           ModelParam(nObj,M) estimated model parameters
%           SModelParam(nObj,M)) estimated standard uncertainty of model parameters
%           EHat(nObj,nZVar) spectral lack of fit in the EMSC or EISC modelling
%
%   Related files: Called from TestEMSC.m
%
%   Status:  040103 HM:Third version, works
%               29.1.03 HM: SIS

%-------------------------------------------------------------------------------


function [ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,EHat] = EMSCEISC(OptionsEMSC,OptionPlot)

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
       

% Plot information:
PlotIt=OptionPlot{1};
DFigH=OptionPlot{2};
DFigV=OptionPlot{3};
dFig=OptionPlot{4};


% Defaults:
% Condition number:
DefaultCondNumberSqrt=10^6;
DefaultCondNumber=DefaultCondNumberSqrt^2;
if isempty(CondNumber),  CondNumber=DefaultCondNumber;end  % Default value of the condition number is used, if CondNumber=[]

    
DF=sum(ChannelWeights.^2); % If weights other than 0 or 1 are given, this may not be the correct expression!


%...............................Check of input parameters
 % Not implemented yet!


 

[nBadC,dummy]=size(BadC);
[nGoodC,dummy]=size(GoodC);

%MSCExtraModPar=[BadC;GoodC];ModelParam=((nBadC+nGoodC)>0);[nExtraModPar,M2] = size(MSCExtraModPar);
[nObj,nZVar] = size(Z);
if (abs(ModChannel)+abs(ModSqChannel))>1 , dl=2/(nZVar-1); Channel=(-1:dl:1);end
if ModSqChannel, MeanChannel = mean(Channel'); ChannelSq = (Channel - MeanChannel).^2;end

% in case of EMSC with squared mean:
MeanRefSpectrum = mean(RefSpectrum);  DiffRefSpectrum= RefSpectrum - MeanRefSpectrum; SqRefSpectrum = DiffRefSpectrum.^2; 

ZMod = [];    ModelParamNames = [];

if MscOrIsc==1, % MSC  or EMSC, Estimate all samples' parameters at the same time  
    
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
    end
    
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
    if abs(ModOffset) == 1
        j = j+1; if ModOffset == 1, p = ModelParam(:,j);ZCorrected = ZCorrected-(p*ones(1,nZVar));,end
    end
    % Channel
    if abs(ModChannel) == 1
        j = j+1; if ModChannel == 1, p = ModelParam(:,j);ZCorrected = ZCorrected-(p*Channel);,end
    end
    %Channel Squared
    if abs(ModSqChannel) == 1
        j = j+1; if ModSqChannel == 1, p = ModelParam(:,j);ZCorrected = ZCorrected-(p*ChannelSq);,end
    end
    % Squared spectrum
    if abs(ModSqSpectrum) == 1
        j = j+1; if ModSqSpectrum == 1, p = ModelParam(:,j);ZCorrected = ZCorrected-(p*SqRefSpectrum);,end
    end
    
    % Chemical constituents:
    LastCompBeforeChemConstit=j;
    % Bad model parameters
    if nBadC>0
        for iBad=1:nBadC,j=j+1; p = ModelParam(:,j);ZCorrected = ZCorrected-(p*BadC(iBad,:)); end % for iBad     
    end % if nBadC
    % Good model parameters
    if nGoodC>0
        for iGood=1:nGoodC,j=j+1; end % for iGood; not subtracted!     
    end % if nGoodC    
    LastCompChemConstit=j;
    
    %Slope
    if abs(ModRef)==1
        j=j+1; p = ModelParam(:,j);
        ZCorrected = ZCorrected./(p*ones(nZVar,1)');
    end %if
    
   
  
    
elseif MscOrIsc==(-1), %...........ISC or EISC, modelling each object separately ....................................
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
        
    ModelParamNames = [ModelParamNames;cellstr('Spectum z_i')];
    [nVar,nModParamM1]=size(ZMod);nModParam=nModParamM1+1;
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
       
        ziW=zi.*ChannelWeights;                 % Weighted version of spectrum
        ZModi = [ZMod zi'];                     %The last model spectrum is the input spectrum zi
        
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
        zci = zi;  
        %Slope
        j=nModParam; p = ModelParam(i,j); zci = p*zci;
        j = 0; % Model constituent #
        % ModOffset
        if abs(ModOffset) == 1
            j = j+1; if ModOffset == 1, p = ModelParam(i,j);zci = zci+(p*ones(1,nZVar));,end
        end
        % Channel
        if abs(ModChannel) == 1
            j = j+1; if ModChannel == 1, p = ModelParam(i,j);zci = zci+(p*Channel);,end
        end
        %Channel Squared
        if abs(ModSqChannel) == 1
            j = j+1; if ModSqChannel == 1, p = ModelParam(i,j);zci = zci+(p*ChannelSq);,end
        end
        % Squared spectrum
        if abs(ModSqSpectrum) == 1
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
            for iGood=1:nGoodC,j=j+1; end % for iGood; not subtracted!     
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

ModelParamNames=char(ModelParamNames);
    
if PlotIt==1
    Figure=gcf;                   
    %DFigH=800;DFigV=600; dFig=20;         
       

       MedianSModelParam=median(SModelParam);
       TrunkatedSModelParam=max(SModelParam, ones(nObj,1)*MedianSModelParam/2);
       TrunkatedTModelParam= ModelParam./TrunkatedSModelParam;      
       MeanTrunkatedTModelParam=mean(abs(TrunkatedTModelParam));
       MaxTrunkatedTModelParam=max(abs(TrunkatedTModelParam));

        figure(Figure),    set(gcf,'Position',[dFig+dFig*Figure dFig+dFig*Figure DFigH DFigV])
       
       %How well are the regressand spectra modelled?
       if MscOrIsc==1
            subplot(221), plot(Z', 'b'),   xlabel('Channel #'),ylabel('Input spectra for MSC/EMSC')
            subplot(222), plot(Z', 'b'),hold on,        plot(ZHat','r'), title('Blue=input spectra, Red=modelled spectra')
            xlabel('Channel #')
        else
            subplot(221), plot(RefSpectrum, 'b') ,  xlabel('Channel #'),ylabel('Reference spectrum for ISC/EISC')
            subplot(222), plot(RefSpectrum, 'b'),hold on,        plot(RHat','r'),  plot(RefSpectrum,'b'),title('Blue=input ref., Red=modelled ref.')
            xlabel('Channel #')
        end % if MscOrIsc
       xlabel('Channel #')
       subplot(223),plot(EHat','k'),title('Modelling residuals')
       if max(ChannelWeights)~=min(ChannelWeights) % weighted least squares
             subplot(224),plot((EHat*diag(ChannelWeights))','k'),title('Weighted residuals')
       end % if max
       
       
       Figure=Figure+1;    figure(Figure),    set(gcf,'Position',[dFig+dFig*Figure dFig+dFig*Figure DFigH DFigV])
       cr=floor(sqrt(nModParam));       cc=ceil(nModParam/cr);
       for j=1:nModParam, subplot(cr,cc,j),plot(ModelParam(:,j),'b' ),hold on,
           
           plot(ModelParam(:,j) +2*SModelParam(:,j),'r:'),
           plot(ModelParam(:,j) -2*SModelParam(:,j),'r:'),
           plot(ModelParam(:,j),'b.' ),plot(ModelParam(:,j),'b' )
           ylabel('Est. +/- 2s'),title([num2str(j),',',ModelParamNames(j,:)]),  xlabel(['Obj #'])
           
       end 
          
       Figure=Figure+1;   figure(Figure),figure(Figure),     set(gcf,'Position',[dFig+dFig*Figure dFig+dFig*Figure DFigH DFigV])
       
       for j=1:nModParam, subplot(cr,cc,j),
           TTestLim1=1.5;  TTestLim2=3; % May be made into significance tests later
           if MeanTrunkatedTModelParam(j)>=TTestLim2,
               plot(TrunkatedTModelParam(:,j),'k'), hold on,plot(TrunkatedTModelParam(:,j),'k.'),
           elseif MeanTrunkatedTModelParam(j)>=TTestLim1,
               plot(TrunkatedTModelParam(:,j),'g'),hold on, plot(TrunkatedTModelParam(:,j),'g.'),
               disp(['Warning: Model parameter # ',num2str(j),',',ModelParamNames(j,:),', may be eliminated from the model,'])
               disp(['          due to its low significance level;   average t-value = ',num2str(round(10*MeanTrunkatedTModelParam(j))/10)])
           end % if
           if MaxTrunkatedTModelParam(j)<TTestLim2,
               plot(TrunkatedTModelParam(:,j),'r'), hold on, plot(TrunkatedTModelParam(:,j),'r.')
               disp(['Warning: Model parameter # ',num2str(j),',',ModelParamNames(j,:),', should definitely be eliminated from the model,'])
               disp(['          due to its low significance level;   max t-value = ',num2str(round(10*MaxTrunkatedTModelParam(j))/10)])
           end % if
           hold on
           ylabel('t-value')
           jj=round(10*MeanTrunkatedTModelParam(j))/10;
           title([num2str(j),',',ModelParamNames(j,:),',  avg.t-value=',num2str(jj) ])
           v=axis;
           plot([v(1),v(2)],[0,0],'k:')
       end % for
       
       Figure=Figure+1;    figure(Figure),    set(gcf,'Position',[dFig+dFig*Figure dFig+dFig*Figure DFigH DFigV])
       subplot(121), plot(ZMod), title('Model spectra'),axis tight,    xlabel('Channel #')
       v=axis; dv=v(4)-v(3); v(3)=v(3)-0.05*dv;v(4)=v(4)+0.05*dv; axis(v)
   
       subplot(122),  plot(ModelParam),hold on,plot(ModelParam,'.')
       axis tight,zoom on
       xlabel('Obj. #')
       title('All parameter estimates together ')

       
       
       % Corrected estimates of good and bad chemical constituents:
       nComp=LastCompChemConstit-LastCompBeforeChemConstit;
       if nComp>0
            CorrectedChemModelParam=ones(nObj, LastCompChemConstit-LastCompBeforeChemConstit); i=0;
            for j=LastCompBeforeChemConstit+1:LastCompChemConstit
                i=i+1;  
                if MscOrIsc==1 % EMSC
                    CorrectedChemModelParam(:,i)=ModelParam(:,j)./ModelParam(:,LastCompChemConstit+1);
                elseif MscOrIsc==(-1) % EISC                
                    CorrectedChemModelParam(:,i)=-ModelParam(:,j);
                else
                    error('wrong MSCOrISC')
                end %if
            end % for j
            
       Figure=Figure+1;   figure(Figure),     set(gcf,'Position',[dFig+dFig*Figure dFig+dFig*Figure DFigH DFigV])
            plot(CorrectedChemModelParam),title('Corrected chem. parameter estimates')
            xlabel('sample #'), ylabel('Parameter/slope')
      end % if nComp

       
end % if PlotIt






        
    

       
   







