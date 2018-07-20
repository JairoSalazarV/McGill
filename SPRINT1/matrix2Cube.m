function X = matrix2Cube(matrix, R, C, L)
  %==================================================
  % Autor: Jairo Salazar | jsalazar@gdl.cinvestav.mx
  % INPUT
  %   X     := cube as a NxL Matrix 
  % OUTPUT
  %   cube  := A Cube as ROWS x COLS x L Matrix
  %==================================================
  X       = zeros(R,C,L);
  i       = 1;
  for r=1:R
    for c=1:C
      X(r,c,:)  = squeeze(matrix(i,:));
      i         = i + 1;
    end
  end
end