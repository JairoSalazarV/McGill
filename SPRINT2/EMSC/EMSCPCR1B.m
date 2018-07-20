function [B,W,T,P,Q,U,AUse]=PCR1B(E,F,AMax)
% Purpose: Reduced-Rank Regression by PCR regression 1 y variable, (centred X and y)
% Made by: H.Martens January 2003
% Modified HM 22.1.03
% Input
%	E(nObj x nXVar)
%  F(nObj x 1)
% Output:
   % B(nXVar x 1) B-coefficient at rank a
   % a (scalar) # rank, = max PCs with non-zero scores 
   % W(nXVar,a),T(nObj x a),P(nXVar,a), Q(1,a)   parameters
   
% Note:
  

[nObj,nXVar]=size(E);
[nObjY,nYVar]=size(F);
 
if AMax>max((nObj-1),nXVar)
    AMax=max((nObj-1),nXVar)
end % if AMax
AUse=AMax;
%if nYVar~1,error('wrong # of y vars'),end
if nObjY~=nObj,error('Wrong # of objects, X,Y'),end
 
T=zeros(nObj,AMax);
W=zeros(nXVar,AMax);
P=zeros(nXVar,AMax);
Q=zeros(nYVar,AMax);
B=zeros(nXVar,AMax);

if nObj>nXVar
    [U,S,W]=svd(E,0);
else
    [W,S,U]=svd(E',0);
end % if
W=W(:,1:AMax);
P=W; % PCA!
U=U(:,1:AMax);
T=U*S(1:AMax,1:AMax);
Q=F'*T*inv(T'*T+eps); % PCR!
for a=1:AMax
    B(:,a)=W(:,1:a)*Q(:,1:a)';
end % while


