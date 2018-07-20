clear all; close all;
clc;

load( './Info/Group_fertile.mat' );

%%Initialize
pkg load image;
reduction     = 0.27;
DATAPath      = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100Denoised/';
destinePath   = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResized/';
[lstFiles]    = dir(DATAPath);
lstFiles      = lstFiles(3:max(size(lstFiles)));
numFiles      = max(size(lstFiles));
load( [DATAPath lstFiles(1).name] );
[Rows Cols L] = size( tmpStr.denoisedEGG );
newRows       = floor( reduction * Rows );
newCols       = floor( reduction * Cols );

%%For Each Cube
for i=1:numFiles
 
  %Prepare Cube Data
  originFile  = [ DATAPath    lstFiles(i).name ];
  destineFile = [ destinePath lstFiles(i).name ];
  newCube     = zeros( newRows, newCols, L );
  load( originFile );
  
  %%For Each Band
  for l=1:L
    newCube(:,:,l) = imresize( tmpStr.denoisedEGG(:,:,l), [newRows newCols]);
  end
  tmpStr.mask         = [];
  tmpStr.denoisedEGG  = newCube;
  
  %%Save Cube
  save( destineFile, "tmpStr" );
  
end

printf("Finish\n");

