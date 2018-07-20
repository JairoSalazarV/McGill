function [DataCases,DialogueParams]=EMSCDialogue( DialogueParams);
% Purpose: Primitive control the dialogue with the user
% Made by: H.Martens February 2003
% Input:
%   DialogueParams(1 x 5)
%   where
%     EnoughDataCases=DialogueParams(1);
%     PrintPlots=DialogueParams(2);
%     PrintPlots=DialogueParams(3);
%     PlotALot=DialogueParams(4);
%     PauseBetweenDataCases=DialogueParams(5);
%   
% Output:
%   DialogueParams(1 X 5) same as imput, but updated
%   DataCases (1 x ?) the data cases to be tested
%
% Related files:
%           Called from EMSC_Main.m
% Remaining issues:
%   The logic is a little cumbersome and unclear, and the screen play is horrible
%

     EnoughDataCases=DialogueParams(1);     PrintPlots=DialogueParams(2);     PrintPlots=DialogueParams(3);
     PlotALot=DialogueParams(4);     PauseBetweenDataCases=DialogueParams(5);
     
     
MoreDialogue=1;
while MoreDialogue==1
    disp(' ')
    disp('--------------------------------------------------------------------')
    disp(' 1000=list options,               -1000=stop')
    disp(' 2000=turn on printing of plots,  -2000=turn off printing of plots   ');
    disp(' 3000=   more plots,              -3000=less plots   ');
    disp(' 4000=pause between  DataCases,   -4000=no pause between  DataCases   ');
    disp(' Other numbers, see list options'),    DataCase=input('DataCase=? ')

               
    DataCases=DataCase; % By default

    if DataCase==(-1000)
        EnoughDataCases=1; MoreDialogue=0;
    elseif DataCase==2000
        PrintPlots=1;                        
    elseif DataCase==(-2000)
        PrintPlots=0;                        
    elseif DataCase==3000
        PlotALot=PlotALot+1;                 
        PlotALot=min(PlotALot,3);
        disp(['Plot level is now: ',num2str(PlotALot)])
    elseif DataCase==(-3000)
        PlotALot=PlotALot-1;                 
        PlotALot=max(PlotALot,0);
        disp(['Plot level is now: ',num2str(PlotALot)])
    elseif DataCase==4000
        PauseBetweenDataCases=1;             
    elseif DataCase==(-4000)
        PauseBetweenDataCases=0;             
    elseif DataCase==1000
        EMSCGetListAlternatives,   
    else
        MoreDialogue=0;
    end % if DataCase
end % while MoreDialogue=1

    

if EnoughDataCases==0; %
        if DataCase==(99)
            DataCases=(1:1:98) ; % All cases, def. in EMSCGetUserDefinedDataCases
        elseif DataCase==(199)
            DataCases=(100:1:198);  %  All EMSC cases, def. in EMSCGetInternalDataCases, 100= no pretreatment
        elseif DataCase==(299)
            DataCases=(201:1:298);  %  All EISC cases, def. in EMSCGetInternalDataCases
        elseif DataCase==(399)        
            DataCases=(301:1:310);  %  Published cases, def. in EMSCGetInternalDataCases
        elseif DataCase==(499)
            DataCases=(401:1:498);  %  Other cases, def. in EMSCGetInternalDataCases
        elseif DataCase==(599)
            DataCases=[(100:1:198),(201:1:298),(1:1:98)];  %  All EMSC/EISC cases, 
                    %   def. in EMSCGetInternalDataCases and EMSCGetUserDefinedDataCases
            PlotALot=0;PauseBetweenDataCases=0; 
        elseif DataCase==(-99)
            DataCases=[(-3):(-1):(-98)];% Some prediction cases, def. in GetDefaultInputDataForPred.m
        else
            DataCases=DataCase; % Run one individual DataCase
        end % if DataCase
end %If EnoughDataCases

        
% Update the parameters    
DialogueParams =[EnoughDataCases, PrintPlots,PrintPlots,PlotALot,PauseBetweenDataCases];
