clear all; close all;
clc;

load( './Info/Group_fertile.mat' );

%%Initialize
pkg load image;
radioPercent  = 0.93;
DATAPath      = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResized/';
destinePath   = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCircle/';
[lstFiles]    = dir(DATAPath);
lstFiles      = lstFiles(3:max(size(lstFiles)));
numFiles      = max(size(lstFiles));
load( [DATAPath lstFiles(1).name] );
[Rows Cols L] = size( tmpStr(1).denoisedEGG );
radio         = round( min(Rows,Cols) * radioPercent * 0.5 );
centerC       = round(Cols/2);
centerR       = round(Rows/2);
f             = @(x,y,r) ( x^2 + y^2 - r^2 );

%%Draw a circle


for i=1:1:numFiles
  
  %Load EGG
  load( [DATAPath lstFiles(i).name] );
  [Rows Cols L] = size( tmpStr.denoisedEGG );
  
  %Backup Circle Properties
  tmpStr.Circle.radioPercent  = radioPercent;
  tmpStr.Circle.Cols          = Cols;
  tmpStr.Circle.Rows          = Rows;
  tmpStr.Circle.centerC       = centerC;
  tmpStr.Circle.centerR       = centerR;
  
  %Extract Pixels into Circle
  empty = 1;
  for r=1:1:Rows
    for c=1:1:Cols
      if( f(r-centerR,c-centerC,radio) <= 1 )
        if empty == 1
          tmpStr.Circle.DATA = squeeze(tmpStr.denoisedEGG(r,c,:))';
          empty = 0;
        else
          tmpStr.Circle.DATA = [tmpStr.Circle.DATA; squeeze(tmpStr.denoisedEGG(r,c,:))'];
        end
      end
    end
  end
  %tmpStr.denoisedEGG = [];
  
  %Save Backup
  destineFile = [destinePath lstFiles(i).name];
  save( destineFile, 'tmpStr' );
  
end


