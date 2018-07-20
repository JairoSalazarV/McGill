clear all; close all;
clc;

pkg load image;
load('./Info/wavelength.mat');

%--------------------------------------------------
%Initialize
%--------------------------------------------------
DATAPath            = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100/';
destinePath         = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100Mask/';
[lstFiles]          = dir(DATAPath);
lstFiles            = lstFiles(3:max(size(lstFiles)));
numFiles            = max(size(lstFiles));

for i=70:numFiles
  load( [DATAPath lstFiles(i).name] );
  destineFilename   = [ destinePath lstFiles(i).name ];
  [maskR maskC]     = size( tmpStr.mask );
  [R C L]           = size( tmpStr.EGG );
  numMaskedPixels   = max( size( find(tmpStr.mask==1) ) );
  tmpStr.maskedEGG  = zeros( numMaskedPixels, L );
  i                 = 1;
  for r=1:maskR
    for c=1:maskC
      if tmpStr.mask(r,c) == 1
        tmpStr.maskedEGG(i++,:) = squeeze( tmpStr.EGG(r,c,:) )';
      end
    end
  end
  tmpStr.mask       = [];
  tmpStr.EGG        = [];
  save( destineFilename, 'tmpStr' );
end

printf("Finish\n");
