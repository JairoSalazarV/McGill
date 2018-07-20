clear all; 
close all;
clc;

originDir   = '/media/jairo/My Passport/HSI/';
destineDir  = '/media/jairo/My Passport/EGGFertility/HJDESCRIPTOR/ALL/';
load( './Info/Group_fertile.mat' );
N           = size(Y,1);


%Infertile: 1-26 | Fertile: 27 81 89 93 203 259 297 333: Infertile
for tmpPos=27:N
  
  originalEgg       = [sprintf('%06d', FGName( tmpPos ) ) '.mat'];
  originalFilename  = [originDir originalEgg];

  if exist( originalFilename )
    %%ROTATION
    tmpID           = num2str( FGName( tmpPos ) );
    rotated         = tmpID(size(tmpID,2));

    %%LOAD
    load(originalFilename);
    originalEGG     = EGG;
    originalMask    = mask;

    %%INITIALIZE
    [oR oC oL]      = size(originalEGG);

    originalRGBImg  = zeros(oR,oC,3);
    
    limits          = 1:1:90;
    limits          = limits / 100;

    M               = size(limits,2);

    %%ORIGINAL
    original38      = [];
    for r=1:oR
      for c=1:oC
        if originalMask(r,c) == 1
          tmp38       = originalEGG(r,c,38);
          original38  = [original38 tmp38];
          for m=1:M-1
            if tmp38 > limits(m) && tmp38 <= limits(m+1)
              originalRGBImg(r,c,1)  = 1-limits(m);
              originalRGBImg(r,c,2)  = limits(m);
              originalRGBImg(r,c,3)  = 0;
              break;
            end
          end
        end  
      end
    end
    
    %%HISTOGRAM
    originalH38       = hist(original38,M);
    
    %%PREPARE TO SAVE
    strHJEgg.fertile  = Y(tmpPos);
    strHJEgg.rotated  = rotated;
    strHJEgg.name     = originalEgg;
    strHJEgg.hist38   = originalH38;
    strHJEgg.heatMap  = originalRGBImg;
    
    %%DISPLAY
    if 0
      %subplot(1,2,1);
      figure, imshow(EGG(:,:,38));
      %subplot(1,2,2);
      figure, imshow(originalRGBImg);
    end
    
    
    %%SAVE
    outputFilename    = [destineDir strHJEgg.name '.mat'];
    save(outputFilename,'strHJEgg');

    %%REPORT
    tmpPercAdv = (tmpPos / N) * 100;
    printf("%d of %d -> %f %% \n",tmpPos,N,tmpPercAdv);
    fflush(stdout);
    
    %{
    if 1
      %%Figure Window
      if strHJEgg.fertile == 1
        figure('Name','FERTILE','NumberTitle','off');
      else
        figure('Name','INfertile','NumberTitle','off');
      end

      %%Display Color Map
      subplot (2, 1, 1);
      imshow(strHJEgg.heatMap);
      title("Fertile Map",'fontsize',20);

      %%Plot Histogram
      subplot (2, 1, 2);
      limitsX             = limits*100;
      bar(limitsX,strHJEgg.hist38);
      axis([0 max(limitsX) 0 1300]);

    end
    %}
  end 
end
