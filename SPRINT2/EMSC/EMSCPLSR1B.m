function [B,W,T,P,Q,AMax]=EMSCPLSR1B(E,f,AMax)
% Purpose: Reduced-Rank Regression by pls1 regression 1 y variable, (centred X and y)
% Made by: H.Martens august 1999
% Modified HM 12.1.03
% Input
	%	E(nObj x nXVar)
   %  f(nObj x 1)
% Output:
	% B(nXVar x 1) B-coefficient at rank a
   % a (scalar) # rank, = max PCs with non-zero scores 
   % W(nXVar,a),T(nObj x a),P(nXVar,a), Q(1,a)   parameters
   
% Changes: 13.2.03 HM: Changed name from PLSR1B to EMSCPLSR1B
% Note:
  
[nObj,nXVar]=size(E);
[nObjY,nYVar]=size(f);
 
%if nYVar~1,error('wrong # of y vars'),end
if nObjY~=nObj,error('Wrong # of objects, X,Y'),end
 
T=zeros(nObj,AMax);
W=zeros(nXVar,AMax);
P=zeros(nXVar,AMax);
Q=zeros(nYVar,AMax);
B=zeros(nXVar,AMax);

for a=1:AMax
   w=(f'*E)';
   w=w/sqrt(max(w'*w,eps));
   t=E*w;
   tt=t'*t;
   p=(t'*E/tt)';q=(t'*f/tt)';
   T(:,a)= t;W(:,a)= w;P(:,a)=p;Q(:,a)=q;
   E=E-t*p';f=f-t*q';  
   PW=P(:,1:a)'*W(:,1:a);
   B(:,a)=W(:,1:a)*inv(P(:,1:a)'*W(:,1:a))*Q(:,1:a)';
end % while


