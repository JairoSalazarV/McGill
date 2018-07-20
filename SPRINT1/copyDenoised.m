clear all; close all;
clc;

pkg load image;
load('./Info/wavelength.mat');

%--------------------------------------------------
%Initialize
%--------------------------------------------------
DATAPath            = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100/';
destinePath         = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100Denoised/';
[lstFiles]          = dir(DATAPath);
lstFiles            = lstFiles(3:max(size(lstFiles)));
numFiles            = max(size(lstFiles));

for i=1:numFiles
  load( [DATAPath lstFiles(i).name] );
  [R C L]             = size( tmpStr.EGG );
  cubeMatrix          = cube2Matrix( tmpStr.EGG );
  noiseMatrix         = noiseEstimationHysime( cubeMatrix );
  denoisedMatrix      = cubeMatrix .- noiseMatrix;
  denoisedMatrix(find( denoisedMatrix < 0 )) = 0;
  tmpStr.EGG          = [];
  tmpStr.denoisedEGG  = matrix2Cube( denoisedMatrix, R, C, L );
  destineFilename     = [ destinePath lstFiles(i).name];
  save( destineFilename, 'tmpStr' );
end
printf("Finish\n");