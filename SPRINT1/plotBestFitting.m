close all; clear all; 
clc;

pkg load statistics;


numSlides = 20;
load(['/home/jairo/Documentos/OCTAVE/McGILL/DATA/allMatrixResults/slide' num2str(1) '.mat']);
m         = size(strAllResults,2);

X         = zeros(numSlides,m);
Y         = zeros(numSlides,m);

NFBet_Z               = [];
NFSuccess_Z           = [];
NFSuccessVsTotal_Z    = [];
NFErrorVsTotal_Z      = [];
NFError_Z             = [];
                    
for s=1:numSlides
  load(['/home/jairo/Documentos/OCTAVE/McGILL/DATA/allMatrixResults/slide' num2str(s) '.mat']);
  m           = size(strAllResults,2);
  %%yBet        = [];
  %%yFF         = [];
  xPerc               = [];
  mNFBet_Z            = [];
  mNFSuccess_Z        = [];
  mNFSuccessVsTotal_Z = [];
  mNFErrorVsTotal_Z   = [];
  mNFError_Z          = [];
  for i=1:m
    tmpNFPerc = strAllResults{i}.nfPercentage / 100;
    
    %tmpTotal  = strAllResults{i}.results.validation(1,3) + strAllResults{i}.results.validation(2,3);
    %tmpPerc   = strAllResults{i}.nfPercentage;
    %NFBet     = strAllResults{i}.results.validation(2,3);
    
    PP          = strAllResults{i}.results.validation(1,1);
    PF          = strAllResults{i}.results.validation(1,2);
    FP          = strAllResults{i}.results.validation(2,1);
    FF          = strAllResults{i}.results.validation(2,2);
    betF        = strAllResults{i}.results.validation(1,3);
    betNF       = strAllResults{i}.results.validation(2,3);
    tmpTotal    = betF + betNF;
    
    %%Translate to percentage
    xPerc       = [xPerc tmpNFPerc];
    
    %%NFBet
    NFBet               = ((FP+FF) / tmpTotal) * 100;
    if (FP+FF) > 0
      NFSuccess         = (FF / (FP+FF)) * 100;
    else
      NFSuccess         = 0;
    end
    
    NFSuccessVsTotal    = (FF / tmpTotal) * 100;
    NFErrorVsTotal      = (FP / tmpTotal) * 100;
    NFError             = 100 - NFSuccess;
    
    %%Acum
    mNFBet_Z            = [mNFBet_Z NFBet];
    mNFSuccess_Z        = [mNFSuccess_Z NFSuccess];
    mNFSuccessVsTotal_Z = [mNFSuccessVsTotal_Z NFSuccessVsTotal];
    mNFErrorVsTotal_Z   = [mNFErrorVsTotal_Z NFErrorVsTotal];
    mNFError_Z          = [mNFError_Z NFError];
    
  end
  X(s,:)                = xPerc;
  Y(s,:)                = ones(1,m)*s;
  NFBet_Z               = [NFBet_Z; mNFBet_Z];
  NFSuccess_Z           = [NFSuccess_Z; mNFSuccess_Z];
  NFSuccessVsTotal_Z    = [NFSuccessVsTotal_Z; mNFSuccessVsTotal_Z];
  NFErrorVsTotal_Z      = [NFErrorVsTotal_Z; mNFErrorVsTotal_Z];
  NFError_Z             = [NFError_Z; mNFError_Z];
end

Z1        = NFSuccessVsTotal_Z;
Z2        = NFErrorVsTotal_Z;
plotZ2    = 1;

Z1        = kron(Z1, [1;0;0]);
Z2        = kron(Z2, [1;0;0]);

Z1(end,:) = [];
Z2(end,:) = [];

y         = [0.3 0.6];
for tmpY=1:size(Y(:,1),1)
  y       = [y Y(tmpY,1) (Y(tmpY,1)+0.3) (Y(tmpY,1)+0.6)];
end
y(end-2:end)    = [];

x = kron([0 X(1,:)],ones(1,5));
x = x(4:end-2);

y = kron([0 y],ones(1,5));
y = y(4:end-2);

%y = kron([0 Y(:,1)'],ones(1,5));
%y = y(4:end-2);

mask_z  = [0,0,0,0,0;0,1,1,0,0;0,1,1,0,0;0,0,0,0,0;0,0,0,0,0];
z1      = kron(Z1,mask_z);
z2      = kron(Z2,mask_z);

hold on;

hS1     = surf(x,y,z1);
set(hS1,'FaceColor',[0 1 0]);
hS1_1   = surf(x,y,z1*0);
set(hS1_1,'FaceColor',[1 1 1]);

if plotZ2 == 1
  y       = y + 0.3;
  hS2     = surf(x,y,z2);
  set(hS2,'FaceColor',[1 0 0]);
  hS2_1   = surf(x,y,z2*0);
  set(hS2_1,'FaceColor',[1 1 1]);
end





xlabel("Infertile/Fertile Ratio (%)",'fontsize',22);
ylabel("Id Slide",'fontsize',22);
zlabel("Infertile Prediction (%)",'fontsize',22);
title("Regularized Logistic Regression, Overfitin and Underfiting Analysis. Dataset with 1500 Fertile. 80% Training and 20% Validation",'fontsize',22);


%{
hold on;
bar( xPerc, yBet, 'r' );
bar( xPerc, yFF, 'g' );

axis([0,110,0,100]);
l = legend({"Wrongly Lebeled as Infertile", "Sucessfully Labeled as Infertile"});
set(l, "fontsize", 15) 

xlabel("Infertile/Fertile Ratio (%)",'fontsize',22);
ylabel("Infertile Prediction (%)",'fontsize',22);
title("Regularized Logistic Regression, Overfitin and Underfiting Analysis. Dataset with 1500 Fertile. 80% Training and 20% Validation",'fontsize',22);
%}