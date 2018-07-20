function [allSlidesAVG] = balancedPrepareDataset(originPath, destineFilename, numElementsF, numElementsNF, print, saveIt)
  %%Initialize    
  load( './Info/Group_fertile.mat' );
  
  numFiles      = max(size(FGName));
  newFilename   = [sprintf('%06d', FGName(1) ) '.mat'];
  load( [originPath newFilename ] );
  numSlides     = slide.numSlides;

  %Initialize container of slidesAVG
  for s=1:numSlides
    slidesFertile{s}.mean       = [];
    slidesFertile{s}.std        = [];
    slidesFertile{s}.median     = [];
    slidesNonFertile{s}.mean    = [];
    slidesNonFertile{s}.std     = [];
    slidesNonFertile{s}.median  = [];
  end

  %Get two Balanced Subset
  lstFertile      = find( Y==1 );
  lstNonFertile   = find( Y==0 );
  mFertile        = max(size(lstFertile));
  mNonFertile     = max(size(lstNonFertile));
  rFertile        = randi([1 mFertile],1,numElementsF);
  rNonFertile     = randi([1 mNonFertile],1,numElementsNF);
  subset          = [lstFertile(rFertile)' lstNonFertile(rNonFertile)'];
  numFiles        = max( size(subset) );
  if sum(Y(subset)) > (numElementsF+numElementsNF)
    printf("ERROR Balancing Subsets\n");
    fflush(stdout);
    return;
  end


  %Separate Fertile and Nonfertile
  for i=1:1:numFiles
    newFilename     = [sprintf('%06d', FGName(subset(i)) ) '.mat'];
    originFilename  = [originPath newFilename];
    if exist( originFilename )
      load(originFilename);
      for s=1:numSlides  
        if slide.fertile == 1
          slidesFertile{s}.mean       = [slidesFertile{s}.mean;   [slide.mean(s,:) 1]];
          slidesFertile{s}.std        = [slidesFertile{s}.std;    [slide.std(s,:) 1]];
          slidesFertile{s}.median     = [slidesFertile{s}.median; [slide.median(s,:) 1]];
        else
          slidesNonFertile{s}.mean    = [slidesNonFertile{s}.mean;   [slide.mean(s,:) 0]];
          slidesNonFertile{s}.std     = [slidesNonFertile{s}.std;    [slide.std(s,:) 0]];
          slidesNonFertile{s}.median  = [slidesNonFertile{s}.median; [slide.median(s,:) 0]];
        end
      end
    end
    
    %Update Advance
    if print == 1
      status = [num2str((i/numFiles)*100) '% --> ' num2str(i) ' of ' num2str(numFiles)]
      fflush(stdout);
    end
    
      
  end

  %Calculate All Eggs Average
  for s=1:numSlides
    slideAllFertileEggs{s}.mean       = mean(slidesFertile{s}.mean);
    slideAllFertileEggs{s}.std        = mean(slidesFertile{s}.std);
    slideAllFertileEggs{s}.median     = mean(slidesFertile{s}.median);
    
    slideAllNonFertileEggs{s}.mean    = mean(slidesNonFertile{s}.mean);
    slideAllNonFertileEggs{s}.std     = mean(slidesNonFertile{s}.std);
    slideAllNonFertileEggs{s}.median  = mean(slidesNonFertile{s}.median);
  end

  %Prepare file to save
  allSlidesAVG.numSlides                    = numSlides;
  allSlidesAVG.fertile                      = slideAllFertileEggs;
  allSlidesAVG.nonfertile                   = slideAllNonFertileEggs;
  allSlidesAVG.fertileEggsAVGSignatures     = slidesFertile;
  allSlidesAVG.nonfertileEggsAVGSignatures  = slidesNonFertile;

  %Save AVG
  %destineFilename                = [destinePath 'balanceTraining_AllSlidesAVG' num2str(k) '.mat'];
  if saveIt == 1
    save(destineFilename, 'allSlidesAVG');
  end
    
end

