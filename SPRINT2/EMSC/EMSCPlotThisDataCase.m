 function [CaseLog]=EMSCPlotThisDataCase(DataCase, DataCaseCal, DataCaseName, ZCorrected, PlotIt, PrintPlots,CaseLog,OptionsEMSC, OptionsSearch,OptionPlot)
% file:EMSCPlotThisDataCaseOptionsEMSC.m
% Purpose: Plot results for this DataCase
% Made by: H.Martens (c)Consensus Analysis AS Februar 2003
% Input: 
%...
% Output:
% ...
%
% Related files:
%           Called from: RunEMSCOpt
%           Calls EMSCRegressionCheck.m,EMSCFindAOpt.m
% Version: 020203 HM: Works
%


global EMSCLog  
Fig=gcf;       


% Get some parameters:
PlotIt=OptionPlot{1};    DFigH=OptionPlot{2};    DFigV=OptionPlot{3};    dFig=OptionPlot{4};    RegrMethod=OptionPlot{5};
ASearchDim= OptionsSearch{6};    
AMax= OptionsSearch{7};   
FactorNeeded= OptionsSearch{17};    
OptimizedPar=OptionsSearch{20};
OptStartVector=OptionsSearch{21};

% The optimised spectra:
RefSpectrum=OptionsEMSC{10};BadC=OptionsEMSC{11};GoodC=OptionsEMSC{12};
%if  OptimizedPar(1)==1,  
%elseif OptimizedPar(2)==1, 
%elseif OptimizedPar(3)==1, 
%end %if

DirectoryName=OptionsEMSC{16};
ZFileName=OptionsEMSC{17};    Z=OptionsEMSC{1};        
YFileName=OptionsEMSC{22};    Y=OptionsEMSC{23};           
YName=OptionsEMSC{24}; 
ChannelWeights = OptionsEMSC{2}; 
DataCaseTxt=['DataCase=',num2str(DataCaseCal)];
if DataCaseCal ~=DataCase
    DataCaseTxt=[DataCaseTxt,'/',num2str(DataCase)];
end % if

[nObj,nZVar]=size(Z);
[nObjY,nYVar]=size(Y);

PCName=OptionPlot{6}; 

% Display some resulting numbers:

if PlotIt>1
    disp(['DataCase#=',num2str(DataCase),', = ',DataCaseName])
    Fig=gcf; 
    [OK]=EMSCPlotEMSCLog(Fig,DFigH,DFigV,dFig,ASearchDim,AMax,OptimizedPar,OptStartVector,RefSpectrum,BadC,GoodC,DataCaseTxt);

    %[OK]=EMSCPlotEMSCLog(Fig,DFigH,DFigV,dFig, ...
    %ASearchDim,AMax,OptimizedPar,OptStartVector,RefSpectrum,BadC,GoodC,DataCaseTxt);
end %if Plot>1


