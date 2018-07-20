%% Logistic Regression

%% Initialization
clear ; close all; clc

%% Load Data
%  The first two columns contains the exam scores and the third column
%  contains the label
s=15;
load( '/media/jairo/My Passport/EGGFertility/SUBSETS/trainingAllSlidesAVG1.mat' );

sub     = 13;
[n L]   = size(allSlidesAVG.fertileEggsAVGSignatures{s}.mean);
data    = [allSlidesAVG.fertileEggsAVGSignatures{s}.mean; allSlidesAVG.nonfertileEggsAVGSignatures{s}.mean];
X       = data(:,1:L-1);  % X is a #OfExamScores x 2 matrix
y       = [allSlidesAVG.fertileEggsAVGSignatures{s}.mean(:,L); allSlidesAVG.nonfertileEggsAVGSignatures{s}.mean(:,L)];      % y is a #OfExamScores x 1 matrix
%  Setup the data matrix appropriately, and add ones for the intercept term
[m, n]  = size(X);

% Add intercept term to x and X_test
X = [ones(m, 1) X];

% Initialize fitting parameters
initial_theta = zeros(n + 1, 1);

% Compute and display initial cost and gradient
[cost, gradient] = costFunction(initial_theta, X, y);

%fprintf('Cost at initial theta (zeros): %f\n', cost);
%fprintf('Gradient at initial theta (zeros): \n');
%fprintf(' %f \n', gradient);

%% ============= Optimizing using fminunc  =============
%  use a built-in function (fminunc) to find the
%  optimal parameters theta. Octave's fminunc is an optimization
%  solver that finds the minimum of an unconstrained function. 
%  For logistic regression, you want to optimize the cost
%  function J(theta) with parameters theta.

%  Set options for fminunc
options = optimset('GradObj', 'on', 'MaxIter', 400);

%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost 
[theta, cost] = fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

% Compute accuracy on our training set
p = predict(theta, X);

% Compute PF Matrix
n = max(size(y));
PP=0; PF=0;
FP=0; FF=0;
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

nF              = size( find(y == 1), 1 );
nNF             = size( find(y == 0), 1 );

fprintf('Train Accuracy | PF Matrix');
PFMatrix = [ PP PF nF; FP FF nNF ]

fprintf('\nTrain Accuracy %f \n\n\n', mean(double(p == y)) * 100);


