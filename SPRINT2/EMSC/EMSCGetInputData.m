function [DirectoryName, ...
            ZFileName,Z,ZChannelLabels, ZObjLabels, ...
            YFileName, Y,YName ,...
            MscOrIsc,WgtFile,ChannelWeights,nWeightIter,   ...
            ModRef, ModOffset,ModSqSpectrum,ModChannel, ModSqChannel, ...
            RefFileName,RefSpectrum,RefName,FileNameBad, BadC, BadCName, FileNameGood, GoodC, GoodCName, ...
    DataCaseName,OptimizedPar,OptStartVector, PlotIt]=EMSCGetInputData;
            


% Purpose: Read input data for EMSC/EISC
% Made by: H.Martens January 2003
%
% Output:
% DirectoryName: name of directory, e.g.: 
% ZFileName(char): name of file containing spectral data
% Z(nObj x nZVar) Spectral data (1 spectrum = 1 row)
% ChannelLabels Char array with names of Z-variables
% ZObjLabels (nObj x ?)(char array) name of objects
% ChannelWeights(1 x nZVar) weights to be used in the least squares estimation, e.g. ones(1,nZVar)
% nWeightIter (scalar) # of  iterations with re-estimated ChannelWeights
% CondNumber (scalar) condition number, e.g. 10^10
% MscOrIsc (scalar) 1=MSC (or EMSC), 0=ISC (or EISC)
% ModRef(scalar) 1=MSC/EMSC or ISC/EISC, 0= SIS (with MscOrIsc=1)
% ModOffset(scalar): offset in the model
%    0=  no offset modelling, 
%    1=  modell,  and subtract the estimated effect,
%    -1= model, but do not subtract the estimated effect, 
% ModChannel(scalar), channel vector (-1:1) in the model
%    0=  no channel vector modelling 
%    1=  model and subtract the estimated effect
%    -1= model, but do not subtract the estimated effect 
% ModSqChannel(scalar),squared channel vector (-1:1)^2 in the model
%    0=  no squared channel vector modelling 
%    1=  model and subtract the estimated effect
%    -1= model, but do not subtract the estimated effect 
% ModSqSpectrum(scalar)  a squared spectrum in the model (MSC/EMSC: squared reference, ISC/EISC: squared individual spectrum)
%    0=  no squared spectrum  modelling 
%    1=  model and subtract the estimated effect
%    -1= model, but do not subtract the estimated effect
% RefSpectrum(1 x nZVar) spectrum of reference sample, to be used as a regressor in MSC/EMSC,  or as regressand in ISC/EISC
% BadCFileName(char): name of file containing spectral data of the bad components to be modelled and subtracted
% BadC(nBadComp x nZVar) spectra of bad components, 
% BadCName (nBadComp x ?) char array with names of bad components
% GoodCFileName(char): name of file containing spectral data of the good components to be modelled but not subtracted
% GoodC(nGoodComp x nZVar) spectra of good components, 
% GoodCName (nGoodComp x ?) char array with names of  the good components
% RefName (char) name of the spectrum Ref used as reference
% DataCaseName (char) description of input parameters
% OptimizedPar (1 x 3) control of optimzation, 0 or 1, 
%       OptimizedPar(1) for Ref,OptimizedPar(2) for BadC, OptimizedPar(3) for GoodC
% PlotIt (scalar) 1= plot a lot, 0 = plot less
% See also definitions in EMSCGetParametersAndData.m
%
% Related files:
% Called from:      EMSCGetParametersAndData.m
% Calls:            EMSCFileReading.m



    
disp('Give file of the input spectra Z to be changed:')
[DirectoryName,ZFileName,ZInputFile,Z,ZChannelLabels,ZObjLabels]=EMSCFileReading;
[nObj,nZVar]=size(Z);
    
 
% Define model type, MSC/EMSC or ISC/EISC:
MscOrIsc=input('Define model type, 1=MSC/EMSC, -1=ISC/EISC ');
if MscOrIsc>=0
     MscOrIsc=1  
elseif MscOrIsc==0
     MscOrIsc
else
     MscOrIsc=-1
end % if MscOrIsc

    
ModRef=1; %SIS not implemented yet!
    
%Get ModRefSpectrum
DefRef=input('How is the Reference spectrum to be defined? 0=mean of the input spectra Z, 1= read from file  ')
if DefRef==0
        RefSpectrum=mean(Z);     RefFileName=[]; RefName='Ref=mean(Z)'; 
elseif DefRef==1
        disp('Give file of the model reference spectrum file:')
        [Dir ,RefFileName,RefInputFile,RefSpectrum,RefChannelLabels,RefName]=EMSCFileReading;
        [nModRef,nRefVar]=size(RefSpectrum);
        if nRefVar~=nZVar
            error('The number of variables in Z and the reference spectrum are not the same')
            ZInputFile,nObjZ
            RefInputFile,nRefVar
            keyboard
        end %if nRefVar
        if nModRef>1  
            disp('Reference numbers and names:')
            for k=1:nModRef
                disp(['Col. ',num2str(k),', ',RefName(k,:) ])
            end % for k
            j=input('Give index of the Y-variable to be used: ')
            RefSpectrum=RefSpectrum(j,:);
            RefName=RefName(j,:)
        end % if nModRef
 
else
    DefRef
   error('Unknown value of DefRef! 0 or 1! ')
        
end % if DefRef==0

    
disp('Define if offset is to be used:')
ModOffset=input('0=no offset, 1=model and subtract, -1=model but not subtract ');
if ModOffset>0
     ModOffset=1
elseif ModOffset==0
     ModOffset
elseif ModOffset<0
     ModOffset=-1
end % if ModOffset
        
