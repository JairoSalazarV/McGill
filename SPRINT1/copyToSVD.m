clear all; close all;
clc;

%--------------------------------------------------
%Initialize
%--------------------------------------------------
pkg load image;
DATAPath      = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCircle/';
destinePath   = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCircleSVD/';
[lstFiles]    = dir(DATAPath);
lstFiles      = lstFiles(3:max(size(lstFiles)));
numFiles      = max(size(lstFiles));


%--------------------------------------------------
%Find
%--------------------------------------------------
for i=1:numFiles
  
  %Obtain Singular Value Decomposition
  load( [DATAPath lstFiles(i).name] );
  [U S V]       = svd( tmpStr.Circle.DATA );
  eigenvalues   = max(S);
  tmpStr.Circle = [];
  
  %Save Backup
  destineFile       = [destinePath lstFiles(i).name];
  tmpStr.SVD.values = eigenvalues;
  tmpStr.SVD.DATA   = V';
  save( destineFile, 'tmpStr' );
  
end

if 0
  plot(tmpStr.SVD.DATA);
  title( [ 'Fertile: ' num2str(tmpStr.fertile)] );
end


