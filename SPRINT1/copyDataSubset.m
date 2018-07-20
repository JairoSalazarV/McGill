clear all; close all;
clc;

DATAPath    = '/media/jairo/My Passport/HSI/';
destinePath = '/media/jairo/My Passport/EGGFertility/SUBSETS/';
load('./Info/Group_fertile.mat');

%%Initialize
%[listFiles]   = dir ('/media/jairo/My Passport/HSI/')

subsetLen     = 2400;
fertileRatio  = 66.6666 / 100;
numFertile    = round( subsetLen * fertileRatio );
numNonFertile = subsetLen - numFertile;
lstFertile    = find( Y==1 );
lstNonFertile = find( Y==0 );

%%Randomly Select Subset
mFertile      = size(lstFertile);
mNonFertile   = size(lstNonFertile);
rFertile      = randi([1 max(mFertile)],1,numFertile);
rNonFertile   = randi([1 max(mNonFertile)],1,numNonFertile);

%%Copy Fertile Subset
if 0
  for i=1:1:numFertile
    
    %Validate File Choosed
    tmpPos        = lstFertile( rFertile(i) );
    if( Y(tmpPos) != 1 )
      printf( ["[ERROR]: This is NOT FERTILE! | " num2str(tmpPos) ]);
      return;
    end
    
    %Prepare Data to Save
    fileChoosed     = num2str( FGName( tmpPos ) );
    len             = max(size(fileChoosed));
    newFilctame     = [sprintf('%06d', str2num(fileChoosed) ) '.mat'];
    originFile      = [ DATAPath newFilctame ];
    destineFile     = [ destinePath newFilctame ];
    
    %Load Cube if Exists
    if exist( originFile )
      load( originFile );
      tmpStr.fertile  = Y(tmpPos);
      tmpStr.rotated  = fileChoosed(len);
      tmpStr.name     = newFilctame;
      tmpStr.mask     = mask;
      tmpStr.EGG      = EGG;
      save( destineFile, 'tmpStr' );
    else
      printf( ["[FAIL]: " newFilctame " does not exists" ]);
    end
    
    i
    fflush(stdout);
      
  end
end

%%Copy NonFertile Subset
if 1
  for i=1:1:4
    
    %Validate File Choosed
    tmpPos        = lstNonFertile( rNonFertile(i) );
    if( Y(tmpPos) != 0 )
      printf( ["[ERROR]: This is FERTILE! | " num2str(tmpPos) " i: " num2str(i) " " ]);
      return;
    end
    
    %Prepare Data to Save
    fileChoosed     = num2str( FGName( tmpPos ) );
    len             = max(size(fileChoosed));
    newFilctame     = [sprintf('%06d', str2num(fileChoosed) ) '.mat'];
    originFile      = [ DATAPath newFilctame ];
    destineFile     = [ destinePath newFilctame ];
    
    %Load Cube if Exists
    if exist( originFile )
      load( originFile );
      tmpStr.fertile  = Y(tmpPos);
      tmpStr.rotated  = fileChoosed(len);
      tmpStr.name     = newFilctame;
      tmpStr.mask     = mask;
      tmpStr.EGG      = EGG;
      save( destineFile, 'tmpStr' );
    else
      printf( ["[FAIL]: " newFilctame " does not exists" ]);
    end

    i
    fflush(stdout);

    
  end
end