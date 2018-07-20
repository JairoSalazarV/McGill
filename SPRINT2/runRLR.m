function [accuracy] = runRLR(trainX,trainY,validX,validY)
  accuracy        = 0;
  lambda          = 0;
  [y, p, model]   = runMultiRLR( [trainX trainY], lambda );
  [resultMatrix]  = buildAccuracyMatrix( y, p );

  %%VALIDATE LOGISTIC REGRESSION
  addpath('../../Test/LR1/machineLearning/supervisedLearning/logisticRegression/');
  validP          = predict(model, validX);
  [validMatrix]   = buildAccuracyMatrix( validY, validP );
  accuracy        = (validMatrix(1,1) + validMatrix(2,2))/validMatrix(3,3);
end