% Correction of the satellite's coordinate to take into account the
% rotation of the Earth during the transmission
function [X_corr] = correction_Earth_rotation(X, delay)
we = 7.2921151467e-5;
% Rotation angle in radian
theta = delay*we;

% R3= rotation matrix around the Z axis (axis perpendicular to the equator in ECEF coordiante)
X_corr = R3(theta)*X;
end