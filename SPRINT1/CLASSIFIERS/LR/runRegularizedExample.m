% Regularized Logistic Regression

%% Initialization
clear ; close all; clc

%% Load Data
%  The first two columns contains the X values and the third column
%  contains the label (y).

%% Load Data
%  The first two columns contains the exam scores and the third column
%  contains the label
s=3;
load( '/media/jairo/My Passport/EGGFertility/miscelaneus/ReducedDatasetTest2/balancedAllSlidesAVG1.mat' );
data    = [allSlidesAVG.fertileEggsAVGSignatures{s}.mean; allSlidesAVG.nonfertileEggsAVGSignatures{s}.mean];
%n       = size(data,2);
%X       = data(:, 1:n-1);  % X is a #OfExamScores x 2 matrix
%y       = data(:, n);      % y is a #OfExamScores x 1 matrix

%data = load('inputTrainingSet2.txt');
m = size(data,2);
X = data(:, 1:2); y = data(:, m);

plotData(X(:,1:2), y);

% Put some labels 
hold on;

% Labels and Legend
xlabel('Layer 37')
ylabel('Layer 38')

% Specified in plot order
legend('y = 1', 'y = 0')
hold off;


%% =========== Regularized Logistic Regression ============
%  In this part, you are given a dataset with data points that are not
%  linearly separable. However, you would still like to use logistic 
%  regression to classify the data points. 
%
%  To do so, you introduce more features to use -- in particular, you add
%  polynomial features to our data matrix (similar to polynomial
%  regression).
%

% Add Polynomial Features

% Note that mapFeature also adds a column of ones for us, so the intercept
% term is handled
X = mapFeature(X(:,1),X(:,2));
%X  = [X X2];
%X  = X2;

% Initialize fitting parameters
initial_theta = zeros(size(X, 2), 1);

% Set regularization parameter lambda to 1
lambda = 1

% Compute and display initial cost and gradient for regularized logistic
% regression
[cost, grad] = costFunctionReg(initial_theta, X, y, lambda);

fprintf('Cost at initial theta (zeros): %f\n', cost);


%% ============= Regularization and Accuracies =============
%  In this part, you will get to try different values of lambda and 
%  see how regularization affects the decision coundart
%
%  Try the following values of lambda (0, 1, 10, 100).
%
%  NOTE: With a small lambda, you should notice that the classifier
%  gets almost every training example correct, but draws a very complicated
%  boundar, thus overfitting the data. However, with a larger lambda
%  you should see a plot that shows an simpler decision boundary
%  which still separates the positives and negatives fairly well. However,
%  make sure not to set lambda too high because then the decision 
%  boundary will underfit the data.

% Initialize fitting parameters
initial_theta = zeros(size(X, 2), 1);

% Set regularization parameter lambda to 1 (you should vary this)
lambda = 3;

% Set Options
options = optimset('GradObj', 'on', 'MaxIter', 400);

% Optimize
[theta, J, exit_flag] = ...
	fminunc(@(t)(costFunctionReg(t, X, y, lambda)), initial_theta, options);

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

nF              = max( size( find(y == 1) ) );
nNF             = max( size( find(y == 0) ) );

nEstimatedF     = max( size( find(p == 1) ) );
nEstimatedNF    = max( size( find(p == 0) ) );

PFMatrixAmount  = [ PP PF nEstimatedF; FP FF nEstimatedNF ];

PP              = (PP / nEstimatedF)*100;
PF              = (PF / nEstimatedF)*100;
FP              = (FP / nEstimatedNF)*100;
FF              = (FF / nEstimatedNF)*100;

fprintf('Train Accuracy | PF Matrix');
PFMatrix = [ PP PF nF; FP FF nNF ]
PFMatrixAmount

fprintf('\nTrain Accuracy %f \n\n\n', mean(double(p == y)) * 100);





