% File EMSCMakeGoodSpectra.m
% Purpose: Generate weights
clear all,close all
OutFileName='EMSC_GoodSpectra'

load EMSC_Z
[nObj,nXVar]=size(Matrix);

Z=Matrix;
figure, plot(Z','k'), hold on
xlabel('X-channel #'),ylabel('OD'), Titl=['Input data'];title(Titl)
for i=1:nObj
    disp(['Object ',num2str(i),' = ',ObjLabels(i,:)])
end %for i

i=input('Give sample # for good spectrum ')
GoodSpectrum=Z(i,:);
plot(GoodSpectrum,'b*')

ObjLabels=['Good,i=',num2str(i)];

Matrix=GoodSpectrum;
OK=input(['Should this be saved to file ',OutFileName,' ? 1=OK '])
if OK==1
    txt=['save ', OutFileName,' Matrix ObjLabels VarLabels'];disp(txt)
    eval(txt)
end %if 
