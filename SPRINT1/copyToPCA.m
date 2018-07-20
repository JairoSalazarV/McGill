clear all; close all;
clc;

pkg load image;
pkg load statistics;

%--------------------------------------------------
%Initialize
%--------------------------------------------------
DATAPath      = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCircle/';
destinePath   = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCirclePCA/';
[lstFiles]    = dir(DATAPath);
lstFiles      = lstFiles(3:max(size(lstFiles)));
numFiles      = max(size(lstFiles));


%--------------------------------------------------
%Find
%--------------------------------------------------
for i=1:numFiles
  
  %Obtain Principal Components
  load( [DATAPath lstFiles(i).name] );
  [V LAMBDA]              = eig( cov( tmpStr.Circle.DATA ) );
  [~,pcaCube]             = pcares(tmpStr.Circle.DATA,min(size(tmpStr.Circle.DATA)));
  [eigenvectors pcaCube]  = princomp( tmpStr.Circle.DATA );
  eigenvalues             = sort( max(LAMBDA), "descend" );
  tmpStr.Circle           = [];
  tmpStr.PCA.L            = max(size(eigenvalues));
  tmpStr.PCA.eigenvalues  = eigenvalues;
  tmpStr.PCA.eigenvectors = eigenvectors;
  tmpStr.PCA.DATA         = pcaCube;
  
  %Save Backup
  destineFile = [destinePath lstFiles(i).name];
  save( destineFile, 'tmpStr' );
  
end

if 0
  plot(tmpStr.PCA.DATA);
  title( [ 'Fertile: ' num2str(tmpStr.fertile)] );
end


