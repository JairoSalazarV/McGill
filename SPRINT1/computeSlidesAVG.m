clear all; close all;
clc;

pkg load image;
load('./Info/wavelength.mat');
load('/home/jairo/Documentos/OCTAVE/McGILL/DATA/200/variablesBackup/slide11Masks.mat');

%--------------------------------------------------
%Initialize
%--------------------------------------------------
DATAPath            = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/200/radioSlides/';
destinePath         = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/200/variablesBackup/';
[lstFiles]          = dir(DATAPath);
lstFiles            = lstFiles(3:max(size(lstFiles)));
numFiles            = max(size(lstFiles));
load( [DATAPath lstFiles(1).name] );
numSlides           = max(size(slide.lstSlidePixels));

%===============================================================
% Initialize
%===============================================================
for s=1:numSlides
  fertileMean{s}      = [];
  fertileStd{s}       = [];
  nonfertileMean{s}   = [];
  nonfertileStd{s}    = [];
end


for i=1:1:numFiles
  %Load Data
  i
  fflush(stdout);
  load( [DATAPath lstFiles(i).name] );
  
  %Calc AVG
  for s=1:numSlides
    tmpSlideMean          = mean( slide.lstSlidePixels{s} );
    tmpSlideStd           = std( slide.lstSlidePixels{s} );
    if slide.fertile == 1
      fertileMean{s}      = [fertileMean{s}; tmpSlideMean];
      fertileStd{s}       = [fertileStd{s};  tmpSlideStd];
    else
      nonfertileMean{s}   = [nonfertileMean{s}; tmpSlideMean];
      nonfertileStd{s}    = [nonfertileStd{s};  tmpSlideStd];
    end
  end
  
  %Save Backup
  slide200AVG.fertileMean     = fertileMean;
  slide200AVG.fertileStd      = fertileStd;
  slide200AVG.nonfertileMean  = nonfertileMean;
  slide200AVG.nonfertileStd   = nonfertileStd;
  destineFilename             = [ destinePath 'slide200AVG.mat' ];
  save( destineFilename, 'slide200AVG' );
  
  
  
  %===============================================================
  % Plot Radio Mean
  %===============================================================
  if 0
    fertile         = slide.fertile
    tmpSlideMean    = [];
    tmpSlideStd     = [];
    for s=1:numSlides
      tmpSlideMean  = [tmpSlideMean; mean( slide.lstSlidePixels{s} ) ];
      tmpSlideStd   = [tmpSlideStd; std( slide.lstSlidePixels{s} ) ];
    end
    
    j=1;
    plot(Wavelength,tmpSlideMean(j++,:),"r");
    hold on;
    plot(Wavelength,tmpSlideMean(j++,:),"b");
    plot(Wavelength,tmpSlideMean(j++,:),"k");
    plot(Wavelength,tmpSlideMean(j++,:),"m");
    plot(Wavelength,tmpSlideMean(j++,:),"-sr");
    plot(Wavelength,tmpSlideMean(j++,:),"-sb");
    plot(Wavelength,tmpSlideMean(j++,:),"-sk");
    plot(Wavelength,tmpSlideMean(j++,:),"-sm");
    plot(Wavelength,tmpSlideMean(j++,:),"--sr");
    plot(Wavelength,tmpSlideMean(j++,:),"--sb");
    %legend("1","2","3","4","5","6","7","8","9","10");
    
    if slide.fertile == 1
      title("Fertile");
    else
      title("Nonfertile");
    end
    
    xlabel('Wavelength','fontsize',20);
    ylabel('Absorbance','fontsize',20);

  end
  
  
  
end
