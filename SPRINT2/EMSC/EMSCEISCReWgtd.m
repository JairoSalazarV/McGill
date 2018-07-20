%function [ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,LocalEMSCResults,OptionsEMSC] = EMSCEISCReWgtd(OptionsEMSC,OptionPlot)
%   Purpose: Extended MSC or ISC  , with re-estimated ChannelWeights
%   Made by H. Martens January 2003
%       (c) Consensus Analysis AS 2002
% NB! the EMSC/EISC methodology is patented. 
%       Academic use of of this code is free, but
%       commercial use of it requires permission from the author.
%       Contact: StarkEdw@aol.com   or Harald.Martens@matforsk.no
%
% 
%   Input: ...
%      OptionsEMSC,OptionPlot (Defined in EMSCGetParametersAndData.m)
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
%           OptionsEMSC (Defined in EMSCGetParametersAndData.m), 
%               but OptionsEMSC{2}=the re-estimated ChannelWeights;, to be saved to file EMSC_ReEstWgts_<InputFileName>(num2str(DataCase) if nWeightIter=OptionsEMSC{25}>0
%               
%
%   Related files: 
%       Called from     EMSC_Main.m
%                 
%       Calls           EMSCEISC.m
%                        
%
%   Status:  230203 HM:First version, works
%              
% Remaining:           Documentation and testing is not finished yet

%-------------------------------------------------------------------------------


function [ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,LocalEMSCResults,OptionsEMSC] = EMSCEISCReWgtd(OptionsEMSC,OptionPlot)

PlotIt=   OptionPlot{1};
PlotItLocal=0; % local plot control for debugging only % 
WgtLim=1;
ChannelWeights0  = OptionsEMSC{2};  % Start values
SumChannelWeight=sum(ChannelWeights0);
nWeightIter=OptionsEMSC{25};

MeanResidlStd=0;MedianResidlStd=0;TestCrit=0;
Iter=0;
Converged=0;
Z=OptionsEMSC{1};
[nObj,nZVar]=size(Z);
EHat=zeros(nObj,nZVar);



while Converged==0
    Iter=Iter+1;    
    if Iter>=nWeightIter
        Converged=-1;
    end % if Iter
    
    ChannelWeights=ChannelWeights0;
    ChannelWeightsAll(Iter,:) = ChannelWeights; 
    OptionsEMSC{2}=ChannelWeights; % The weights to be used in this iteration
    
    [ZCorrected,ModelParamNames,ZMod,ModelParam,CovModelParam,SModelParam,LocalEMSCResults] = EMSCEISC(OptionsEMSC,OptionPlot);
    EHat=LocalEMSCResults{3};

        
    nModParam=size(ZMod,2);
    %LocalEMSCResults=[ {ZHat} {RHat} {EHat} {LastCompBeforeChemConstit} {LastCompChemConstit} {MeanTrunkatedTModelParam} {MaxTrunkatedTModelParam}  ];
    
    ResidlVariance=sum(EHat.^2)/(nObj-nModParam);
    ResidlStd=sqrt(ResidlVariance);
    
    % New weights:
    MedianResidlStd=median(ResidlStd);
    if MedianResidlStd>0
        TestCrit=WgtLim*MedianResidlStd;
    else
        TestCrit=1;
    end % if
        
    RelResidlStd=ResidlStd/TestCrit; % 1 or larger
    MeanResidlStd=sqrt(mean(ResidlVariance));
    SumChannelWeight=sum(ChannelWeights);   
    ChannelWeights0= ones(1,nZVar)./max(RelResidlStd,eps);
    ChannelWeights0=min(ChannelWeights0,1); % Max weight=1
    
    ThisIterWeightStat=[Iter MeanResidlStd MedianResidlStd SumChannelWeight TestCrit Converged];
    WeightStat(Iter,:)=ThisIterWeightStat;
    
    if PlotIt>1 %........................
       if Iter==1
             figure,clf 
       end %if Iter
       if nWeightIter>0
            pause(1)
            clf
            %subplot(222),    plot(abs(EHat)','r:'),hold on
       end % if
       subplot(221),plot(ChannelWeightsAll'),hold on,plot(ChannelWeights,'.'),title('ChannelWeightsAll')      
       subplot(222),plot(abs(EHat)','k'),title(['Iter=',num2str(Iter),' abs(EHat)'])
       hold on
       plot(ones(nZVar,1)*TestCrit,'g')
       subplot(223),plot(WeightStat(:,1),WeightStat(:,2),'r'),hold on,plot(WeightStat(:,1),WeightStat(:,3),'b')
       title('MeanStd=r, MedianStd=b'),xlabel('Iteration #'),ylabel('Residual Std.Dev.: r=rms,b=median')
       subplot(224),plot(WeightStat(:,1),WeightStat(:,4),'k') ,   title('Sum Wgts=k')
       xlabel('Iteration #'),ylabel('SumWeight')
       if nWeightIter>0,
            if PlotIt>2
                disp('        Iter MeanResS MedianResS SumWeights TestCrit Converged')
                disp(WeightStat)
                % OptionsEMSC{2}=ChannelWeights; % the final weights were already stored before the call to EMSCEISC!
            end % if PlotIt
        end  % if nWeightIter
    end % if PlotIt% ............................
        
end % while Converged

        
    


   







