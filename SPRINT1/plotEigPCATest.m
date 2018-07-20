clear all; close all;
clc;

%--------------------------------------------------
%Initialize
%--------------------------------------------------
numCube       = 1;
pkg load image;
DATAPath      = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCircle/';
destinePath   = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedCirclePCA/';
[lstFiles]    = dir(DATAPath);
lstFiles      = lstFiles(3:max(size(lstFiles)));
numFiles      = max(size(lstFiles));

%--------------------------------------------------
%PCA
%--------------------------------------------------
load( [DATAPath lstFiles(numCube).name] );
[V D]       = eig( cov( tmpStr.Circle.DATA ) );
eigenvalues = max(D);
eigenvalues = eigenvalues ./ sum(eigenvalues);
m           = max(size(eigenvalues));

%--------------------------------------------------
%Plot Eigenvalues
%--------------------------------------------------
if 0
  eigSel      = 11;
  figure, scatter(1:max(size(eigenvalues)),eigenvalues);
  title( [num2str(sum(eigenvalues(m-eigSel:m))) '%'] );
end

%--------------------------------------------------
%Plot DATA in Eigen-space
%--------------------------------------------------
if 1
  figure, plot( V' );
  title( [ 'Status: ' num2str(tmpStr.fertile)] );
end

%--------------------------------------------------
%Plot DATA
%--------------------------------------------------
if 0
  figure, plot(tmpStr.Circle.DATA');
  title( [ 'Status: ' num2str(tmpStr.fertile)] );
end

