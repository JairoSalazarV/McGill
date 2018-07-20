clear all; close all;
clc;

pkg load image;
load('./Info/wavelength.mat');

%--------------------------------------------------
%Initialize
%--------------------------------------------------
DATAPath            = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResized/';
destinePath         = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100DenoisedResizedDenoised/';
[lstFiles]          = dir(DATAPath);
lstFiles            = lstFiles(3:max(size(lstFiles)));
numFiles            = max(size(lstFiles));


load( [DATAPath lstFiles(25).name] );
[R C L]             = size( tmpStr.denoisedEGG );
cubeMatrix          = cube2Matrix( tmpStr.denoisedEGG );
noiseMatrix         = noiseEstimationHysime( cubeMatrix );
denoisedMatrix      = cubeMatrix .- noiseMatrix;
denoisedMatrix(find( denoisedMatrix < 0 )) = 0;
cubeMatrix(find( cubeMatrix < 0 )) = 0;
denoisedCube        = matrix2Cube( denoisedMatrix, R, C, L );

if 0
  jump = 10;
  subplot(1,2,1);
  plot( Wavelength, cubeMatrix(1:jump:(R*C),:) );
  title('Thumb Original','fontsize',20);
  xlabel("Wavelength (nm)",'fontsize',17); ylabel("Transmitance",'fontsize',17);
  subplot(1,2,2);
  plot( Wavelength, denoisedMatrix(1:jump:(R*C),:) );
  title('Thumb Denoised','fontsize',20);
  xlabel("Wavelength (nm)",'fontsize',17); ylabel("Transmitance",'fontsize',17);
end

if 0
  figure, imshow( tmpStr.denoisedEGG(:,:,38) );
  title('Original: 1076nm','fontsize',20);
  figure, imshow( denoisedCube(:,:,38) );
  title('Denoised: 1076nm','fontsize',20);
end

if 1
  subplot(1,2,1);
  imshow( tmpStr.denoisedEGG(:,:,33) );
  title('Original');
  subplot(1,2,2);
  imshow( tmpStr.denoisedEGG(:,:,33) );
  title('Denoised');
end



