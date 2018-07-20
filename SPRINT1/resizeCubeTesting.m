clear all; close all;
clc;

%%Initialize
pkg load image;
maxW        = 33;

%%Load data
DATAPath    = '/home/jairo/Documentos/OCTAVE/McGILL/DATA/SUBSET/100Denoised/';
filename    = '003961.mat';
load([DATAPath filename]);

%%Prepare data
tmpOrigImg  = tmpStr.denoisedEGG(:,:,33);
tmpOrigMask = tmpOrigImg .* tmpStr.mask;
[W H]       = size(tmpOrigImg);

%%Resize image
imgSized    = imresize( tmpOrigImg, (maxW/W));

i=1;
subplot(2, 2, i++);
imagesc(tmpOrigImg);
colormap(gray);
title("Original");

subplot(2, 2, i++);
imagesc(tmpOrigImg);
title("Original Mask");

subplot(2, 2, i++);
imagesc(tmpOrigImg);
title("Resized");
