%Load Cube
path      = '/media/jairo/My Passport/HSI/';
fileName  = '000481.mat';
load([path fileName]);
[X Y L] = size(EGG);

%Normalize
%maxVal    = max(max(max(EGG)));
%normEgg   = EGG / maxVal;

if 1
  %display
  tmpImg = EGG(:,:,33);
  %figure, imshow(tmpImg);
  plot(EGG(1,1,:));
  hold on;
  for x=80:5:80+5
    for y=80:5:80+5
      plot(EGG(x,y,:));
    end
  end
end






%FFT
%a = tmpImg;
%plotFFT;