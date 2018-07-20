% File EMSCMakeWeights.m
% Purpose: Generate weights
clear all,close all
OutFileName='EMSC_Wgt'

load EMSC_Z
[nObj,nXVar]=size(Matrix);

OD=Matrix;MeanOD=mean(OD);
figure, plot(OD','k'), hold on
plot(MeanOD,'b*')
xlabel('X-channel #'),ylabel('OD'), Titl=['Input data'];title(Titl)
ODLim=input('Give the unit where the error start to be come visible: ')
plot(ones(1,nXVar)*ODLim,'rx')
Titl=[Titl,', ODLim=',num2str(ODLim)];title(Titl)

T=10.^(-Matrix);TMeanOD=10.^(-MeanOD);TODLim=10.^(-ODLim);
figure, plot(T','k'),hold on
plot(TMeanOD,'b*')
plot(ones(1,nXVar)*TODLim,'r'),plot(ones(1,nXVar)*TODLim,'rx')

xlabel('X-channel #'),ylabel('T=10^-^O^D'), Titl=['T=10^-^O^D '];title(Titl)

Titl=[Titl,', 10^-^O^D^L^i^m=',num2str(TODLim)];title(Titl)


RelTMeanOD=TMeanOD/TODLim;
figure
plot(RelTMeanOD,'b')
xlabel('X-channel #'),ylabel('T Relative'), Titl2=['Basis for defining weights'];title(Titl2)
hold on
plot(ones(1,nXVar)*1,'rx')


Wgt=min(TMeanOD/TODLim,1);
figure
plot(Wgt,'r')
xlabel('X-channel #'),ylabel('Weight'), ;title(Titl)

ObjLabels=['Wgt,ODLim=',num2str(ODLim)];

Matrix=Wgt;

OK=input(['Should this be saved to file ',OutFileName,' ? 1=OK '])
if OK==1
    txt=['save ', OutFileName,' Matrix ObjLabels VarLabels'];disp(txt)
    eval(txt)
end %if 