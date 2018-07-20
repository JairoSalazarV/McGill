clear all; close all;
clc;

load( './Info/Group_fertile.mat' );

%%Initialize
pkg load image;
numSlides     = 20;
DATAPath      = '/media/jairo/My Passport/HSI/';
destinePath   = '/media/jairo/My Passport/EGGFertility/radioSlides/';
f             = @(x,y,r) ( x^2 + y^2 - r^2 );
numFiles      = max(size(FGName));



%Load Cube if Exists
%if exist( originFile )

%numFiles = 3;
for i=16847:1:numFiles
  %Update Percentage
  status = [num2str(round((i/numFiles)*100)) '% --> ' num2str(i) ' of ' num2str(numFiles)]
  fflush(stdout);
  
  %Initialize Cube
  fileChoosed     = num2str( FGName( i ) );
  newFilename     = [sprintf('%06d', FGName(i) ) '.mat'];
  originFile      = [ DATAPath newFilename ];
  destineFile     = [ destinePath newFilename ];
  len             = max(size(fileChoosed));
  
  %Load Cube if Exists
  if exist( originFile )
    
    %Load EGG
    load( originFile );
    slide.numSlides = numSlides;
    slide.fertile   = Y(i);
    slide.rotated   = fileChoosed(len);
    slide.name      = newFilename;
    [Rows Cols L]   = size( EGG );
    centerR         = ceil(Rows*0.5);
    centerC         = ceil(Cols*0.5);
    maxDiameter     = min( [ Rows, Cols ] );
    radio           = maxDiameter/2/numSlides;
        
    %For Each Slide
    for s=1:1:numSlides
      %Initialize Slide Container
      lstSlidePixels{s} = [];
      %Copy Slide Members  
      for r=1:1:Rows
        for c=1:1:Cols
          if s==1
            if( f(r-centerR,c-centerC,radio) < 0 )
              lstSlidePixels{s} = [lstSlidePixels{s}; squeeze(EGG(r,c,:))'];
            end
          else
            if(f(r-centerR,c-centerC,(radio*s)) < 0) && (f(r-centerR,c-centerC,(radio*(s-1))) >= 1)
              lstSlidePixels{s} = [lstSlidePixels{s}; squeeze(EGG(r,c,:))'];            
            end
          end
        end
      end      
    end
    
    %Save Slide Backup
    slide.lstSlidePixels  = lstSlidePixels;
    save( destineFile, 'slide' );
    
  else
    printf( ["[FAIL]: " newFilctame " does not exists" ]);
    fflush(stdout);
  end

end






















