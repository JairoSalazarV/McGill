clear all; close all;
clc;

pkg load image;
load('./Info/wavelength.mat');

%--------------------------------------------------
%Initialize
%--------------------------------------------------
DATAPath      = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCirclePCA/';
%destinePath   = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100Denoised/';
[lstFiles]    = dir(DATAPath);
lstFiles      = lstFiles(3:max(size(lstFiles)));
numFiles      = max(size(lstFiles));

%--------------------------------------------------
%Plot
%--------------------------------------------------
for i=1:30%numFiles
  originFilename = [ DATAPath lstFiles(i).name ];
  load(originFilename);
  tmpData = tmpStr.PCA.DATA(:,1:3);
  if tmpStr.fertile == 0
    tmpColor = 'r';
  else
    tmpColor = 'g';
  end
  scatter3(tmpData(:,1),tmpData(:,2),tmpData(:,3),tmpColor,'filled');
  %scatter(tmpData(:,1),tmpData(:,3),tmpColor,'filled');
  hold on;
end
xlabel('PCA1','fontsize',20);
ylabel('PCA2','fontsize',20);
zlabel('PCA3','fontsize',20);