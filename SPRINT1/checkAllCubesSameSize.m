clear all; close all;
clc;

pkg load image;
load('./Info/wavelength.mat');

%--------------------------------------------------
%Initialize
%--------------------------------------------------
DATAPath            = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/200/Original/';
destinePath         = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/200/';
[lstFiles]          = dir(DATAPath);
lstFiles            = lstFiles(3:max(size(lstFiles)));
numFiles            = max(size(lstFiles));
load([ DATAPath lstFiles(1).name ]);
[R C L]             = size(tmpStr.EGG);


for i=2:1:numFiles
  load([ DATAPath lstFiles(i).name ]);
  [tmpR tmpC tmpL]  = size(tmpStr.EGG);
  if R!=tmpR || C!=tmpC || L!=tmpL
    i
    printf('Differente...');
    return;
  end
end
