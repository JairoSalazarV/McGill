if 1
  close all; clear all;
  clc;
  %% allEggs
  %%   yPosition -> index to be related with egg fertility
  %%   AVG
  %%     fertile
  %%     nonfertile
  %%   STD
  %%     fertile
  %%     nonfertile
  load('/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/COMP/allEggs.mat');
end
clc;

%%INITIALIZE
destinePath         = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/CrossValidation/';
trainingF_n         = 1280;
trainingI_n         = 640;
validationF_n       = 320;
validationI_n       = 160;
traininOutFilename  = [destinePath 'trainF' num2str(trainingF_n) '_trainI' num2str(trainingI_n)...
                       '_validF' num2str(validationF_n) '_validF' num2str(validationI_n) '.mat'];
maxF                = length( allEggs.AVG.fertile );
maxI                = length( allEggs.AVG.nonfertile );

%%RANDOMLY SELECT TRAINING
lstF                = 1:maxF;
lstI                = 1:maxI;
trainingLstF        = randperm(maxF,trainingF_n);
trainingLstI        = randperm(maxI,trainingI_n);
trainingLstPosF     = lstF(trainingLstF);
trainingLstPosI     = lstI(trainingLstI);
lstF(trainingLstF)  = [];
lstI(trainingLstI)  = [];

%%RANDOMLY SELECT VALIDATION
maxF                = length(lstF);
maxI                = length(lstI);
validationLstF      = randperm(maxF,validationF_n);
validationLstI      = randperm(maxI,validationI_n);
validationLstPosF   = lstF(validationLstF);
validationLstPosI   = lstI(validationLstI);

%%CREATE SUBSET
strSubset.trainingMeanF   = allEggs.AVG.fertile(trainingLstPosF,:);
strSubset.trainingMeanI   = allEggs.AVG.nonfertile(trainingLstPosI,:);
strSubset.validationMeanF = allEggs.AVG.fertile(validationLstPosF,:);
strSubset.validationMeanI = allEggs.AVG.nonfertile(validationLstPosI,:);

%%SAVE
save( traininOutFilename, 'strSubset' );
printf("Saved\n");
fflush(stdout);






