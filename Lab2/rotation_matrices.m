function [R1, R2, R3] = rotation_matrices(alpha1, alpha2, alpha3)
% ecef_coord is a column vecotr of coordinates expressed in ECEF frame
R1 = [1       0            0;
      0   cos(alpha1)  sin(alpha1);
      0   -sin(alpha1) cos(alpha1)];
  
R2 = [cos(alpha2)       0      -sin(alpha2);
      0                 1            0;
      sin(alpha2)       0      cos(alpha2)];

R3 = [cos(alpha3)   sin(alpha3)      0;
      -sin(alpha3)   cos(alpha3)      0;
            0            0           1];
end


  