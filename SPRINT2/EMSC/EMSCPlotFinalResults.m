% file: EMSCPlotFinalResults.m
% Made by: H.Martens Consensus Analysis AS Februar 2003
% Called from: RunEMSCOpt

    Fig=gcf+1;  
    if PlotIt==0, Fig=1;end
    figure
    set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])   
    subplot(121),plot(Z'),title(['Input, ', strcat(DirectoryName,ZFileName);])
    ylabel('Response'),xlabel('Channel #')
    subplot(122),plot(ZCorrected'),title(['Output, DataCase=',num2str(DataCase),', ',DataCaseName ])
    ylabel(DataCaseName),xlabel('Channel #')
    
    figure(1),    subplot(221), title(['DataCase=',num2str(DataCase),', ',DataCaseName])
    
    for f=1:Fig,figure(f),end % just to make them come out in the right order


    if nYVar>0 % Testing predictive performance if Y has been read in
        % Y data have been read

        % Before EMSC/EISC:
        AUse=1;
        APlot=1;% Later: AOpt
        % PCR with leverage correction
        %[XMean,YMean,W,T,Q,P,E,F,YHat,YHatCV,RMSECY,RMSEPY]=PLSRFullCV(Z,Y,AMax);
        [XMean,YMean,W,T,Q,P,E,F,YHat,YHatCV,RMSECY,RMSEPY]=RegressionCheck(Z,Y,RegrMethod,AMax,AUse);
        
        RMSEPYBefore=RMSEPY;
        [AOptBefore,RMSEPYBeforeAOpt]=FindAOptEMSC(RMSEPY,FactorNeeded);
        RMSEPYBefore1PC=RMSEPY(2);
        Fig=Fig+1;    
        figure
        dFig=20 ;    set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])
        subplot(221),      plot((0:AMax), RMSEPYBefore,'g:'), hold on,plot((0:AMax), RMSEPYBefore,'go')
        plot((0:AMax), RMSECY,'k.')
        xlabel([PCName, ' PC #']), ylabel('Before, RMSEP(o), RMSEC(.)'), title([ 'DataCase=' ,num2str(DataCase),' ',DataCaseName,', before'])
        yh=YHatCV(:,1+APlot);r=corrcoef(yh,Y);r=r(1,2);
        subplot(222),plot(Y,YHat(:,1+APlot),'k.'),title(['Cal. for y from input Z, r_C_V=',num2str(round(r*1000)/1000)])
        hold on,plot(Y,yh,'ro'),plot(Y,YHat(:,1+APlot),'k.'),axis tight
        xlabel('Input y'), ylabel([' Y fitted=., full CV=o, using ',num2str(APlot),' PCs'])

        % After EMSC/EISC:
        [XMean,YMean,W,T,Q,P,E,F,YHat,YHatCV,RMSECY,RMSEPY]=RegressionCheck(ZCorrected,Y,RegrMethod,AMax,AUse);
        
        [AOptAfter,RMSEPYAfterAOpt]=FindAOptEMSC(RMSEPY,FactorNeeded);
        RMSEPYAfter1PC=RMSEPY(2); 
        subplot(223),       plot((0:AMax), RMSEPYBefore,'g:'),hold on,plot((0:AMax), RMSEPYBefore,'go')
        plot((0:AMax), RMSEPY,'r') ,plot((0:AMax), RMSEPY,'r*'), plot((0:AMax), RMSECY,'k.')
        xlabel([PCName, ' PC #']), ylabel('after, RMSEP(*),RMSEC(.) '), title([ '   after pre-treatment'])
        yh=YHatCV(:,1+APlot);r=corrcoef(yh,Y);r=r(1,2);
        subplot(224),plot(Y,YHat(:,1+APlot),'k.'),title(['Cal. for y after EMSC/EISC, r_C_V=',num2str(round(r*1000)/1000) ])
        xlabel('Input y'), ylabel([' Y fitted=., full CV=o, using ',num2str(APlot),' PCs'])
        hold on,plot(Y,yh,'ro'),plot(Y,YHat(:,1+APlot),'k.'),axis tight
    
        % Save Y-results for this run:
        ThisLog=[DataCase, RMSEPYBefore1PC,RMSEPYAfter1PC, RMSEPYBeforeAOpt,RMSEPYAfterAOpt, AOptBefore, AOptAfter];
        CaseLog=[CaseLog; ThisLog]; 
    end % if nYVar>0

    % Display some resulting numbers:
    disp(['DataCase#=',num2str(DataCase),', = ',DataCaseName])

    [nIter,nLog ]=size(EMSCLog);
    if nIter>0 %IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
        %     1     2          3       4           5           6        7        8        9         10     10+1:10+ASearchDim, 10+ASearchDim+1:nLog 
        %Log=[Iter,RMSEPCrit,AOptp,RMSEPAOptp, OtherPunishment, AOpt,RMSEPAOpt, RMSEPY1PC,RMSEPYMin,AMin, c,RMSEPY];
        Fig=Fig+1;    figure 
        set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])
        subplot(231)
        plot(EMSCLog(:,1), (EMSCLog(:,2)),'r')  % RMSEPY Criterium optimised for
        hold on
        plot(EMSCLog(:,1), (EMSCLog(:,4)),'b:') % Optimal rmsep, rank punished
        plot(EMSCLog(:,1), (EMSCLog(:,4)-EMSCLog(:,7)),'b--') %   length punishment
        plot(EMSCLog(:,1), (EMSCLog(:,5)),'c:') % Punishment length C
        plot(EMSCLog(:,1), (EMSCLog(:,9)),'m')  % RMSEPY min
        plot(EMSCLog(:,1), (EMSCLog(:,7)),'g') % Optimal rmsep when no rank punishment is used
        plot(EMSCLog(:,1), (EMSCLog(:,8)),'k')  % RMSEPY 1 PC
        plot(EMSCLog(:,1), (EMSCLog(:,2)),'r.')  % RMSEPY Criterium optimised for
        axis tight,v=axis;xlabel('Iteration'),ylabel('RMSEPY')
        title('r=Crit., k=1PC, b:pun.opt, b--:A p.,g:opt, m:min, c:L.p.')
        zoom on

        subplot(232)
        plot(EMSCLog(:,1), log10(max(EMSCLog(:,2),eps)),'r')  % RMSEPY Criterium optimised for
        hold on
        plot(EMSCLog(:,1), log10(max(EMSCLog(:,4),eps)),'b:') % Optimal rmsep, rank punished
        %plot(EMSCLog(:,1), (EMSCLog(:,4)-EMSCLog(:,7)),'y:') %   length punishment
        %plot(EMSCLog(:,1), log10(EMSCLog(:,5)),'c:') % Punishment length C
        plot(EMSCLog(:,1), log10(max(EMSCLog(:,9),eps)),'m')  % RMSEPY min
        plot(EMSCLog(:,1), log10(max(EMSCLog(:,7),eps)),'g') % Optimal rmsep when no rank punishment is used
        plot(EMSCLog(:,1), log10(max(EMSCLog(:,8),eps)),'k')  % RMSEPY 1 PC

        plot(EMSCLog(:,1), log10(max(EMSCLog(:,2),eps)),'r.')  % RMSEPY Criterium optimised for
        axis tight,v=axis;
        xlabel('Iteration'),ylabel('log(RMSEPY)')
        title('r=Crit., k=1PC,  b:pun.opt, g:opt,m:min')
        zoom on
        axis tight

        subplot(233)
        plot(EMSCLog(:,1),EMSCLog(:,3),'b') % AOptp
        hold on
        plot(EMSCLog(:,1),EMSCLog(:,6),'g')  % AOpt
        plot(EMSCLog(:,1),EMSCLog(:,10),'m')  % AMin
        plot(EMSCLog(:,1),EMSCLog(:,3),'r.') % AOptp
        xlabel('Iteration'),ylabel('A, # of PCs')
        title('A for: b:pun.opt, g=opt, m=min') 
        axis tight
        zoom on

        subplot(234)
        Scores=EMSCLog(:,10+1:10+ASearchDim);
        plot(EMSCLog(:,1),Scores)  
        ylabel('Par.val.'),xlabel('Iterations')
        axis tight
        zoom on

        subplot(235)
        %     1     2          3       4           5           6        7        8        9         10     10+1:10+ASearchDim, 10+ASearchDim+1:nLog 
        %Log=[Iter,RMSEPCrit,AOptp,RMSEPAOptp, OtherPunishment, AOpt,RMSEPAOpt, RMSEPY1PC,RMSEPYMin,AMin, c,RMSEPY];

        RMSEPs=EMSCLog(:,10+ASearchDim+1:nLog)';
        plot( (0:AMax)', RMSEPs)
        hold on
        plot( (0:AMax)', RMSEPs(:,nIter),'r'),        plot( (0:AMax)', RMSEPs(:,nIter),'ro')
        ylabel('RMSEP'),xlabel('# of PCs')
        axis tight
        zoom on

        % Optimization performance:
        if  sum(OptimizedPar)>0
            Fig=Fig+1;    figure 
            set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])           
            if (min(OptStartVector~=0))|(max(OptStartVector~=0)) % not just zeroes
                plot(OptStartVector,':')
                hold on
                Tit=', ...=start';
            else
                Tit=[];
            end %if min
            if OptimizedPar(1)==1, plot(RefSpectrum),Tit= ['Opt.Ref.spectrum ',Tit];
            elseif OptimizedPar(2)==1, plot(BadC),Tit= ['Opt.Bad spectrum ',Tit];
            elseif OptimizedPar(3)==1, plot(GoodC),Tit= ['Opt.Good spectrum ',Tit];
            end % if
            title(Tit)
            xlabel('Z-channel'),ylabel('spectral value')
        end %if sum

        [nLastIter,nLog]=size(EMSCLog);
        if 0
        disp('      1     2          3            4           5             6        7      ')
        disp('    Iter,  RMSEPCrit,  AOptp,  RMSEPAOptp, OtherPun., AOpt,  RMSEPAOpt')
        EMSCLog(:,1:7)

        disp('      1     2          3            ...      ')
        disp('    Iter,  par 1,      par 2, ...')
        IterScores=[EMSCLog(:,1),Scores]

        %     1     2          3       4           5           6        7        8        9         10        ...   ....
        %Log=[Iter,RMSEPCrit,AOptp,RMSEPAOptp, OtherPunishment, AOpt,RMSEPAOpt, RMSEPY1PC,RMSEPYMin,AMin,  RMSEPY,C];
        end % if 0
        
   
    end % if nIter>0 %IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
 