clear all; close all;
clc;

pkg load image;
load('./Info/wavelength.mat');

%--------------------------------------------------
%Initialize
%--------------------------------------------------
DATAPath            = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100Mask/';
destinePath         = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/COMP/';
[lstFiles]          = dir(DATAPath);
lstFiles            = lstFiles(3:max(size(lstFiles)));
numFiles            = max(size(lstFiles));
load( [DATAPath lstFiles(1).name] );
[n L]               = size(tmpStr.maskedEGG);
fertileAVG          = [];
nonfertileAVG       = [];

for i=1:numFiles
  load( [DATAPath lstFiles(i).name] );
  tmpAvg          = mean( tmpStr.maskedEGG );
  if tmpStr.fertile == 1
    fertileAVG    = [fertileAVG; tmpAvg];
  else
    nonfertileAVG = [nonfertileAVG; tmpAvg];
  end
end
plot( Wavelength, fertileAVG, 'g' );
hold on;
plot( Wavelength, nonfertileAVG, 'r' );
title('Green: Fertile | Red: Nonfertile', 'fontsize', 17);
xlabel('Wavelength', 'fontsize', 16);
ylabel('Average Absorbance', 'fontsize', 16);

AVG.fetile          = fertileAVG;
AVG.nonfertile      = nonfertileAVG;
destineFertile      = [ destinePath 'orginalAVG.mat' ];
save(destineFertile,'AVG');
