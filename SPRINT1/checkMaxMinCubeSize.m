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
[minR minC minL]    = size(tmpStr.EGG);


for i=2:1:numFiles
  load([ DATAPath lstFiles(i).name ]);
  [tmpR tmpC tmpL]  = size(tmpStr.EGG);
  if minR>tmpR
    minR = tmpR;
  end
  if minC>tmpC
    minC = tmpC;
  end
  if minL>tmpL
    minL = tmpL;
  end
  i
  fflush(stdout);
end
[minR minC minL]