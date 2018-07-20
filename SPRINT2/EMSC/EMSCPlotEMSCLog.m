function [OK]=EMSCPlotEMSCLog(Fig,DFigH,DFigV,dFig,ASearchDim,AMax,OptimizedPar,OptStartVector,RefSpectrum,BadC,GoodC,DataCaseTxt);
% Purpose: Show some results from the optization process
% Made by: H.Martens (c) Consensus Analysis AS 2003
% Related files: Called from EMSCPlotThisDataCase.m
% Input:
% 
% Output: 
%
%
% Status: 2.4.03: Works

global EMSCLog  


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
        title([DataCaseTxt,',r=Crit., k=1PC, b:pun.opt, b--:A p.,g:opt, m:min, c:L.p.'])
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
        plot( (0:AMax)', RMSEPs(:,nIter),'ro')
        ylabel('RMSEP'),xlabel('# of PCs')
        axis tight
        zoom on
        

        % Optimization performance:
        if  sum(OptimizedPar)>0
            Fig=Fig+1;    figure 
            set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])    
            Tit=[DataCaseTxt];
            %if (min(OptStartVector~=0))|(max(OptStartVector~=0)) % not just zeroes
                %plot(OptStartVector,'r:')
                %hold on
                %Tit='r...=start';
                %else
            %    Tit=[];
            %end %if min
            if OptimizedPar(1)==1, plot(RefSpectrum'),  hold on,Tit= [Tit,', Opt.Ref.spectrum '];
                plot(OptStartVector,'r:')          
                Tit=[Tit,', r...=its start'];
            elseif OptimizedPar(2)==1,
                n=size(BadC,1);
                if n==1
                    plot(BadC','r'),hold on,Tit= [Tit,',r=Opt.Bad spectrum '  ];
                else % n==1>1
                    plot(BadC(1:n-1,:)','b.'),hold on,Tit= [Tit,',b.=Inp.Bad spectrum ' ];
                    plot(BadC(n,:)','r'),Tit= [Tit,',r=Opt.Bad spectrum '  ];
                end % if n
                plot(OptStartVector,'r:')
                hold on
                Tit=[Tit,', r...=its start'];
            elseif OptimizedPar(3)==1, 
                 n=size(GoodC,1);
                if n==1
                    plot(GoodC','r'),hold on,Tit= [Tit,',r=Opt.Good spectrum ' ];
                else % n==1>1
                    plot(GoodC(1:n-1,:)','b.'),hold on,Tit= [Tit,',b.=Inp.Good spectrum ' ];
                    plot(GoodC(n,:)','r'),Tit= [Tit,',r=Opt.Good spectrum '  ];
                end % if n
                plot(OptStartVector,'r:')
                hold on
                Tit=[Tit,', r...= its start'];
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
OK=1;