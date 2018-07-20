 function [DirectoryName,FileName,InputFile,Matrix,VarLabels,ObjLabels]=EMSCFileReading;
 % Purpose: Simplify input of matlab file
 % Made by: H.Martens 2003 based on code from M.B.Jensen
 % Input: None
 % Output
 % Status:020203 HM WORKS
 % Documentation not finished
 %
    s=['Define input Matlab data file, exported e.g. from The Unscrambler : ']; %loads exported Unscrambler data.
    disp(s)
   
    disp(' ')
    [n,o]=uigetfile('*.mat', 'Pick a Matlab data-file');
    n=cellstr(n);
    o=cellstr(o);
    %FileName(1,:)=o;
    %FileName(2,:)=n;
    DirectoryName=char(o);
    FileName=char(n);
    InputFile=strcat(DirectoryName,FileName)
        
    %Read the file, just to check dimensions:
    load (InputFile);
        
    [nObjInFile,nColumnsInFile]=size(Matrix)
 
    nObj=nObjInFile;
    if nColumnsInFile<50
        disp('Variable numbers and names:')
        for k=1:nColumnsInFile
            disp(['Col. ',num2str(k),', ',VarLabels(k,:) ])
        end % for k
    end % if
       
    if nObjInFile<50
        disp('Object numbers and names:')
        for k=1:nObjInFile
            disp(['Row ',num2str(k),', ',ObjLabels(k,:) ])
        end % for k
    end % if
    
    
 