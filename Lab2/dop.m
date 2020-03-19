function [pdop, hdop, vdop, gdop] = dop(Qxx, ecef_position)
%{ 
This function computes the dilution of precision from the information 
matrix and the ecef position 
%}

%% Computation of transformation matrix F
% Change from ECEF to ENU reference
enu_position = xyz2plh(ecef_position);
phi = enu_position(1); % latitude
lambda = enu_position(2); % longitude
Ft = R3(pi)*R2(phi-pi/2)*R3(lambda-pi);

%% Transformtation of the information matrix Qxx
rotated_Qxx = Ft*Qxx(1:3, 1:3)*Ft';
trace_Qxx = trace(Qxx);
trace_rot_Qxx = trace(rotated_Qxx);

%% Computation of the different dilution of precision
pdop = sqrt(trace_Qxx - Qxx(4,4)); 
hdop = sqrt(trace_rot_Qxx - rotated_Qxx(3,3));
vdop = sqrt(rotated_Qxx(3,3));
gdop = sqrt(trace_Qxx); 

end