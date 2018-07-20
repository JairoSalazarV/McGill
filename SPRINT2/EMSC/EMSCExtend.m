% function NewMatrix = EMSCExtend(D,x,y)
%   Purpose: Function used by Design2.m. Extends a design to a new dimension
%   Made By:
%       Morten Beck Rye
%       (c) Consensus Analysis AS 2002
%   Matlab Call: NewMatrix = Extend(D,x,y)
% 
%   Input: D; real matrix(m,n), Existing design dimension n
%          x; real vector; cos values for existing design
%          y; real vector; sin values for existing design
%
%   Output: NewMatrix; real matrix(m,n), New design with dimension n+1 
%
%   Related files: Design.m
%
%   Method: Extends a design from dimension n to dimension n+1
%
%   Status: 30.04.02 MBR: First spec
%           090203 HM: Changed name from Extend.m to EMSCExtend.m
%-------------------------------------------------------------------------------

function NewMatrix =  EMSCExtend(D,x,y)

%x,y,keyboard

[n,m] = size(D);
[n2,m2] = size(x);
New = [];
Ds = D(:,1:end-1);


for j = 1:n
    newi = [(((Ds(j,:))'*ones(1,n2))') x y];
    New = [New;newi];
end

z = zeros(n,1);
D = [D z];
NewMatrix = [D;New];