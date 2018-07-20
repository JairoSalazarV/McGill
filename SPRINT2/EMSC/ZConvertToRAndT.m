% File ZConvertToRandT

clear all
format compact

load R24Red5Sorted
Groups=[       cellstr( '1 0.1% ')];
Groups=[Groups;cellstr( '2 0.1% Whitener+Homogen.')];
Groups=[Groups;cellstr( '3 1.3% Homogen')];
Groups=[Groups;cellstr( '4 1.3%')];
Groups=[Groups;cellstr( '5 1.3% Whitener+Homogen.')];
Groups=[Groups;cellstr( '6 3.5% Homogen.')];
Groups=char(Groups)

XAll=Matrix;
VarLabelsAll=VarLabels;

Matrix=XAll(:,22:231);
VarLabels=VarLabelsAll(22:231,:);
save R Matrix ObjLabels VarLabels

Matrix=-log10(Matrix);
save ODR Matrix ObjLabels VarLabels


YClass=XAll(:,1); Y1=XAll(:,1); ObjLabelsY=ObjLabels;



save YClass YClass ObjLabelsY  Groups




load T24Red5Sorted
XAll=Matrix;
VarLabelsAll=VarLabels;

Matrix=XAll(:,22:231);
VarLabels=VarLabelsAll(22:231,:);
save T Matrix ObjLabels VarLabels

Matrix=-log10(Matrix);
save ODT Matrix ObjLabels VarLabels

Y2=XAll(:,1); 
d=Y1-Y2;
if max(abs(d))>eps
    error('not same order!')
end % if max