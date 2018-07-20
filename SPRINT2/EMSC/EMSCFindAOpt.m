function [AOpt,MSEPYAOpt]=EMSCFindAOpt(MSEPY,FactorNeeded)
% Purpose: Define Optimal rank of a model
% Made by H. Martens May 2001
% Input: ...
% 
% Output: ...
% 
%Method: ...
%
% Status: 20203 HM. Modified slightly, WORKS
% Documentation is incomplete

    

AMaxp1=length(MSEPY);
%AMax=AMaxp1-1;
OK=0;
[MinMSEPY,AMinp1]=min(MSEPY);
Ap1=AMinp1; % start
AOpt=AMinp1-1;
if Ap1<=1,
    AOpt=0;
    OK=-1;% to stop it from crashing
else
    while OK==0
			Ap1=Ap1-1;
			if Ap1>0
        		R=MSEPY(Ap1)/MSEPY(AMinp1);
        		if R >=FactorNeeded
            	OK=1;
            	AOpt=Ap1-1+1;
            end % if R
         else
            AOpt=0;OK=1;
        end % if Ap1
      end % while
end % if Ap1
   
MSEPYAOpt=MSEPY(AOpt+1);

%MSEPY,FactorNeeded,MinMSEPY,AMinp1,MSEPYAOpt,AOpt
%keyboard