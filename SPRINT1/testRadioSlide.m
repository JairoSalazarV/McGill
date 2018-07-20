clear all; close all;
clc;

load( './Info/Group_fertile.mat' );
load( './Info/wavelength.mat' );

%%Initialize
pkg load image;
DATAPath        = '/media/jairo/My Passport/EGGFertility/radioSlides/';
destinePath     = '/media/jairo/My Passport/EGGFertility/radioSlides/';
numFiles        = max(size(FGName));
numFile         = 3;
newFilename     = [sprintf('%06d', FGName(numFile) ) '.mat'];
originFilename  = [destinePath newFilename];

load(originFilename);
numSlides       = slide.numSlides;


i=1;
hold on;
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), 'r' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), 'b' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), 'k' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), 'm' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-*r' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-*b' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-*k' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-*m' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-sr' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-sb' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-sk' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-sm' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-or' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-ob' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-ok' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-om' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-^r' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-^b' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-^k' );
tmpMean = plot( Wavelength, mean( slide.lstSlidePixels{i++}), '-^m' );


if slide.fertile == 1
  title("FERTILE");
else
  title("NONFERTILE");
end



