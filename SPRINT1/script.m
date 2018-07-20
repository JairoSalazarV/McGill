close all;
if 0
  clear all; close all;
  clc;
  %load( '/media/jairo/My Passport/EGGFertility/miscelaneus/Balanced/balancedAllSlidesAVG12.mat' );
  
  %allSlidesAVG. : numSlides | fertile | nonfertile | fertileEggsAVGSignatures | nonfertileEggsAVGSignatures
  load( '/media/jairo/My Passport/EGGFertility/miscelaneus/allSlidesAVG.mat' );
  load( './Info/wavelength.mat' );
  
  S = size(allSlidesAVG.nonfertile,2);
 
end

numLayers = 60;
last      = 1;
for s=1:20
  tic
  plot([last:last+numLayers-1],allSlidesAVG.fertileEggsAVGSignatures{s}.mean(1:5:end,1:numLayers)','g');
  hold on;
  plot([last:last+numLayers-1],allSlidesAVG.nonfertileEggsAVGSignatures{s}.mean(1:5:end,1:numLayers)','r');
  
  plot([last:last+numLayers-1],allSlidesAVG.fertile{s}.mean(1,1:numLayers)','b');
  plot([last:last+numLayers-1],allSlidesAVG.nonfertile{s}.mean(1,1:numLayers)','k');
  
  
  last = last + numLayers;
  toc
end
title("Slide 1 to 20 AVG",'fontsize',20);


if 0
  %%Grafica Fertiles sobre Infertiles
  for s=1:5:20
    figure, plot(allSlidesAVG.fertileEggsAVGSignatures{s}.mean(1:4:end,:)','g');
    hold on;
    plot(allSlidesAVG.nonfertileEggsAVGSignatures{s}.mean(1:4:end,:)','r');
    axis([0,171,0,1]);
    title(["Slide " num2str(s)],'fontsize',20);
  end
end








if 0
  %%Grafica todos las Slides y todos los huevos para mostrar la diferencia respecto a las desviaciones estandar
  clear all; close all;
  clc;
  %load( '/media/jairo/My Passport/EGGFertility/miscelaneus/Balanced/balancedAllSlidesAVG12.mat' );
  load( '/media/jairo/My Passport/EGGFertility/miscelaneus/allSlidesAVG.mat' );
  load( './Info/wavelength.mat' );
  S =  max(size(allSlidesAVG.fertile));
  difference  = [];
  stdDiff     = [];
  for s=1:S
    normedDiff  = (allSlidesAVG.nonfertile{s}.mean(38)-allSlidesAVG.fertile{s}.mean(38));
    normedDiff  = ( normedDiff / allSlidesAVG.nonfertile{s}.mean(38) ) * 100;
    difference  = [difference normedDiff];
    
    tmpStdc     = ( allSlidesAVG.nonfertile{s}.std(38) / allSlidesAVG.nonfertile{s}.mean(38) ) * 100;
    stdDiff     = [stdDiff tmpStdc];
  end
  
  bar([1:S], stdDiff,'g');
  hold on;
  bar([1:S], difference,'k');
  
  xlabel("RADIO SLIDE FEATURE","fontsize",S);
  ylabel("PERCENTAGE %","fontsize",S);
  legend("Standar Deviation","(Nonfertile - Fertile)");
  
end



if 0
  %%BALANCEADO: Grafica todos las Slides y todos los huevos para mostrar 
  %%la diferencia respecto a las desviaciones estandar
  
  clear all; close all;
  clc;
  load( '/media/jairo/My Passport/EGGFertility/miscelaneus/balancedAllSlidesAVG1.mat' );
  load( './Info/wavelength.mat' );
  S =  max(size(allSlidesAVG.fertile));
  difference  = [];
  stdDiff     = [];
  for s=1:S
    normedDiff  = (allSlidesAVG.nonfertile{s}.mean(38)-allSlidesAVG.fertile{s}.mean(38));
    normedDiff  = ( normedDiff / allSlidesAVG.nonfertile{s}.mean(38) ) * 100;
    difference  = [difference normedDiff];
    
    tmpStdc     = ( allSlidesAVG.nonfertile{s}.std(38) / allSlidesAVG.nonfertile{s}.mean(38) ) * 100;
    stdDiff     = [stdDiff tmpStdc];
  end
  
  bar([1:S], stdDiff,'g');
  hold on;
  bar([1:S], difference,'k');
  
  xlabel("RADIO SLIDE FEATURE","fontsize",S);
  ylabel("PERCENTAGE %","fontsize",S);
  legend("Standar Deviation","(Nonfertile - Fertile)");
  
end



if 0
  %%BALANCEADO y SLIDE SELECCIONADA: Grafica todos las Slides y todos los 
  %%huevos para mostrar la diferencia respecto a las desviaciones estandar
  load( '/media/jairo/My Passport/EGGFertility/miscelaneus/balancedAllSlidesAVG1.mat' );
  load( './Info/wavelength.mat' );
  s = 1;
  
  %Fertile Vs Nonfertile
  figure, plot(allSlidesAVG.fertile{s}.mean,'g');
  hold on;
  plot(Wavelength,allSlidesAVG.fertile{s}.mean+allSlidesAVG.fertile{s}.std,'--g');
  plot(Wavelength,allSlidesAVG.fertile{s}.mean-allSlidesAVG.fertile{s}.std,'--g');
  
  plot(Wavelength,allSlidesAVG.nonfertile{s}.mean,'r');
  plot(Wavelength,allSlidesAVG.nonfertile{s}.mean+allSlidesAVG.nonfertile{s}.std,'--r');
  plot(Wavelength,allSlidesAVG.nonfertile{s}.mean-allSlidesAVG.nonfertile{s}.std,'--r');
  title(["Class " num2str(s) ", All Eggs Average"],"fontsize",20);
  xlabel("Wavelength","fontsize",18);
  ylabel("Absorbance","fontsize",18);
  
  %Plot each slide  
  if 0
    for s=1:20
      figure, plot(allSlidesAVG.fertile{s}.mean,'g');
      hold on;
      plot(allSlidesAVG.nonfertile{s}.mean,'r');
      plot(allSlidesAVG.nonfertile{s}.mean,'r');
    end
  end
end

if 0
  %Grafica los promedios de cada uno de los slides para ver la maginitud de éstas
  s=1;
  close all;
  hold on;
  plot(allSlidesAVG.fertile{s++}.mean,'r');
  plot(allSlidesAVG.fertile{s++}.mean,'g');
  plot(allSlidesAVG.fertile{s++}.mean,'b');
  plot(allSlidesAVG.fertile{s++}.mean,'k');
  plot(allSlidesAVG.fertile{s++}.mean,'m');
  plot(allSlidesAVG.fertile{s++}.mean,'c');

  plot(allSlidesAVG.fertile{s++}.mean,'-sr');
  plot(allSlidesAVG.fertile{s++}.mean,'-sg');
  plot(allSlidesAVG.fertile{s++}.mean,'-sb');
  plot(allSlidesAVG.fertile{s++}.mean,'-sk');
  plot(allSlidesAVG.fertile{s++}.mean,'-sm');
  plot(allSlidesAVG.fertile{s++}.mean,'-sc');

  plot(allSlidesAVG.fertile{s++}.mean,'-or');
  plot(allSlidesAVG.fertile{s++}.mean,'-og');
  plot(allSlidesAVG.fertile{s++}.mean,'-ob');
  plot(allSlidesAVG.fertile{s++}.mean,'-ok');


end



if 0
  
  clear all; close all;
  clc;
  load('./Info/wavelength.mat');
  load('./DATA/SUBSET/COMP/allDenoisedEggs.mat');
  allFertile          = mean(allEggs.AVG.fertile);
  allFertilePlus      = allFertile + mean(allEggs.STD.fertile);
  allFertileMinus     = allFertile - mean(allEggs.STD.fertile);
  allNonFertile       = mean(allEggs.AVG.nonfertile);
  allNonFertilePlus   = allNonFertile + mean(allEggs.STD.nonfertile);
  allNonFertileMinus  = allNonFertile - mean(allEggs.STD.nonfertile);
  
  hold on;  
  
  plot(Wavelength,allFertile,'r', "linewidth", 2);
  plot(Wavelength,allFertilePlus,'--r', "linewidth", 2);
  plot(Wavelength,allFertileMinus,'--r', "linewidth", 2);
  
  plot(Wavelength,allNonFertile,'g', "linewidth", 2);
  plot(Wavelength,allNonFertilePlus,'--g', "linewidth", 2);
  plot(Wavelength,allNonFertileMinus,'--g', "linewidth", 2);
  
  set(gca, "linewidth", 3, "fontsize", 17);
  xlabel('Wavelength (nm)','fontsize',20);
  ylabel('Absorbance','fontsize',20);
  
  
end
