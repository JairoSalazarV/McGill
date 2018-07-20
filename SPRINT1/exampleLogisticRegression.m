% Generate the input vector x and the provided output vector y
N=100;
a = sort(randn(10*N,1));
x = hist(a,N)';
ytemp=cumsum(x);
y=ytemp/max(ytemp); % you can replace x and y with your own data
% y is the provided output (the one to be fitted)
figure('position',[100, 100, 1024, 768]);
plot(y,'.-b')
set(gca,'nextplot','add');
X=[ones(N,1),(1:N)'];
indexes_ok = find(y~=1);
h=log(y(indexes_ok)./(1-y(indexes_ok)));
beta = X(indexes_ok,:)\h; % beta is the vector with the needed coefficients
y_bar = 1./(1+exp(-(X*beta))); % y_bar is the fitted output (the reconstructed one)
plot(y_bar,'-om');
ah=legend('Provided output y (to be modeled as $y=\frac{1}{1+e^{- {\beta_0} + {\beta_1} x}}$)', ...
         ['Fitted output $\bar{y}=\frac{1}{1+e^{-(' sprintf('%g + %g x)}}$', beta(1), beta(2)) ]);
set(ah,'interpreter','latex', 'location','NorthWest','fontsize',12);
title('A simple example of (univariate) logistic regression in Matlab');
