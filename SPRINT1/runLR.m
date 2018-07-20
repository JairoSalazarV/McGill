function [y, p, theta] = runLR( X )
  %%Initialize
  [n, L]  = size( X );
  y       = X(:,L);
  X       = X(:,1:L-1);
  L--;

  %%=========================================================
  %%Run LR
  %%=========================================================
  addpath( './CLASSIFIERS/LR/' );

  % Add intercept term to x and X_test
  X = [ones(n, 1) X];

  % Initialize fitting parameters
  initial_theta = zeros(L + 1, 1);

  % Compute and display initial cost and gradient
  [cost, gradient] = costFunction(initial_theta, X, y);

  %  Set options for fminunc
  options = optimset('GradObj', 'on', 'MaxIter', 400);

  %  Run fminunc to obtain the optimal theta
  %  This function will return theta and the cost 
  [theta, cost] = fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

  % Compute accuracy on our training set
  p = predict(theta, X);
  
end