function [OK]=CurvePlots(Z,InputType,TransformedType,ObjLabels,YClass,Groups)
figure,clf

[nObj,nZVar]=size(Z);
Colors=['r';'g';'b';'c';'m';'k'];nColours=length(Colors);
Colors2=['r.';'g.';'b.';'c.';'m.';'k.'];



% Find the classes:
ClassMin=min(YClass);ClassMax=max(YClass); nClassMax=ClassMax-ClassMin+1;
[NInClasses,BinCentra] = hist(YClass,nClassMax);
ClassNames=round(BinCentra);
nClasses=length(NInClasses);
cr=floor(sqrt(nClasses));
cc=ceil(nClasses/cr);
Objects=(1:nObj)';One=ones(1,nZVar);

% Plot each class

iTot=0;
for Class=ClassNames
    subplot(cr,cc,Class)

    Y=Objects((YClass==Class));
    X=Z((YClass==Class),:);
    ClassObjLabels=ObjLabels((YClass==Class),:);
    [nClass,nXVar]=size(X);
    Ref=mean(X);
    iColour=0;
    for i=1:nClass
        iTot=iTot+1;
        iColour=iColour+1; if iColour>nColours,iColour=1;end
        xi=X(i,:);
        plot( xi,Colors(iColour,:))  ,hold on 
    end % for i
    plot(Ref,Ref,'k:') 
    axis tight
    v=axis; v(1)=0;v(3)=0;axis(v)
    Titl=[InputType,TransformedType,',', num2str(Class),',',Groups(Class,:) ,'i=',num2str(Y')];
    title(Titl), xlabel('Channel #')   
end % for Class

OK=1;