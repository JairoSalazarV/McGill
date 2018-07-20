close all; clear all; clc;

%%====================================================
%%Initialize
%%====================================================
strSettings.numElementsF      = 1500;
strSettings.createData        = 1;
strSettings.validatingPerc    = 20 / 100;
strSettings.validatingNumSets = 3;
strSettings.print             = 0;
strSettings.slideDB           = '/media/jairo/My Passport/EGGFertility/allSlidesAVG/';%Preprocessing Slide Dataset
strSettings.originPath        = '/media/jairo/My Passport/EGGFertility/SUBSETS/';%Trainin and Validation

destinePath                   = '/media/jairo/My Passport/EGGFertility/miscelaneus/allMatrixResults/';

for s=20:1:20
  tic
  printf("Processing Slide %d...\n",s);;
  fflush(stdout);
  
  strSettings.idSlide = s;
  i                   = 1;
  lstPerc             = [2:2:50];
  m                   = size(lstPerc,2);
  for i=1:m
    strSettings.nonfertilePerc      = lstPerc(i) / 100;
    [tmpResults]                    = testSlideModel( strSettings );
    tmpResults.training
    tmpResults.validation
    
    strAllResults{i}.numElementsF   = strSettings.numElementsF;
    strAllResults{i}.nfPercentage   = lstPerc(i);
    strAllResults{i}.results        = tmpResults;
    i++;
  end

  %%====================================================
  %%Save Results
  %%====================================================
  destineFilename     = [destinePath 'slide' num2str(s) '.mat'];
  save(destineFilename,'strAllResults');
  
  toc
end
