clear all
close all
Action=3

% path(path,'C:\Matlab\EMSC2003')
    

if Action==1
    ZChangeSpectralUnitsForEMSC
end % if

if Action==2
    !copy ODT.mat EMSC_Z.mat 
    EMSCMakeDefaults % reads EMSC_Z.mat
end % if 0

if Action==3
 
 EMSC_Main
end % if

    
    