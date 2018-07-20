% File ZChangeSpectralUnitsForEMSC.m
% Purpose: Convert spectra from one unit to another, 
%   to simplify the subsequent EMSC
% Made by: H.Martens Jan 2003
%   (c) Consensus Analysis AS 2003
%
% Input: Reading a file
% Output:
%

% cd C:\Matlab\EMSC2003\BomMilkData\FraMBF050203
% Method:
% Define and read input spectra Z
% Define and read input object classes Y
% while not final for saving
%   Define unit of input spectra: (R,T or OD)
%   List modification alternatives for these input data
%   while not final modification
%       Define modifications
%       For each modification alternative, perform modification  and plot results against mean within each separate object class, in MSC plots
%   save modified file
% end
%
global X InputType TransformedTypeD ObjLabels YClass Groups RTMin PlotIt TransformMethod


RTMin=0.0000001; % minimum value of R or T allowed


% Define and read input spectra Z
disp('Define input:')
disp(' 0=manual ');
disp(' 1=R.mat')   
disp(' 2=T.mat')  
disp(' 3=ODR.mat')
disp(' 4=ODT.mat')
disp(' 10=EMSC_Z.mat')  
disp(' Other numbers, see list options'),    
LinearityCases=input('DataCase=? ')
for LinearityCase=LinearityCases;
    if LinearityCase==0
        disp('Give file of the input spectra Z to be changed:')
        [DirectoryName,ZFileName,ZInputFile,Z,ZChannelLabels,ZObjLabels]=EMSCFileReading;
        InputType=input('Linearity type=? 1=R,2=T,3=ODR,4=OD%')
        
        YFileName=input('Give file of the input Class definer Y:','s')
        load YFileName
        
        %[DirectoryName,YFileName,YInputFile,YClass,YVarLabels,YObjLabels]=EMSCFileReading;
        
    else
        if LinearityCase==(10) 
          DirectoryName=[];ZFileName='EMSC_Z.mat';
          InputType=[];
          error('Not Defined!')
        elseif LinearityCase==1
            DirectoryName=[];ZFileName='R.mat';
           InputType='R'; TransformedType='R';
        elseif LinearityCase==2
            DirectoryName=[];ZFileName='T.mat';
            InputType='T'; TransformedType='T';   
        elseif LinearityCase==3
            DirectoryName=[];ZFileName='ODR.mat';
            InputType='ODR';   TransformedType=[];
        elseif LinearityCase==4
            DirectoryName=[];ZFileName='ODT.mat';
            InputType='ODT';  TransformedType=[];           
        else
            error('Unknown LinearityCase')
        end % if LinearityCase==1 
        ZInputFile=strcat(DirectoryName,ZFileName);
        load (ZInputFile); 
        Z=Matrix;ZChannelLabels=VarLabels; ZObjLabels=ObjLabels;
        
        % Define and read input object classes Y
        load YClass

    end % if
        [nObj,nZVar]=size(Z);
        for k=1:nZVar
            ChannelNo(k)=str2num(VarLabels(k,:));
        end % for k
        
end %LinearityCase=LinearityCases;

% Conversion to R or T:
if InputType=='ODR' %ODR
    Z=10.^(-Z); %
    TransformedType='R';
elseif InputType=='ODT' %ODT
    Z=10.^(-Z); % %
    TransformedType='T';
end % if InputType
[nObj,nZVar]=size(Z);

ROrT=Z; % R or T
X=ROrT; % global

 
% Plot the R or T data:
figure,plot(ChannelNo,ROrT'),title([InputType,TransformedType]),axis tight
StdX=(ROrT-ones(nObj,1)*mean(ROrT))./(ones(nObj,1)*std(ROrT));figure,plot(ChannelNo,StdX'),title(['std ',InputType,TransformedType])
axis tight

[NotR2]=ZMSCPlots(ROrT,InputType,TransformedType,ObjLabels,YClass,Groups,1);
% MNR2=mean(NotR2);RAll=[-1 ,MNR2,NotR2];

TransformMethod=input('TransformType?, 1= -log10(Z+d),2=(1-R)/2R , 3=modified KM. ?' )
if TransformMethod==1
    TransformedTypeD=['OD',TransformedType ]
elseif TransformMethod==2
    if TransformedType=='R';
        TransformedTypeD=['KM(',TransformedType ,')']
    else
        TransformedType,TransformMethod 
        error('Impossible')
    end % if 
elseif TransformMethod==3
    TransformedTypeD=['KM2(',TransformedType ,')']
    % Berntsson, O., Burger,T., Folestad, S., Danielsson, L.-G., 
    %   Kuhn, J. and Fricke, J. , Effective sample size in diffuse reflectance Near-IR specrometry.
    %   Analytical Chemistry, 71(3) 1999 p 617-623.
    
else
    TransformMethod
    error('Unknown TransformMethod')
end %if

D=0;[X0]= ZTransformSpectra(TransformMethod,ROrT,D,RTMin);
figure,plot(ChannelNo,X0'),title([InputType,TransformedTypeD]),axis tight
StdX=(X0-ones(nObj,1)*mean(X0))./(ones(nObj,1)*std(X0));figure,plot(ChannelNo,StdX'),title(['std ',InputType,TransformedType])
axis tight
[NotR2]=ZMSCPlots(X0,InputType,TransformedTypeD,ObjLabels,YClass,Groups,1);
 

disp('Min. and Max. of R or T input:')
MinZ=min(ROrT(:))
MaxZ=max(ROrT(:))
pause(.1)
d=input('Give delta R or T: ')
dOpt=input('Optimize this value? Yes=1,No=0')

%
if dOpt==0
    DOpt=d; FVal=NaN;
    ActionText=' ';
    [ZOpt]= ZTransformSpectra(TransformMethod,ROrT,DOpt,RTMin); 
    d1000=round(d*1000);
    FileNameOut=[TransformedTypeD,'d',num2str(d1000),'.mat'];
    %PlotIt=0;

else
    d1=-d;d2=d;
    % global
    PlotIt=0;
    options = optimset('Display','iter','MaxIter',100,'TolX',0.00001,'TolFun',1.000000e-005);
    [DOpt,FVal,EXITFLAG] = fminbnd(@CheckDelta,d1,d2,options );
    ActionText='Optimized';

    %PlotIt=0;
    [ZOpt]= ZTransformSpectra(TransformMethod,ROrT,DOpt,RTMin);      
    % [FVAL]=CheckDelta(DOpt) 
    d1000=round(DOpt*1000);
    FileNameOut=[TransformedTypeD,'Opt',num2str(d1000),'.mat'];

end % if d

PlotIt=1;
figure,plot(ZOpt')
title([ActionText, InputType,TransformedType, ', d=',num2str(DOpt)])
axis tight
    
[NotR2]=ZMSCPlots(ZOpt,InputType,TransformedTypeD,ObjLabels,YClass,Groups,PlotIt);

Matrix=ZOpt;VarLabels=ZChannelLabels;ObjLabels=ZObjLabels;
Txt=['save ',FileNameOut,' Matrix VarLabels ObjLabels']
eval(Txt)




% File ChangeSpectralUnitsForEMSC.m
