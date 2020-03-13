% Correction of the satellite's coordinate to take into account the
% rotation of the Earth during the transmission
function X_corr = correction_Earth_rotation(X, delay)
we = 7.2921151467e-5;
% Rotation angle in radian
theta = delay*we;

% Rotation matrix around the Z axis (axis perpendicular to the equator in ECEF coordiante)
R = [cos(theta) -sin(theta) 0;
     sin(theta)  cos(theta) 0;
     0             0        1];
 

X_corr = R*X;
 
end