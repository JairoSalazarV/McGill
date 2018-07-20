clear all; close all;
clc;

pkg load image;
load('./Info/Group_fertile.mat');
load('./Info/wavelength.mat');

%--------------------------------------------------
%Initialize
%--------------------------------------------------
DATAPath            = '/media/jairo/My Passport/HSI/';
destinePath         = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/COMP/';
fertileAVG          = [];
nonfertileAVG       = [];
fertileSTD          = [];
nonfertileSTD       = [];
yPosition           = [];
numFiles            = max(size(Y));
for i=1:numFiles
  %Prepare Data to Save
  newFilename     = [sprintf('%06d', FGName(i) ) '.mat'];
  originFile      = [ DATAPath newFilename ];

  %Load Cube if Exists
  if exist( originFile )
    %Load file
    load( originFile );
    %Get masked spectral pixels
    tmpMaskedPixels = [];
    [R C L]   = size( EGG );
    for r=1:R
      lstC    = find(mask(r,:)==1);
      if max(size(lstC)) > 1
        tmpMaskedPixels     = [tmpMaskedPixels; squeeze(EGG(r,lstC,:))];
      end
    end
    %Denoise Data
    tmpMaskedDenoisedPixels = tmpMaskedPixels - noiseEstimationHysime(tmpMaskedPixels);
    tmpMean                 = mean( tmpMaskedDenoisedPixels );
    tmpSTD                  = std( tmpMaskedDenoisedPixels );
    %Calculate Average
    if Y(i) == 1
      fertileAVG    = [fertileAVG; tmpMean];
      fertileSTD    = [fertileSTD; tmpSTD];
    else
      nonfertileAVG = [nonfertileAVG; tmpMean];
      nonfertileSTD = [nonfertileSTD; tmpSTD];
    end
    %Save Processed Position
    yPosition       = [yPosition i];  
  else
    printf( ["[FAIL]: " originFile " does not exists" ]);
  end
  i
  fflush(stdout);
end

allEggs.yPosition       = yPosition;
allEggs.AVG.fertile     = fertileAVG;
allEggs.AVG.nonfertile  = nonfertileAVG;
allEggs.STD.fertile     = fertileSTD;
allEggs.STD.nonfertile  = nonfertileSTD;
destineFertile          = [ destinePath 'allDenoisedEggs.mat' ];
save(destineFertile,'allEggs');