if nYVar>0 % Testing predictive performance if Y has been read in
        % Y data have been read

        % Before EMSC/EISC:
        %AUse=1;
        APlot=1;% Later: AOpt
        % PCR with leverage correction
        [XMean,YMean,W,T,Q,P,E,F,YHat,YHatCV,RMSECY,RMSEPY]=EMSCRegressionCheck(Z,Y,ChannelWeights,RegrMethod,AMax);
        

        %[XMean,YMean,W,T,Q,P,E,F,YHat,YHatCV,RMSECY,RMSEPY]=EMSCRegressionCheck(Z,Y,RegrMethod,AMax,AUse);
        
        RMSEPYBefore=RMSEPY;
        [AOptBefore,RMSEPYBeforeAOpt]=EMSCFindAOpt(RMSEPY,FactorNeeded);
        RMSEPYBefore0PC=RMSEPY(1);
        RMSEPYBefore1PC=RMSEPY(2);
        
        

        if  PlotIt>0
            Fig=Fig+1;    
            figure
            set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])
            subplot(221),      plot((0:AMax), RMSEPYBefore,'g:'), hold on,plot((0:AMax), RMSEPYBefore,'go')
            plot((0:AMax), RMSECY,'k.')
            xlabel([PCName, ' PC #']), ylabel('Before, RMSEP(o), RMSEC(.)'), title([ DataCaseTxt,' ',DataCaseName,', before'])
            yh=YHatCV(:,1+APlot);r=corrcoef(yh,Y);r=r(1,2);,axis tight
            subplot(223),plot(Y,YHat(:,1+APlot),'k.'),title(['Cal. for y from input Z, r_C_V=',num2str(round(r*1000)/1000)])
            hold on,plot(Y,yh,'ro'),plot(Y,YHat(:,1+APlot),'k.'),axis tight
            xlabel('Input y'), ylabel([' Y fitted=., full CV=o, using ',num2str(APlot),' PCs'])
        
        end % if PlotIt
        % After EMSC/EISC:
        %[XMean,YMean,W,T,Q,P,E,F,YHat,YHatCV,RMSECY,RMSEPY]=EMSCRegressionCheck(ZCorrected,Y,RegrMethod,AMax,AUse);
                
        [XMean,YMean,W,T,Q,P,E,F,YHat,YHatCV,RMSECY,RMSEPY]=EMSCRegressionCheck(ZCorrected,Y,ChannelWeights,RegrMethod,AMax);

        [AOptAfter,RMSEPYAfterAOpt]=EMSCFindAOpt(RMSEPY,FactorNeeded);
        RMSEPYAfter1PC=RMSEPY(2); 
        RMSEPYAfter=min(RMSEPY,RMSEPYBefore0PC*1.1);
        
        if  PlotIt>0

            subplot(222),       plot((0:AMax), RMSEPYBefore,'g:'),hold on,plot((0:AMax), RMSEPYBefore,'go')
            plot((0:AMax), RMSEPYAfter,'r') ,plot((0:AMax), RMSEPYAfter,'r*'), plot((0:AMax), RMSEPYAfter,'k.')
            xlabel([PCName, ' PC #']), ylabel('after, RMSEP(*),RMSEC(.) '), title([ DataCaseTxt, '   after pre-treatment'])
            yh=YHatCV(:,1+APlot);r=corrcoef(yh,Y);r=r(1,2);,axis tight
            subplot(224),plot(Y,YHat(:,1+APlot),'k.'),title(['Cal. for y after EMSC/EISC, r_C_V=',num2str(round(r*1000)/1000) ])
            xlabel('Input y'), ylabel([' Y fitted=., full CV=o, using ',num2str(APlot),' PCs'])
            hold on,plot(Y,yh,'ro'),plot(Y,YHat(:,1+APlot),'k.'),axis tight
    
            if PrintPlots==1,print,end
        end %if PlotIt
        
        % Save Y-results for this run:
        ThisLog=[DataCase, RMSEPYBefore1PC,RMSEPYAfter1PC, RMSEPYBeforeAOpt,RMSEPYAfterAOpt, AOptBefore, AOptAfter];
        CaseLog=[CaseLog; ThisLog];  
        
     
        %   save kladd RMSEPYBefore,ThisLog 
        
end % if nYVar>0



if PlotIt>0
    Fig=gcf+1;  
    % if PlotIt==0, Fig=1;end ????

    figure
    set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])  
    subplot(221),plot(Z'),title(['Input, ', strcat(DirectoryName,ZFileName);])
    ylabel('Response'),xlabel('Channel #'),axis tight
    subplot(222),plot(ZCorrected'),title(['Output, ',DataCaseTxt,', ',DataCaseName ])
    ylabel('Response'),xlabel('Channel #'),axis tight
    subplot(223),plot((Z-ones(nObj,1)*mean(Z))'),title(['Input, ', strcat(DirectoryName,ZFileName);])
    ylabel('Mean-Centred Response'),xlabel('Channel #'),axis tight
    subplot(224),plot((ZCorrected-ones(nObj,1)*mean(ZCorrected))'),title(['Output,',DataCaseTxt,', ',DataCaseName ])
    ylabel('Mean-Centred Response'),xlabel('Channel #'),axis tight
    
    if PrintPlots==1,print,end
end %if PlotIt

%Fig=gcf;     
%for f=1:Fig,figure(f),end % just to make them come out in the right order