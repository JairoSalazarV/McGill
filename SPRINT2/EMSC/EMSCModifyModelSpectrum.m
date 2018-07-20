function [NormC,SumSpectr,OptionsEMSC]=EMSCModifyModelSpectrum(OptStartVector,c,W,OptionsEMSC,OptimizedPar);
% Purpose: Use the new scores in C to modify Reference,BadSpectrum or GoodSpectrum according to OptimizedPar(1:3)
% Made by: H.Martens (c) Consensus Analysis AS Jan.2003
% Input:
%       OptStartVector (1 x nZVar)
%       c (1 x nPar) score vector
%       W(nXVar x nPar) loadings
%       OptionsEMSC{10}=Ref
%       OptionsEMSC{11}=Bad spectrum
%       OptionsEMSC{12}=Good spectrum
%       OptimizedPar{1}=1: modify Ref
%       OptimizedPar{2}=1: modify Bad spectrum
%       OptimizedPar{3}=1: modify Good spectrum
% Output:
%       NormC(scalar) length of C
%       SumSpectr(scalar) sum of reconstructed spectrum  
%       OptionsEMSC{10}=Ref
%       OptionsEMSC{11}=Bad spectrum
%       OptionsEMSC{12}=Good spectrum
% Called from: EMSCEISCOpt.m, EMSCEISCEvalRMSEP.m
%
% Version: 020203 HM: Works
%

        
% ModRef=OptionsEMSC{5};


NormC=norm(c);   
%cNormed = C/NormC; % normed ?

ReconstrSpectrum = c*W'; % may be scaled to similar ss as the other vectors, or to ref
OptSpectrum=OptStartVector+ReconstrSpectrum;
SumSpectr=sum(OptSpectrum); % Ensure positive sum

% ReconstrSpectrum=ReconstrSpectrum/sum(ReconstrSpectrum);

if OptimizedPar(1)==1
    NewSpectrum=OptStartVector+ReconstrSpectrum; % new Ref spectrum?
    % Check the length of the NewSpectrum:
    ssStartVector=sum(OptStartVector.^2);
    if ssStartVector>1000*eps,
        % A start vector other than zero has been given.
        if 1
           ssNewVector=sum(NewSpectrum.^2);
           OldNew=NewSpectrum;
           NewSpectrum=NewSpectrum*sqrt(ssStartVector/ssNewVector);
        else
            % not in use
        end % if 1
    end % if ssStartVector
    
    OptionsEMSC{10} = NewSpectrum;
    
    %figure,plot(OptStartVector,'b'),hold on, plot(ReconstrSpectrum,'r')
    %plot(NewSpectrum,'g')
    %keyboard

elseif OptimizedPar(2)==1 % modify the last  spectrum in BadC
        %OptSpectrum=OptSpectrum/(norm(OptSpectrum));
        BadC=OptionsEMSC{11};
        [nBadParam,nZVar]=size(BadC);
        % Scale OptSpectrum:
        if nBadParam>1
            NotOptSpectrum=BadC(1,:);
            %OptOld=OptSpectrum;
            Sp=[NotOptSpectrum',OptSpectrum'];
            r=corrcoef(Sp);
            SignR=sign(r(1,2)); 
            OptSpectrum=OptSpectrum*sqrt(sum(NotOptSpectrum.^2))/sqrt(sum(OptSpectrum.^2))*SignR; % ss=ss of first spectrum
        else
            SignS=sign(sum(OptSpectrum));
            OptSpectrum=OptSpectrum/sqrt(sum(OptSpectrum.^2))*SignS; % ss=1
        end % if nBadParam     
         %disp([r(1,2),SignR]),figure(1),clf,
 %subplot(221),plot(NotOptSpectrum,OptSpectrum), subplot(222),plot([NotOptSpectrum;OptSpectrum;OptOld]'),
 %pause

        BadC(nBadParam,:)=OptSpectrum;
        OptionsEMSC{11} =BadC ; % Bad EMSC parameter
elseif OptimizedPar(3)==1 % Modify the last spectrum in GoodC
        %OptSpectrum=OptSpectrum/(norm(OptSpectrum));
        GoodC=  OptionsEMSC{12};
        % Scale OptSpectrum:
        [nGoodParam,nZVar]=size(GoodC);
        if nGoodParam>1
            NotOptSpectrum=GoodC(1,:);
            Sp=[NotOptSpectrum',OptSpectrum'];
            r=corrcoef(Sp);
            SignR=sign(r(1,2));
            ReconstrSpectrum=ReconstrSpectrum*sqrt(sum(NotOptSpectrum.^2))/sqrt(sum(OptSpectrum.^2))*SignR;% ss=ss of first spectrum
        else
            SignS=sign(sum(OptSpectrum));
            OptSpectrum=OptSpectrum/sqrt(sum(OptSpectrum.^2))*SignS; % ss=1
        end % if nBadParam
        GoodC(nGoodParam,:)=OptSpectrum; 
        OptionsEMSC{12} =GoodC ; % Bad EMSC parameter
        % figure(1),clf
        %plot(GoodC'),title(['c=',num2str(c)]),keyboard
        
else
        error('No parameter to be optimised, so why call this routine then?')
end % if  OptimizedPar(1)==2
