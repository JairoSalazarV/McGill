clear all; 
close all;
clc;

originDir     = '/media/jairo/My Passport/EGGFertility/HJDESCRIPTOR/miscelaneous/';
destineDir    = '/media/jairo/My Passport/EGGFertility/HJDESCRIPTOR/ALL/';
load( './Info/Group_fertile.mat' );
%load([originDir 'allHJAVG.mat']);

lstF          = find(Y==1);
lstNF         = find(Y==0);

%% strHJEgg. | fertile rotated name hist38 heatMap
numF          = size(lstF,1);
numNF         = size(lstNF,1);
N             = numF + numNF;
percP         = 5/100;
numSteps      = floor(numF / numNF);

%%
lstAccuracyMean = [];
lstAccuracyStd  = [];
lstErrorMean    = [];
lstErrorStd     = [];
proportionX     = [];
for t=1:numSteps
  
  %MAKE A SUBSET
  tmpY                  = Y;
  numFertToDel          = t * numNF;
  toDelete              = randperm(numF,numFertToDel);
  tmpY(lstF(toDelete))  = [];
  tmpN                  = size(tmpY,1);
  numP                  = floor(tmpN * percP);
  
  %% EVALUATE
  lstAccuracy     = [];
  lstError        = [];
  for i=1:10
    posP          = randperm(tmpN,numP);%Cuales predijo que son inferties
    sumFerP       = sum( tmpY(posP) );  %A cuantos le falló
    errror        = sumFerP / numP;
    accuracy      = 1 - errror;
    lstAccuracy   = [lstAccuracy (accuracy*100)];
    lstError      = [lstError (errror*100)];
  end
  accuracyMean    = mean(lstAccuracy);
  accuracyStd     = std(lstAccuracy);
  lstAccuracyMean = [lstAccuracyMean accuracyMean];
  lstAccuracyStd  = [lstAccuracyStd accuracyStd];
  
  errorMean       = mean(lstError);
  errorStd        = std(lstError);
  lstErrorMean    = [lstErrorMean errorMean];
  lstErrorStd     = [lstErrorStd errorStd];
  
  
  proportionX     = [proportionX ((numNF/tmpN)*100)]
end
plot(proportionX,proportionX,'-ob',"markersize", 6, "linewidth", 3,"markerfacecolor","b");
hold on;
bar(proportionX+0.05,lstErrorMean,'r');
bar(proportionX,lstAccuracyMean,'g');
bar(proportionX(end),lstErrorMean(end),'r');
xlabel("Percentage(%)",'fontsize',20);
ylabel("Percentage(%)",'fontsize',20);
l = legend("Fertile/Infertile ratio","Prediction Error","Prediction Success");
legend (l, "location", "northeastoutside");
title('RANDOM EVALUATION','fontsize',25);



