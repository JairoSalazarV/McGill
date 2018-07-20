function [OK]=EMSCPlotAllDataCases(iCase, CaseLog, OptionPlot);
% File:EMSCPlotAllDataCases.m
% Made by: H.Martens Consensus Analysis AS February 2003
% Called from: RunEMSCOpt
PlotIt=OptionPlot{1};    DFigH=OptionPlot{2};    DFigV=OptionPlot{3};    dFig=OptionPlot{4};    RegrMethod=OptionPlot{5};

    Fig=gcf;
    if iCase>1
        Fig=Fig+1;    figure 
        set(gcf,'Position',[dFig+dFig*Fig dFig+dFig*Fig DFigH DFigV])
        subplot(121)
        Col=2; plot(CaseLog(:,Col),'r:'),hold on,plot(CaseLog(:,Col),'r.'),
        Col=4; plot(CaseLog(:,Col),'b:'),plot(CaseLog(:,Col),'b:.')
        Col=3; plot(CaseLog(:,Col),'r'),  Col=3; plot(CaseLog(:,Col),'ro')
        Col=5; plot(CaseLog(:,Col),'b'),  Col=5; plot(CaseLog(:,Col),'b+')
        xlabel('DataCase '),ylabel('RMSEP(Y)'), title('Comparison of DataCases, r=1 PC, b= A_O_p_t PCs;  ...=input data')
        m1=max(CaseLog(:,2));m2=max(CaseLog(:,4));        m=max(m1,m2);
        axis tight,    v=axis; 
        v(4)=v(4)+(v(4)-v(3))*0.05;
        v(4)=min(v(4),m);
        v(3)=0;axis(v)
        
    
        subplot(122)
        Col=6; plot(CaseLog(:,Col),'b:'),hold on,plot(CaseLog(:,Col),'b.')
        Col=7; plot(CaseLog(:,Col),'b'),plot(CaseLog(:,Col),'b+')
        xlabel('DataCase '),ylabel('A_O_p_t'), title('Optimal # of PCs, ...=input data')
        axis tight,    v=axis;    v(4)=v(4)+(v(4)-v(3))*.05;v(3)=0;axis(v)
    end %if iCase
    OK=1;