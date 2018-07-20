clear all; close all;
clc;

load( './Info/Group_fertile.mat' );

%%Initialize
pkg load image;
originPath    = '/media/jairo/My Passport/EGGFertility/allSlidesAVG/';
destinePath   = '/media/jairo/My Passport/EGGFertility/miscelaneus/';
numFiles      = max(size(FGName));
newFilename   = [sprintf('%06d', FGName(1) ) '.mat'];
load( [originPath newFilename ] );
numSlides     = slide.numSlides;

%Initialize container of slidesAVG
for s=1:numSlides
  slidesFertile{s}.mean       = [];
  slidesFertile{s}.std        = [];
  slidesFertile{s}.median     = [];
  slidesNonFertile{s}.mean    = [];
  slidesNonFertile{s}.std     = [];
  slidesNonFertile{s}.median  = [];
end  

%Separate Fertile and Nonfertile
for i=1:1:numFiles
  newFilename     = [sprintf('%06d', FGName(i) ) '.mat'];
  originFilename  = [originPath newFilename];
  if exist( originFilename )
    load(originFilename);
    for s=1:numSlides
      if slide.fertile == 1
        slidesFertile{s}.mean       = [slidesFertile{s}.mean;   slide.mean(s,:)];
        slidesFertile{s}.std        = [slidesFertile{s}.std;    slide.std(s,:)];
        slidesFertile{s}.median     = [slidesFertile{s}.median; slide.median(s,:)];
      else
        slidesNonFertile{s}.mean    = [slidesNonFertile{s}.mean;   slide.mean(s,:)];
        slidesNonFertile{s}.std     = [slidesNonFertile{s}.std;    slide.std(s,:)];
        slidesNonFertile{s}.median  = [slidesNonFertile{s}.median; slide.median(s,:)];
      end
    end
  end
  
  %Update Advance
  status = [num2str((i/numFiles)*100) '% --> ' num2str(i) ' of ' num2str(numFiles)]
  fflush(stdout);
    
end

%Calculate All Eggs Average
for s=1:numSlides
  slideAllFertileEggs{s}.mean       = mean(slidesFertile{s}.mean);
  slideAllFertileEggs{s}.std        = mean(slidesFertile{s}.std);
  slideAllFertileEggs{s}.median     = mean(slidesFertile{s}.median);
  
  slideAllNonFertileEggs{s}.mean    = mean(slidesNonFertile{s}.mean);
  slideAllNonFertileEggs{s}.std     = mean(slidesNonFertile{s}.std);
  slideAllNonFertileEggs{s}.median  = mean(slidesNonFertile{s}.median);
end

%Prepare file to save
allSlidesAVG.numSlides                    = numSlides;
allSlidesAVG.fertile                      = slideAllFertileEggs;
allSlidesAVG.nonfertile                   = slideAllNonFertileEggs;
allSlidesAVG.fertileEggsAVGSignatures     = slidesFertile;
allSlidesAVG.nonfertileEggsAVGSignatures  = slidesNonFertile;

%Save AVG
destineFilename                = [destinePath 'allSlidesAVG.mat'];
save(destineFilename, 'allSlidesAVG');
