% function Directions = EMSCDesign(A, Precision)
%   Purpose: Create a matrix of linear combinations in demension A
%   Made By:
%       Morten Beck Rye
%       (c) Consensus Analysis AS 2002
%   Matlab Call: Directions = Design(A, Precision)
% 
%   Input: A; integer, Number of dimensions to sample in
%          Precision; integer, Precision of sampling
%
%   Output: Directions; real matrix(n,m), Matrix with linear combiations
%
%   Related files: Mapping.m
%
%   Method: Creates a matrix with different linear combination in dimension A
%
%   Status: 30.04.02 MBR: First spec
%       30.1.03 HM: modified input
%       090203 HM Call to Extend changed to EMSCExtend
%-------------------------------------------------------------------------------

function Directions = EMSCDesign(A,Precision)


if 0
    Directions = [];
    Zero=zeros(1,A);
    for a=1:A
        z=Zero;z(a)=1;
        Directions=[Directions;z];       
        for b=[(a+1:A)]
            zb=z; zb(b)=1; 
            zb=zb/sqrt(sum(zb.^2));
            Directions=[Directions;zb];       
        end % for b
    end % for a
    
    

else % MBR version 2002:

    %if A > 4
    %Directions = [];
    %v = (1:A);
    %for j = 1:Precision
        %perm = nchoosek(v,j);
        %[x,y] = size(perm);
        %D = [];
        %for i = 1:x
         %   Z = zeros(1,A);
         %   Z(perm(i,:)) = 1;
         %   D = [D;Z];
         % end
        %Directions = [Directions;D];    
        %end
    %return;
    %end

    
   
    
    X = (0:Precision)';
    X = X*pi/Precision;
    x = cos(X);
    y = sin(X);
    D = [x y];

    if A > 2
        ANew=A-2;
        ANew=min(ANew,2);
        %D = D(1:end-1,:);
        for i = 1:(ANew)
            D = EMSCExtend(D, x, y);
        end % for i
       % D now has max 2+ANew columns


        [nDes,nCol]=size(D);
        if nCol<A
            for ia=1:A-nCol % add zeros % fractional factorials for the rest
                a=nCol+ia;
                d= zeros(nDes,1); %D(:,ia).*D(:,ia+1);
                D=[D d];
            end % for a
            for ia=1:A-nCol % add I for the rest
                a=nCol+ia;
                d= zeros(1,A); d(a)=1;%D(:,ia).*D(:,ia+1);
                D=[D; d];
            end % for a
        end % if nCol
         
    end % if A

   Directions = D;

   
end % if 0

[nDes,a  ]=size(D);   disp(['Design with ',num2str(nDes),' starting points is now going to be tested!'])

   
