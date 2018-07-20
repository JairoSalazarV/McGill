function [CorrectedChemModelParam,OK]=EMSCPlotEMSCModelling(ZMod, ModelParamNames,ModelParam, SModelParam,CovModelParam,OptionsEMSC, OptionPlot,LocalEMSCResults,DataCase, DataCaseCal);

% File: EMSCPlotEMSCModelling.m
% Purpose: Plot local results from EMSC/EISC estimation
% Made by: H.Martens February 2003
% Input:
%   ZHat (nObj x nZVar) EMSC-fitted values of Z
%   RHat (1 x nZVar) EISC-fitted values of RefSpectrum
%   EHat Residuals from the modelling: (nObjxnZVar) if EMSC, (1 x nZVar) if  EISC
%   LastCompChemConstit (scalar) index of the last chemical component(s) in the model
%   LastCompBeforeChemConstit(scalar) index of the last component before the chemical  component(s) in the model
%   ZMod (nZVar x nModParam) the model spectra used
%   ModelParamNames(nModParam x :) char name of model parameters
%   ModelParam(nObj x nModParam) estimated EMSC or EISC parameters in the nObj objects
%   SModelParam(nObj x nModParam) estimated standard deviation of ModelParam
%   CovModelParam(nModParam x nModParam) covariance of model parameter estimates
%   OptionsEMSC{...}  options  for the EMSC/EISC estimation
%   OptionPlot{...}  options  for plotting
%   LocalEMSCResults[...) Defined in EMSCEISC
%   DataCaseCal (integer) # identifying the calibration method, ~=DataCase if prediction
% Output:
% MaxTrunkatedTModelParam (scalar) maximum stabilised t-test for model parameters
%
% Related files: Called from EMSCEISC.m
%
%   Remaining issues: Documentation not yet finished
% Version: 2.2.03 HM: Works


Z = OptionsEMSC{1};
[nObj,nZVar]=size(Z);
MscOrIsc=OptionsEMSC{4}; % NB!
ChannelWeights = OptionsEMSC{2}; 
RefSpectrum=OptionsEMSC{10}; 
ModRef= OptionsEMSC{5};
DataCaseTxt=['DataCase=',num2str(DataCaseCal)];
if DataCaseCal ~=DataCase
    DataCaseTxt=[DataCaseTxt,'/',num2str(DataCase)];
end % if

%ZHat,RHat,EHat,LastCompChemConstit, LastCompBeforeChemConstit:
 ZHat=LocalEMSCResults{1};  % (nObj x nZVar) EMSC-fitted Z spectra (NOT transformed)!
 RHat=LocalEMSCResults{2};  % (nObj x nZVar) EISC-fitted Ref. spectra (NOT transformed)! 
 EHat=LocalEMSCResults{3};  % (nObj x nZVar) EMSC- or EISC-fitted residual spectra (NOT transformed)!
 LastCompBeforeChemConstit=LocalEMSCResults{4};  %(scalar) index of the last model parameter before the input model spectra
 LastCompChemConstit=LocalEMSCResults{5};  %(scalar) index of the last input model spectrum
%               MeanTrunkatedTModelParam=LocalEMSCResults{6};  % ( 1 x nModelParam) mean trunkated t-value
%               MaxTrunkatedTModelParam=LocalEMSCResults{7};   % ( 1 x nModelParam) maximum trunkated t-value
%
[nVar,nModParamSpectra]=size(ZMod);

[nObj,nModParam]=size(ModelParam);

% Plot information:
PlotIt=OptionPlot{1};
DFigH=OptionPlot{2};DFigV=OptionPlot{3};dFig=OptionPlot{4};

    
% Significance testing of EMSC model or mean EISC model:
MedianSModelParam=median(SModelParam);
TrunkatedSModelParam=max(SModelParam, ones(nObj,1)*MedianSModelParam/2);
TrunkatedTModelParam= ModelParam./TrunkatedSModelParam;      
MeanTrunkatedTModelParam=mean(abs(TrunkatedTModelParam));
MaxTrunkatedTModelParam=max(abs(TrunkatedTModelParam));
       
DiagC=diag(CovModelParam)';
diagC=sqrt(DiagC);
DiagDiagC=diagC'*diagC;
ErrCovReltoDiag=CovModelParam./(DiagDiagC);
            
       
% Corrected estimates of good and bad chemical constituents:
nComp=LastCompChemConstit-LastCompBeforeChemConstit;
if nComp>0
    CorrectedChemModelParam=ones(nObj, LastCompChemConstit-LastCompBeforeChemConstit); 
    i=0;
    for j=LastCompBeforeChemConstit+1:LastCompChemConstit
        i=i+1; 
        %CorrectedChemModelParam(:,i)=-ModelParam(:,j);
        Titl=[' Chem. parameter estimates',DataCaseTxt];
        if ModRef==1|ModRef==2|ModRef==3
            Titl=['Corrected ',Titl];
            if MscOrIsc==1 % EMSC
                CorrectedChemModelParam(:,i)=ModelParam(:,j)./ModelParam(:,LastCompChemConstit+1);
            elseif MscOrIsc==(-1) % EISC
                CorrectedChemModelParam(:,i)=-ModelParam(:,j);
            else
                error('wrong MSCOrISC')
            end %if
        end % if ModRef
    end % for j
