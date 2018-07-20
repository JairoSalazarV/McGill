clear all; close all;
clc;

%--------------------------------------------------
%Initialize
%--------------------------------------------------
numCube       = 5;
pkg load image;
DATAPath      = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCircle/';
destinePath   = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCirclePCA/';
[lstFiles]    = dir(DATAPath);
lstFiles      = lstFiles(3:max(size(lstFiles)));
numFiles      = max(size(lstFiles));


%--------------------------------------------------
%Find
%--------------------------------------------------
lstNonFertile = [];
for i=1:numFiles
  load( [DATAPath lstFiles(i).name] );
  if tmpStr.fertile == 0
    lstNonFertile = [lstNonFertile i];
  end
end

lstNonFertile
