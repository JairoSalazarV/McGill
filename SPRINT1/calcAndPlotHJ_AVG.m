clear all; 
close all;
clc;

originDir       = '/media/jairo/My Passport/EGGFertility/HJDESCRIPTOR/ALL/';
destineDir      = '/media/jairo/My Passport/EGGFertility/HJDESCRIPTOR/miscelaneous/';
destineImgDir   = '/media/jairo/My Passport/EGGFertility/HJDESCRIPTOR/allColorMaps/';

load( './Info/Group_fertile.mat' );
N               = size(Y,1);
% strHJEgg.(fertile,rotated,name,hist38,heatMap)
lstFertileHJ    = [];
lstInfertileHJ  = [];
for tmpPos=1:N

  %%INITIALIZE
  originalEgg             = [sprintf('%06d', FGName( tmpPos ) )];
  originalFilename        = [originDir originalEgg  '.mat.mat'];
  destineFilename         = [destineDir 'allHJAVG.mat'];
  
  if exist(originalFilename)
    %%LOAD HJ
    load(originalFilename);
    if strHJEgg.fertile == 1
      destineImgFilename  = [destineImgDir 'Fertile_' originalEgg '.jpg'];
      lstFertileHJ        = [lstFertileHJ; strHJEgg.hist38];
    else
      destineImgFilename  = [destineImgDir 'Infertile_' originalEgg '.jpg'];
      lstInfertileHJ      = [lstInfertileHJ; strHJEgg.hist38];
    end

    %%SAVE IMG
    if 1
      imwrite(strHJEgg.heatMap, destineImgFilename, "jpg");
    end
    
    %%REPORT
    tmpPercAdv = (tmpPos / N) * 100;
    printf("%d of %d -> %f %% \n",tmpPos,N,tmpPercAdv);
    fflush(stdout);
  end

end

%%CALC AVG
tmpMean                         = mean(lstFertileHJ);
tmpStd                          = std(lstFertileHJ);
tmpMode                         = mode(lstFertileHJ);
tmpMode                         = mode(lstFertileHJ);

%%SAVE AVERAGE
strAllHJAVG.avgFertile.mean     = mean(lstFertileHJ);
strAllHJAVG.avgFertile.std      = std(lstFertileHJ);
strAllHJAVG.avgFertile.mode     = mode(lstFertileHJ);
strAllHJAVG.avgFertile.median   = median(lstFertileHJ);

strAllHJAVG.avgInfertile.mean   = mean(lstInfertileHJ);
strAllHJAVG.avgInfertile.std    = std(lstInfertileHJ);
strAllHJAVG.avgInfertile.mode   = mode(lstInfertileHJ);
strAllHJAVG.avgInfertile.median = median(lstInfertileHJ);

strAllHJAVG.lstFertile          = lstFertileHJ;
strAllHJAVG.lstInfertile        = lstInfertileHJ;
save(destineFilename, 'strAllHJAVG');
