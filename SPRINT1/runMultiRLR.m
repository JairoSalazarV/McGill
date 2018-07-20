function [y, p, theta] = runMultiRLR( X, lambda )
  %%Initialize
  [n, L]  = size( X );
  y       = X(:,L);
  X       = X(:,1:L-1);
  L--;
  
  addpath("/home/jairo/Documentos/OCTAVE/Test/LR1/machineLearning/supervisedLearning/logisticRegression/");

  % Initialize fitting parameters
  initial_theta = zeros(size(X, 2), 1);

  % Compute and display initial cost and gradient for regularized logistic
  % regression
  [cost, grad] = costFunctionReg(initial_theta, X, y, lambda);

  % Initialize fitting parameters
  initial_theta = zeros(size(X, 2), 1);

  % Set Options
  options = optimset('GradObj', 'on', 'MaxIter', 400);

  % Optimize
  [theta, J, exit_flag] = ...
    fminunc(@(t)(costFunctionReg(t, X, y, lambda)), initial_theta, options);

  % Compute accuracy on our training set
  p = predict(theta, X);
  
end