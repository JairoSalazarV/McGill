clear all; close all;
clc;

load( './Info/Group_fertile.mat' );

%%Initialize
pkg load image;
originPath    = '/media/jairo/My Passport/EGGFertility/radioSlides/';
destinePath   = '/media/jairo/My Passport/EGGFertility/allSlidesAVG/';
numFiles      = max(size(FGName));
newFilename   = [sprintf('%06d', FGName(1) ) '.mat'];
load( [originPath newFilename ] );
numSlides     = slide.numSlides;

%numFiles = 1;
for i=1:1:numFiles%9141
  newFilename     = [sprintf('%06d', FGName(i) ) '.mat'];
  originFilename  = [originPath newFilename];
  destineFilename = [destinePath newFilename];
  if exist( originFilename )
    %tic;
    %Initialize
    load( originFilename ); 
    %Compute Mean and Std
    slide.mean            = [];
    slide.std             = [];
    slide.median          = [];
    for s=1:numSlides
      slide.mean          = [slide.mean; mean(slide.lstSlidePixels{s})];
      slide.std           = [slide.std;  std(slide.lstSlidePixels{s})];
      slide.median        = [slide.median; median(slide.lstSlidePixels{s})];
    end

    %Save AVG
    slide.lstSlidePixels  = [];
    save(destineFilename, 'slide');
    
    %Update Advance
    status = [num2str((i/numFiles)*100) '% --> ' num2str(i) ' of ' num2str(numFiles)]
    fflush(stdout);
    
    %{
    %Validate Result
    if 0
      j = 3;
      if i>j+1
        hold on;
        s = 1;
        
        newFilename     = [sprintf('%06d', FGName(j) ) '.mat']
        originFilename  = [destinePath newFilename];
        load(originFilename);        
        plot( slide.mean(s,:), 'r' );
        plot( slide.mean(s,:) + slide.std(1,:), '--r' );
        plot( slide.mean(s,:) - slide.std(1,:), '--r' );
        plot( slide.median(s,:), 'or' );
        
        newFilename     = [sprintf('%06d', FGName(j+1) ) '.mat']
        originFilename  = [destinePath newFilename];
        load(originFilename);        
        plot( slide.mean(s,:), 'g' );
        plot( slide.mean(s,:) + slide.std(1,:), '--g' );
        plot( slide.mean(s,:) - slide.std(1,:), '--g' );
        plot( slide.median(s,:), 'og' );
        return;
      end
    end
    %}
    
    %toc;
    
  end
  
  
  
end
