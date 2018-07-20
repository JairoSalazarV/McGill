%Requies a := Double 2D Matrix

i = 1;
plotRows = 2;
plotCols = 2;

%a   = double(imread('tstImg.png','png'));

axis image;

[Y,X,L] = size(a);
%a       = a(1:Y,4001:4500);
%[Y,X,L] = size(a)

subplot(plotRows, plotCols, i++);
imagesc(a);
colormap(gray);
title("Orig Subimage");


A = fft2(a);
subplot(plotRows, plotCols, i++);
imagesc(log(abs(A)));
title("FFT");

B = fftshift(A);
subplot(plotRows, plotCols, i++);
imagesc(log(abs(B)));
title("FFT, Shift");
