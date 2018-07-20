function [strResults] = testSlideModel( strSettings )

  %%====================================================
  %%Initialize
  %%====================================================
  %totalNumElements      = strSettings.numElementsF;
  createData            = strSettings.createData;
  idSlide               = strSettings.idSlide;
  nonfertilePerc        = strSettings.nonfertilePerc;
  validatingPerc        = strSettings.validatingPerc;
  validatingNumSets     = strSettings.validatingNumSets;
  print                 = strSettings.print;
  slideDB               = strSettings.slideDB;%Preprocessing Slide Dataset
  originPath            = strSettings.originPath;%Trainin and Validation

  %originTraining        = [originPath 'tmpTraining.mat'];%Trainin and Validation
  %originValiating       = [originPath 'tmpValidating.mat'];%Trainin and Validation

  %%====================================================
  %%Create Training and Validating Sets
  %%====================================================
  numElementsF        = strSettings.numElementsF;
  numElementsNF       = floor(numElementsF  * nonfertilePerc);
  numElementsF        = numElementsF - numElementsNF;
  
  printf("Creating Training Set with F=%d and NF=%d -> %d%%...\n",...
            numElementsF,...
            numElementsNF,...
            (nonfertilePerc*100));
  fflush(stdout);
  allSlidesAVG = balancedPrepareDataset(slideDB, '', numElementsF, numElementsNF, print, 0);
    
  %%====================================================
  %%Run Classifier
  %%====================================================
  %% | LR | RLR | multiRLR | 
  %%====================================================
  optimizerName                   = "multiRLR";
  lambda                          = 0;

  printf("Training...\n");
  fflush(stdout);
  [resultTraining, y, p, model]   = runSlideModelMemory(allSlidesAVG, optimizerName, idSlide, lambda);
  %strResults{1}                   = resultTraining;

  %plot(model);

  %%====================================================
  %%Validate
  %%====================================================
  %% | LR | RLR | multiRLR | 
  %%====================================================
  printf("Validating %d%%...\n",(validatingPerc*100));
  fflush(stdout);
  
  %%Create Dataset
  validationNumElementsF  = floor(numElementsF  * validatingPerc);
  validationNumElementsNF = floor(validationNumElementsF * nonfertilePerc);
  validationNumElementsF  = validationNumElementsF - validationNumElementsNF;
  acumValidResukt         = [];
  for k=1:validatingNumSets
    
    printf("Creating Validation Set with F=%d and NF=%d...\n",  validationNumElementsF, validationNumElementsNF);
    fflush(stdout);
    allSlidesAVG = balancedPrepareDataset(slideDB, '', validationNumElementsF,...
                                          validationNumElementsNF, print, 0);
    
    %%Validating
    printf("Validating Dataset %d...\n",k);
    fflush(stdout);
    [resultValidating, y, p]  = runValidateSlideModelFromMemory(allSlidesAVG, optimizerName, idSlide, model);
    %strResults{k}             = resultValidating;
    if k==1
      acumValidResukt         = resultValidating;
    else
      acumValidResukt         = acumValidResukt + resultValidating;
    end
  end

  %%====================================================
  %%Display Results
  %%====================================================
  acumValidResult             = acumValidResukt / validatingNumSets;
  strResults.trainingModel    = model;
  strResults.training         = resultTraining;
  strResults.validation       = acumValidResult;

  
end










