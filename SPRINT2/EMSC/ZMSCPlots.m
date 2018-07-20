function [NotR2]=ZMSCPlots(Z,InputType,TransformedType,ObjLabels,YClass,Groups,PlotIt)


[nObj,nZVar]=size(Z);
Colors=['r';'g';'b';'c';'m';'k'];nColours=length(Colors);
Colors2=['r.';'g.';'b.';'c.';'m.';'k.'];

if PlotIt==1
    figure,clf
end % if PlotIt

% Find the classes:
ClassMin=min(YClass);ClassMax=max(YClass); nClassMax=ClassMax-ClassMin+1;
[NInClasses,BinCentra] = hist(YClass,nClassMax);

ClassNames=round(BinCentra);
nClasses=length(NInClasses);
nPlots=nClasses+1;
%cr=floor(sqrt(nClasses));
%cc=ceil(nClasses/cr);
Objects=(1:nObj)';One=ones(1,nZVar);

% Plot each class
ic=0;
iTot=0;
for iPlot=1:nPlots
    if iPlot==nPlots
        Class=nPlots; % all
        Y=Objects;
        X=Z;
        ClassObjLabels=ObjLabels;
        Titl=[InputType,TransformedType,', All samples' ];

    else
        Class=ClassNames(iPlot);
        Y=Objects((YClass==Class));
        X=Z((YClass==Class),:);
        ClassObjLabels=ObjLabels((YClass==Class),:);
        Titl=[InputType,TransformedType,num2str(Class),',',Groups(Class,:) ];

    end %if
    Ref=mean(X);
    if PlotIt==1
        ic=ic+1;    subplot(nPlots,2,ic)
        plot(X','k'), hold on,plot(Ref,'k:')
        if Class==nPlots,xlabel('Channel #') ,end 
        title(Titl)
        axis tight
        ic=ic+1;    subplot(nPlots,2,ic)
    end %if PlotIt
    
     
    [nClass,nXVar]=size(X);
    iColour=0;
    for i=1:nClass
        iTot=iTot+1;
        iColour=iColour+1; if iColour>nColours,iColour=1;end
        xi=X(i,:);
       
        % Model:xi= bi*Ref +  ai*1'  +ei =ci*Ref1 + ei
        % ci=xi*pinv(Ref1)
        Ref1=[Ref;One];
        ci=xi*pinv(Ref1);
        C(iTot,:)=ci;
        xiHat=ci*Ref1;
        eiHat=xi-xiHat;
        r=corrcoef(xi,Ref);
        NotR2(i)=log(1-r(1,2)^2);
        
        ximM=[0,max(xi)];
        ximMHat=ci*[ximM; 1 1];
         if PlotIt==1
            plot(Ref,xi,Colors(iColour,:))  ,hold on       
            plot(ximM,ximMHat,'k:')
            plot(Ref,xi,Colors(iColour,:))  
        end %if PlotIt

    end % for i
    if PlotIt==1
        plot(Ref,Ref,'k:') 
        axis tight
        v=axis; v(1)=0;v(3)=0;axis(v)
        Titl=[ 'i=',num2str(Y'),',-log(1-r^2)=',num2str(round(10000*NotR2(i))/10000)];
        title(Titl), 
        if Class==nPlots,,xlabel('Mean'),end
    end % if PlotIt
end % for Class

OK=1;
