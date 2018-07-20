clear all; close all;
clc;

load( './Info/Group_fertile.mat' );

%%Initialize
pkg load image;
numEgg        = 50;
radioPercent  = 0.93;
DATAPath      = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResized/';
destinePath   = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCicle/';
[lstFiles]    = dir(DATAPath);
lstFiles      = lstFiles(3:max(size(lstFiles)));
numFiles      = max(size(lstFiles));
load( [DATAPath lstFiles(numEgg).name] );
[Rows Cols L] = size( tmpStr(1).denoisedEGG );
radio         = round( min(Rows,Cols) * radioPercent * 0.5 );
centerC       = round(Cols/2);
centerR       = round(Rows/2);
f             = @(x,y,r) ( x^2 + y^2 - r^2 );

%%Draw a circle
tmpImg = tmpStr(1).denoisedEGG(:,:,33);
subplot(1,2,1);
imshow(tmpImg);
for r=1:1:Rows
  for c=1:1:Cols
    if( f(r-centerR,c-centerC,radio) <= 1 )
      tmpImg(r,c) = 1;
    end
  end
end

subplot(1,2,2);
imshow(tmpImg);


  