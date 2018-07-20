% File EMSCMakeRef.m
% Purpose: Generate weights
clear all,close all
OutFileName='EMSC_Ref'
load EMSC_Z
[nObj,nXVar]=size(Matrix);

OD=Matrix;MeanOD=mean(OD);
figure, plot(OD','k'), hold on
plot(MeanOD,'b*')
xlabel('X-channel #'),ylabel('OD'), Titl=['Input data'];title(Titl)

ObjLabels='Ref=mean';
Matrix=MeanOD;

OK=input(['Should this be saved to file ',OutFileName,' ? 1=OK '])
if OK==1
    txt=['save ', OutFileName,' Matrix ObjLabels VarLabels'];disp(txt)
    eval(txt)
end %if 
