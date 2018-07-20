clear all; 
close all;
clc;

originDir     = '/media/jairo/My Passport/EGGFertility/HJDESCRIPTOR/miscelaneous/';
destineDir    = '/media/jairo/My Passport/EGGFertility/HJDESCRIPTOR/ALL/';
load( './Info/Group_fertile.mat' );
%% strHJEgg. | avgFertile avgInfertile lstFertile lstInfertile
load([originDir 'allHJAVG.mat']);

trainSize     = 80/100;
fertileSize   = 800;
infertileSize = 800;

%%%%%%%%%%%%%%%%%

%%Temporal Backup
subFertile      = strAllHJAVG.lstFertile;
subInfertile    = strAllHJAVG.lstInfertile;
%%Calc Training Size
fertileTrainN   = floor(fertileSize*trainSize);
infertileTrainN = floor(infertileSize*trainSize);
%%Get the number of Fertile and Infertile Data
numF            = size(subFertile,1);
numI            = size(subInfertile,1);
%%Randomly get trainin F&I list
fertilList      = randperm(numF,fertileTrainN);
infertilList    = randperm(numI,infertileTrainN);
%%Extract Training Subset
trainSubF       = subFertile(fertilList,:);
trainSubI       = subInfertile(infertilList,:);
%%Prepare Training Set
yF              = ones(fertileTrainN,1);
yI              = zeros(infertileTrainN,1);
X               = [trainSubF; trainSubI];
y               = [yF; yI];
%%Initialize RLR
lambda          = 0;
[y, p, model]   = runMultiRLR( [X y], lambda );

%%=========================================================
%%Build a Result Matrix
%%=========================================================
% Compute PF Matrix
PP=0; PF=0;
FP=0; FF=0;
n = size(y,1);
for i=1:n
  if (p(i)==1) && (y(i) == 1)
    PP++;
  end
  if (p(i)==1) && (y(i) == 0)
    PF++;
  end
  if (p(i)==0) && (y(i) == 1)
    FP++;
  end
  if (p(i)==0) && (y(i) == 0)
    FF++;
  end
end
%nF              = size( find(y == 1), 1 );
%nNF             = size( find(y == 0), 1 );
traininMatrix    = [PP        PF                    (PP+PF)             ((PP/(PP+PF))*100);...
                    FP        FF                    (FP+FF)             ((FF/(FP+FF))*100);...
                    (PP+FP)   (PF+FF)               ((PP+FP)+(PF+FF))   (((PP+FF)/((PP+PF)+(FP+FF)))*100);...
                    0         ((FF/(PF+FF))*100)    0                   0 ];
round(traininMatrix)