clear all; close all;
clc;

load( '/home/jairo/Documentos/OCTAVE/McGILL/Info/Group_fertile.mat' );

%%Initialize
pkg load image;
originPath    = '/media/jairo/My Passport/EGGFertility/allSlidesAVG/';
destinePath   = '/media/jairo/My Passport/EGGFertility/miscelaneus/ReducedDatasetTest2/';
numFiles      = max(size(FGName));
newFilename   = [sprintf('%06d', FGName(1) ) '.mat'];
load( [originPath newFilename ] );
numSlides     = slide.numSlides;


for k=1:10
  clc;
  %Initialize container of slidesAVG
  for s=1:numSlides
    slidesFertile{s}.mean       = [];
    slidesFertile{s}.std        = [];
    slidesFertile{s}.median     = [];
    slidesNonFertile{s}.mean    = [];
    slidesNonFertile{s}.std     = [];
    slidesNonFertile{s}.median  = [];
  end

  %Get two Balanced Subset
  numElements     = 200;
  lstFertile      = find( Y==1 );
  lstNonFertile   = find( Y==0 );
  mFertile        = max(size(lstFertile));
  mNonFertile     = max(size(lstNonFertile));
  rFertile        = randi([1 mFertile],1,numElements);
  rNonFertile     = randi([1 mNonFertile],1,numElements);
  subset          = [lstFertile(rFertile)' lstNonFertile(rNonFertile)'];
  numFiles        = max( size(subset) );
  if sum(Y(subset)) > numElements
    printf("ERROR Balancing Subsets\n");
    fflush(stdout);
    return;
  end


  %Separate Fertile and Nonfertile
  for i=1:1:numFiles
    newFilename     = [sprintf('%06d', FGName(subset(i)) ) '.mat'];
    originFilename  = [originPath newFilename];
    if exist( originFilename )
      load(originFilename);
      for s=1:numSlides  
        if slide.fertile == 1
          slidesFertile{s}.mean       = [slidesFertile{s}.mean;   [slide.mean(s,37:39) 1] ];
          slidesFertile{s}.std        = [slidesFertile{s}.std;    [slide.std(s,37:39) 1] ];
          slidesFertile{s}.median     = [slidesFertile{s}.median; [slide.median(s,37:39) 1] ];
        else
          slidesNonFertile{s}.mean    = [slidesNonFertile{s}.mean;   [slide.mean(s,37:39) 0] ];
          slidesNonFertile{s}.std     = [slidesNonFertile{s}.std;    [slide.std(s,37:39) 0] ];
          slidesNonFertile{s}.median  = [slidesNonFertile{s}.median; [slide.median(s,37:39) 0] ];
        end
      end
    end
    
    %Update Advance
    status = [num2str((i/numFiles)*100) '% --> ' num2str(i) ' of ' num2str(numFiles)]
    fflush(stdout);
      
  end

  %Prepare file to save
  allSlidesAVG.numSlides                    = numSlides;
  allSlidesAVG.fertileEggsAVGSignatures     = slidesFertile;
  allSlidesAVG.nonfertileEggsAVGSignatures  = slidesNonFertile;

  %Save AVG
  destineFilename                           = [destinePath 'balancedAllSlidesAVG' num2str(k) '.mat'];
  save(destineFilename, 'allSlidesAVG');
  
end