else
    CorrectedChemModelParam=[]; 
end % if nComp


% Plots: Initialize first plot
Fig=gcf; 
figure(Fig),    
set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV]) 

%if Fig==1,Fig=Fig-1;end % if Fig

if PlotIt>1
            ModelParamNames     
            CovModelParam
            DiagC
            diagC
            ErrCovReltoDiag
            %CovTotModelParam=(ModelParam'*ModelParam)/nObj
            %RMSModelParam=sqrt(mean(ModelParam.^2))
            %ErrCovReltoTotCov=CovModelParam./(CovTotModelParam)
            %ErrCovReltoRMS=CovModelParam./(RMSModelParam'*RMSModelParam)
  end % if 0
    
     
   if PlotIt>1 
       % Plot the EMSC modelling success
       Fig=Fig+1;    
       figure(Fig),    
       set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])
       
       %How well are the regressand spectra modelled?
       if MscOrIsc==1
            subplot(221), plot(Z', 'b'),   xlabel('Channel #'),ylabel('Input spectra for MSC/EMSC')
            subplot(222), plot(Z', 'b'),hold on,        plot(ZHat','r'), 
            title(['Blue=input spectra, Red=modelled spectra,',DataCaseTxt])
            xlabel('Channel #')
        else
            subplot(221), plot(RefSpectrum, 'b') ,  xlabel('Channel #'),ylabel('Reference spectrum for ISC/EISC')
            subplot(222), plot(RefSpectrum, 'b'),hold on,        
            plot(RHat','r'),  plot(RefSpectrum,'b'),
            title(['Blue=input ref., Red=modelled ref.,DataCase=',num2str(DataCaseCal)])
            xlabel('Channel #')
        end % if MscOrIsc
       xlabel('Channel #'),axis tight
       subplot(223),plot(EHat','k'),title([DataCaseTxt,', Modelling residuals'])
       if max(ChannelWeights)~=min(ChannelWeights) % weighted least squares
             subplot(224),plot((EHat*diag(ChannelWeights))','k'),title('Weighted residuals'),axis tight
       end % if max
   end % if PlotIt>1 
   
  if PlotIt>1 
       % Plot svd of the model
       Fig=Fig+1;     figure(Fig),    
       set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])
       %RCov=CovModelParam./(RMSModelParam'*RMSModelParam)
       [u,s,v]=svd(ErrCovReltoDiag);
       p=u*s;
       sratio=s(1,1)/s(2,2);
       if sratio<1000
       
        subplot(221), plot(p(:,1),p(:,2),'o')

        hold on
        for i=1:nModParamSpectra
             text(p(i,1),p(i,2),ModelParamNames(i,:))
        end% for i
        axis tight
        v=axis
        plot([v(1),v(2)],[0,0],'k:')
        plot([0,0],[v(3),v(4)],'k:')
        Fig=Fig+1;
       end % if
   end % if PlotIt>1
   
   if PlotIt>1 
       % Plot the EMSC model parameter significances
       Fig=Fig+1;    
       figure%Figure),    
       set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])
       cr=floor(sqrt(nModParam));       cc=ceil(nModParam/cr);
       for j=1:nModParam, subplot(cr,cc,j),plot(ModelParam(:,j),'b' ),hold on,
           plot(ModelParam(:,j) +2*SModelParam(:,j),'r:'),
           plot(ModelParam(:,j) -2*SModelParam(:,j),'r:'),
           plot(ModelParam(:,j),'b.' ),plot(ModelParam(:,j),'b' )
           ylabel('Est. +/- 2s'),title([num2str(j),',',ModelParamNames(j,:)]),  xlabel(['Obj #'])
       end 
       axis tight 
       
       Fig=Fig+1;  figure%(Figure)      
       set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])
       
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
           title([num2str(j),',',ModelParamNames(j,:),',  avg.t-value=',num2str(jj) ]),axis tight
           v=axis;
           plot([v(1),v(2)],[0,0],'k:')
       end % for
    end % if PlotIt>1
      
    
    if PlotIt>0
        % Plot joint model
       Fig=Fig+1; figure%(Figure),    
       set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])
       
       subplot(121), plot(ZMod), title([DataCaseTxt,', Model spectra']),axis tight,    xlabel('Channel #')
       v=axis; dv=v(4)-v(3); v(3)=v(3)-0.05*dv;v(4)=v(4)+0.05*dv; axis(v)
   
       subplot(122),  plot(ModelParam),hold on,plot(ModelParam,'.')
       axis tight,zoom on
       xlabel('Obj. #')
       title([DataCaseTxt,', All parameter estimates together '])
  end %if PlotIt>0  
      
  if PlotIt>0
        % Plot Corrected component concentrations
       if nComp>0
       Fig=Fig+1; figure%(Figure),     
       set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])
       
            plot(CorrectedChemModelParam),title(Titl),axis tight
            xlabel('sample #'), ylabel('Parameter/slope')
      end % if nComp
  end %if PlotIt>0
  
OK=1;
       