disp('Define if the channel# is to be used:')
ModChannel=input(' 0=no, 1=model and subtract, -1=model but not subtract ');
if ModChannel>0
     ModChannel=1  
elseif ModChannel==0
        ModChannel
elseif ModChannel<0
     ModChannel=-1
end % if ModChannel
            
    
disp('Define if the squared channel# is to be used:')
ModSqChannel=input('0=no, 1=model and subtract, -1=model but not subtract ');
if ModSqChannel>0
        ModSqChannel=1  
elseif ModSqChannel==0
        ModSqChannel
elseif ModSqChannel<0
        ModSqChannel=-1
end % if BaddCFileName
   
disp('Define if a squared spectrum is to be used:')
ModSqSpectrum=input(' 0=no, 1=model and subtract, -1=model but not subtract ');
if ModSqSpectrum>0
        ModSqSpectrum=1  
elseif ModSqSpectrum==0
        ModSqSpectrum
elseif ModSqSpectrum<0
        ModSqSpectrum=-1
end % if ModSqSpectrum
        

    
  
disp('Define if  spectra of GOOD components are to be input (for modelling, but not subtracted):')
InputGoodComponents=input('1= read spectra of good component from file, else give 0 ')
if InputGoodComponents
        disp('read spectra of GOOD components spectra')
        [DirectoryNameGood, FileNameGood ,GoodCFileName ,GoodC ,VarLabelsGood ,GoodCName]=EMSCFileReading;
else
        DirectoryNameGood=[]; FileNameGood=[]; GoodCFileName=[]; GoodC=[]; VarLabelsGood=[]; GoodCName=[];;
end % InputGoodComponents

disp('Define if  spectra of BAD components are to be input (for modelling and subtraction):')

InputBadComponents=input('1= read from file,  else give 0 ')
if InputBadComponents
        disp('read spectra of BAD components spectra')
        [DirectoryNameBad, FileNameBad ,BadCFileName ,BadC ,VarLabelsBad ,BadCName]=EMSCFileReading;
else
        DirectoryNameBad=[]; FileNameBad=[]; BadCFileName=[]; BadC=[]; VarLabelsBad=[]; BadCName=[];;
end % InputBadComponents
    
[nBadComp,dummy]=size(BadC);[nGoodComp,dummy]=size(GoodC);


% Optimise any vector?
OptPar=input('Optimize any of the model spectra? 0=n0, 1=Ref, 2= BadSpectrum, 3=GoodSpectrum')
if OptPar==1,
    OptimizedPar=[1 0 0 ];    RefName=['Opt.',RefName];    OptStartVector=RefSpectrum;
elseif OptPar==2
    OptimizedPar=[0 1 0];     
    OptStartVector=zeros(1,nZVar);BadC=[BadC;OptStartVector];
    BadCName=char([cellstr(BadCName); cellstr('OptBad')]);
elseif OptPar==3
    OptimizedPar=[0 0 1 ];  
    OptStartVector=zeros(1,nZVar);GoodC=[BadC;OptStartVector];
    GoodCName=char([cellstr(GoodCName); cellstr('OptGood')]);
else % no optimization!
    OptimizedPar=[0 0 0]; OptStartVector=[];
end %if 

[nBadComp,dummy]=size(BadC);[nGoodComp,dummy]=size(GoodC);


if sum(OptimizedPar)>0 % Y has to be defined if optimization is to be used
    disp('read Y-file')
        % [DirectoryName,FileName,InputFile,Matrix,VarLabels,ObjLabels]=FileReading;
        [DirectoryY, FileNameY ,YFileName ,Y ,YName ,ObjYNames]=EMSCFileReading;
else
        disp('Define if  Y is  to be used:')
        InputY=input('1= read from file,to check model; else give 0 ')
        if InputY
            disp('read Y-file')
            % [DirectoryName,FileName,InputFile,Matrix,VarLabels,ObjLabels]=FileReading;
            [DirectoryY, FileNameY ,YFileName ,Y ,YName ,ObjYNames]=EMSCFileReading;
        else
            DirectoryY=[]; FileNameY=[]; YFileName=[]; Y =[]; YName=[]; YName=[];;
        end % InputBadComponents
end % if sum(OptimizedPar)


            
disp('Define if  a weight vector different from [1,1,1,....,1,1] is  to be used:')
InputW=input('1= read from file,to check model; else give 0 ')
if InputW
        disp('read Weight file')
        % [DirectoryName,FileName,InputFile,Matrix,VarLabels,ObjLabels]=FileReading;
        [DirectoryW, FileNameW ,WgtFile ,ChannelWeights ,WName ,WgtName]=EMSCFileReading;
        [n1,nWVar]=size(ChannelWeights);
        if nWVar~=nZVar
            disp(' '),   disp('???????????????????????? ')           
            disp(['Data file ',ZInputFile,' has ',num2str(nZVar),' variables'])
            disp(['Weight file ',WgtFile,' has ',num2str(nWVar),' variables'])
            error('These files have different number of channels!')
        end % if
else
        DirectoryW=[]; FileNameW=[]; WgtFile=[]; ChannelWeights =ones(1,nZVar); WgtName=[]; 
        ChannelWeights=ones(1,nZVar);
end % InputBadComponents

    
nWeightIter='Give number of extra iterations using re-estimated weights (max 10)')
nWeightIter=max(nWeightIter,0);    nWeightIter=min(nWeightIter,10);

DataCaseName=input('Give the title you want to call this run ','s')
    

% Plot control:
PlotIt= input('Plot model=1,else give 0 ');   % 0 %1; (0 or 1)
if PlotIt==0
elseif  PlotIt==1
elseif  PlotIt==2
else
  PlotIt=1;
end % if PlotIt