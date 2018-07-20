clear all; close all;
clc;

pkg load statistics;

%%PATHS
addpath('/home/jairo/Documentos/OCTAVE/McGILL/');
addpath('/home/jairo/Documentos/OCTAVE/McGILL/SPRINT2/EMSC/');

%%WAVELENGTHS
load('/home/jairo/Documentos/OCTAVE/McGILL/Info/wavelength.mat');

%% strSubset
%%  trainingMeanF
%%  trainingMeanI
%%  validationMeanF
%%  validationMeanI
originPath    = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/CrossValidation/';
load([originPath 'trainF1280_trainI640_validF320_validF160.mat']);

%%INITIALIZE
dataF         = [strSubset.trainingMeanF; strSubset.validationMeanF];
dataI         = [strSubset.trainingMeanI; strSubset.validationMeanI];
yF            = [ones(size(dataF,1),1)];
yI            = [zeros(size(dataI,1),1)];

if 1
  %dataPre_A   = [dataF;dataI];
  dataPRE_F   = dataF;
  dataPRE_I   = dataI;
  
  %% MSC (Multiplicative Scaller Correction) ;
  [dataPRE_F] = msc(dataPRE_F);
  [dataPRE_I] = msc(dataPRE_I);
  %[dataPre_A] = msc(dataPre_A);

  %%SECOND DERIVATIVE
  [dataPRE_F] = data2ndDerivative(dataPRE_F);
  [dataPRE_I] = data2ndDerivative(dataPRE_I);
  %[dataPre_A] = data2ndDerivative(dataPre_A);

  %%MEAN CENTER
  [dataPRE_F] = dataMeanCenter(dataPRE_F);
  [dataPRE_I] = dataMeanCenter(dataPRE_I);
  %[dataPre_A] = dataMeanCenter(dataPre_A);
  
  %plot(dataPRE_F','g');hold on;
  %plot(dataPRE_I','--r');
  C = [118 144 120 125 156];
  
  scatter3( dataPRE_F(:,C(1)),dataPRE_F(:,C(2)),dataPRE_F(:,C(3)), 'g' );
  hold on;
  scatter3( dataPRE_I(:,C(1)),dataPRE_I(:,C(2)),dataPRE_I(:,C(3)), 'r');
  
  %nF  = size(dataF,1);
  %scatter3( dataPre_A(1:nF,C(1)),dataPre_A(1:nF,C(2)),dataPre_A(1:nF,C(3)), 'g' );
  %hold on;
  %scatter3( dataPre_A(nF:end,C(1)),dataPre_A(nF:end,C(2)),dataPre_A(nF:end,C(3)), 'r');
  
  
  xlabel('X');
  ylabel('Y');
  zlabel('Z');
  %%CROSS-VALIDATION
  %f           = @(trainX,trainY,validX,validY)(runRLR(trainX,trainY,validX,validY));
  %lstL        = [118,120,125,144,156];
  %accuracy    = crossval(f, [dataPRE_F(:,lstL);dataPRE_I(:,lstL)], [yF;yI])
  
else
  %{
  %% MSC (Multiplicative Scaller Correction) ;
  [MSC_F]             = msc(strSubset.trainingMeanF);
  [MSC_I]             = msc(strSubset.trainingMeanI);

  %%Second Derivative
  [MSC_2ndDeriv_F]    = data2ndDerivative(MSC_F);
  [MSC_2ndDeriv_I]    = data2ndDerivative(MSC_I);

  %%Mean Center
  [MSC2ndMeanCenter_F]= dataMeanCenter(MSC_2ndDeriv_F);
  [MSC2ndMeanCenter_I]= dataMeanCenter(MSC_2ndDeriv_I);
  
  %%PLOT
  [R C] = size(MSC2ndMeanCenter_F);
  for i=1:R
    scatter(Wavelength,MSC2ndMeanCenter_F(i,:),'g');hold on;
  end
  [R C] = size(MSC2ndMeanCenter_I);
  for i=1:R
    scatter(Wavelength,MSC2ndMeanCenter_I(i,:),'r');
  end
  %}
end

%{
%%RUN LOGISTIC REGRESSION
lambda          = 0;
[y, p, model]   = runMultiRLR( [trainPRE trainY], lambda );
[resultMatrix]  = buildAccuracyMatrix( y, p );
resultMatrix

%%VALIDATE LOGISTIC REGRESSION
validP          = predict(model, validPRE);
[validMatrix]   = buildAccuracyMatrix( validY, validP );
validMatrix
%}

%{
%% MSC (Multiplicative Scaller Correction) ;
[trainPRE]  = msc(trainX);
[validPRE]  = msc(validX);

%%SECOND DERIVATIVE
[trainPRE]  = data2ndDerivative(trainPRE);
[validPRE]  = data2ndDerivative(validPRE);

%%MEAN CENTER
[trainPRE]  = dataMeanCenter(trainPRE);
[validPRE]  = dataMeanCenter(validPRE);
%}


%{
subplot(1,2,1);
plot(Wavelength,MSC_F','g');
hold on;
plot(Wavelength,MSC_2ndDeriv_F','--g');

subplot(1,2,2);
plot(Wavelength,MSC_I','r');
hold on;
plot(Wavelength,MSC_2ndDeriv_I','--r');
%}

%{
subplot(1,2,1);
plot(Wavelength,strSubset.trainingMeanF','g');hold on;
plot(Wavelength,MSC_F','k');
axis([800 1800 0 0.55]);

subplot(1,2,2);
plot(Wavelength,strSubset.trainingMeanI','r');hold on;
plot(Wavelength,MSC_I','k');
axis([800 1800 0 0.55]);
%}

%%SECOND DERIVATIVE







