clear all; close all;
clc;

%Initialize
pkg load image;
numSlides           = 15;
f                   = @(x,y,r) ( x^2 + y^2 - r^2 );
DATAPath            = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/200/Original/';
destinePath         = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/200/variablesBackup/';

%Initialize Mask
slideMask           = zeros( minLen, minLen, numSlides );
middleR             = round( minLen * 0.5 );
middleC             = round( minLen * 0.5 );

%Create Mask
for i=1:1:1%numSlides
  
  tmpMask           = zeros(minLen,minLen);
  minLen            = 112;
  radio             = round( (minLen/numSlides)*0.5 );
  
  
  for r=1:1:minLen
    for c=1:1:minLen
      if i==1
        if( f(r-middleR,c-middleC,radio) < 1 )
          tmpMask(r,c) = 1.0;
        end
      else
        if(f(r-middleR,c-middleC,(radio*i)) < 1) && (f(r-middleR,c-middleC,(radio*(i-1))) >= 1)
          tmpMask(r,c) = 1.0;
        end
      end
    end
  end
  slideMask(:,:,i) = tmpMask;
end

%Save Mask
outputFilename = 'slide11Masks.mat';
save( [destinePath outputFilename], 'slideMask');

%Verify Mask
if 1
  load([destinePath outputFilename]);
  for i=1:1:numSlides
    figure, imshow( slideMask(:,:,i) );
  end
end



