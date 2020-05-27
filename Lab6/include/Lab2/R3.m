function [R3] = R3(angle)
R3 = [cos(angle)    sin(angle)      0;
      -sin(angle)   cos(angle)      0;
           0            0           1];
        
end