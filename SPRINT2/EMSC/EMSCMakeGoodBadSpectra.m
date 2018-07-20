% File EMSCMakeGoodBadSpectra.m
% Purpose: Generate weights
% Made by H. Martens , (c) Consensus Analysis AS 2003
%
% reads EMSC_Z.mat and EMSC_Y.mat
% saves EMSC_AllGoodSpectra.mat
%   EMSC_GoodSpectra.mat 
%   EMSC_BadSpectra.mat
%.....................................................
clear all,close all

load EMSC_Z
[nObj,nZVar]=size(Matrix);

Z=Matrix;, ZLabels=VarLabels;
figure, plot(Z','k'), hold on
xlabel('Z-channel #'),ylabel('Z'), Titl=['Input data'];title(Titl)

if 1
 load EMSC_Y
[nObj,nYVar]=size(Matrix);

Y=Matrix;, YLabels=VarLabels;   
    
% GoodSpectra:
% model: Z=Y*K' + E

% All constituents read in EMSC_Y.mat:
Kt=pinv(Y)*Z;
K=Kt';
Matrix=Kt;
ObjLabels=YLabels ;VarLabels=ZLabels;
save EMSC_AllGoodSpectra Matrix ObjLabels VarLabels
figure,plot(Matrix'),xlabel('Z-channel #'), ylabel('signal'),
title('EMSC_AllGoodSpectra: projection of Z on Y')

% Only one of the constituents read in EMSC_Y.mat:

if nYVar>1
    YLabels
    jY=input(['Which of these variables do you want to use as Y?'])
else
    jY=1;
end 
Yj=Y(:,jY);
YjLabels=YLabels(jY,:);
Kt=pinv(Yj)*Z;
K=Kt';
Matrix=Kt;
ObjLabels=YjLabels ;VarLabels=ZLabels;
save EMSC_GoodSpectra Matrix ObjLabels VarLabels
figure,plot(Matrix'),xlabel('Z-channel #'), ylabel('signal'),
title(['EMSC_GoodSpectra: projection of Z on Y(',num2str(jY)])

% BadSpectra:
Y1=[ones(nObj,1) Y (Y-ones(nObj,1)*mean(Y)).^2];
% Model: Z=Y1*K' + E
K1=pinv(Y1)*Z;
E=Z-Y1*K1;
if nObj>=nZVar
    [U,S,V]=svd(E,0);
else
    [V,S,U]=svd(E',0);
end % if
s=diag(S)';
AM=length(s);
AM1=min(AM,7);
FirstSingVals=s(1:AM1)
figure,bar(s),xlabel('PC #'),ylabel('s')
figure
a=1; 
subplot(221),plot(V(:,a)*s(a)),xlabel('Z-variable #')
subplot(222),plot(U(:,a)*s(a)),xlabel('Z-object #')
a=2; 
subplot(223),plot(V(:,a)*s(a)),xlabel('Z-variable #')
subplot(224),plot(U(:,a)*s(a)),xlabel('Z-object #')

AUse=input('How many PCs should be defined as bad spectra?')

Matrix=V(:,1:AUse)*S(1:AUse,1:AUse);

Matrix=Matrix';

Labels=[];
for a=1:AUse
    Labels=[Labels;['PC',num2str(a)]];
end % for a
ObjLabels =char(Labels);
VarLabels=ZLabels;
save EMSC_BadSpectra Matrix ObjLabels VarLabels
figure,plot(Matrix'),xlabel('Z-channel #'), ylabel('signal'),
title(['EMSC_BadSpectra: residuals after projection of Z on 1,Y and Y^2'])

    
    
else
   % Old code: 

E=Z-ones(nObj,1)*mean(Z);
figure, plot(E','k'), hold on
xlabel('Z-channel #'),ylabel('Z, mean-centred'), Titl=['Mean-centred data'];title(Titl)

if nObj>=nZVar
    [U,S,V]=svd(E,0);
else
    [V,S,U]=svd(E',0);
end% if nObj
 
P=V*S;T=U*S;
s=diag(S)';
A=length(s);
s=s(1:min(A,10));
 
figure
bar(s)
xlabel('PC #')
ylabel('svd value')
 
figure
AMax=4;
for a=1:AMax
    subplot(4,2,2*(a-1)+1),plot(P(:,1:AMax),':'), hold on, plot(P(:,a),'r'), plot(P(:,a),'r*'),ylabel(['P, PC #',num2str(a)])
    if a==1,title('Loadings'),end
    if a==AMax,xlabel('Z-channel #'),end

    axis tight
    v=axis; plot([v(1),v(2)],[0,0],'k')
    subplot(4,2,2*a),plot(T(:,1:AMax),':'), hold on, plot(T(:,a),'r'), plot(T(:,a),'r*'),ylabel(['T, PC #',num2str(a)])
    if a==1,title('Scores'),end
    if a==AMax,xlabel('Sample #'),end
    v=axis; plot([v(1),v(2)],[0,0],'k')

end % for a


aGood=input('Give PC # for good spectrum '),GoodSpectrum=P(:,aGood);
aBad=input('Give PC # for bad spectrum '),BadSpectrum=P(:,aBad);
title('Green=good, Red=bad spectrum')
xlabel('Z-channel #')
ylabel('spectral value')

figure
plot(GoodSpectrum,'g*'),hold on, plot(GoodSpectrum,'g')
plot(BadSpectrum,'r*'),hold on, plot(BadSpectrum,'r')
OK=input(['Should this be saved as Good and bad spectra? 1=OK '])
if OK==1
   
    OutFileName='EMSC_GoodSpectra';    ObjLabels=['Good,a=',num2str(aGood)];
    txt='Matrix=GoodSpectrum;';,disp(txt),eval(txt),Matrix=Matrix';
    txt=['save ', OutFileName,' Matrix ObjLabels VarLabels'];disp(txt)
    eval(txt)
        
    OutFileName='EMSC_BadSpectra';    ObjLabels=['Bad,a=',num2str(aBad)];
    txt='Matrix=BadSpectrum;';disp(txt),eval(txt),Matrix=Matrix';
    txt=['save ', OutFileName,' Matrix ObjLabels VarLabels'];disp(txt)
    eval(txt)
end %if 
end % if 0
