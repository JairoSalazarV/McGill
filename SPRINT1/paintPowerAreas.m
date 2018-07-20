clear all; 
close all;
clc;

originDir         = '/media/jairo/My Passport/HSI/';

load( './Info/Group_fertile.mat' );

tmpPos            = 93;%1-26: Fertile | 27 81 89 93 203 259 297 333: Infertile
originalEgg       = [sprintf('%06d', FGName( tmpPos ) ) '.mat'];
rotatedEgg        = [sprintf('%06d', FGName( tmpPos+1 ) ) '.mat'];
originalFilename  = [originDir originalEgg];
rotatedFilename   = [originDir rotatedEgg];

if !exist( originalFilename ) && !exist( rotatedFilename )
  printf("Choose another Egg\n");
  return;
end

load(originalFilename);
originalEGG     = EGG;
originalMask    = mask;
load(rotatedFilename);
rotatedEGG      = EGG;
rotatedMask     = mask;

[oR oC oL]      = size(originalEGG);
[rR rC rL]      = size(rotatedEGG);

originalRGBImg  = zeros(oR,oC,3);
rotatedRGBImg   = zeros(rR,rC,3);

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

%%ROTED
rotated38      = [];
for r=1:rR
  for c=1:rC
    if rotatedMask(r,c) == 1
      tmp38     = rotatedEGG(r,c,38);
      rotated38 = [rotated38 tmp38];
      for m=1:M-1
        if tmp38 > limits(m) && tmp38 <= limits(m+1)
          rotatedRGBImg(r,c,1)  = 1-limits(m);
          rotatedRGBImg(r,c,2)  = limits(m);
          rotatedRGBImg(r,c,3)  = 0;
          break;
        end
      end
    end  
  end
end

if Y(tmpPos) == 1
  figure('Name','FERTILE','NumberTitle','off');
else
  figure('Name','INfertile','NumberTitle','off');
end

subplot (2, 2, 1);
imshow(originalRGBImg);
title("First Cube",'fontsize',20);

subplot (2, 2, 2);
imshow(rotatedRGBImg);
title("Rotated",'fontsize',20);

subplot (2, 2, 3);
originalH38         = hist(original38,M);
%originalH38(1:20)   = 0;
limitsX             = limits*100;
bar(limitsX,originalH38);
axis([0 max(limitsX) 0 1300]);

subplot (2, 2, 4);
rotatedH38      = hist(rotated38,M);
%rotatedH38(1:20)   = 0;
bar(limitsX,rotatedH38);
axis([0 max(limitsX) 0 1300]);

