function [pdop, hdop, vdop, gdop] = dop(Qxx, parameters, nb_of_sats)

%% Computation of transformation matrix F
% we want to convert ECEF into ENU coordinates 
[t_i, M, i, f, w, phi, r, inc, eci_omega, ecef_omega];
for i=[1:nb_of_sats]:
    phi = parameters(i, 6)
    lambda = 
end
F = ; 
[R1, ~, R3] = rotation_matrices()
matrix_enu = zeros(ecef_matrix)
trace_enu = trace(matrix_enu);
trace_Qxx = trace(Qxx);
%% Computation of the different dilution of precision
pdop = sqrt(trace_enu);
hdop = sqrt(trace_enu - matrix_enu(3,3));
vdop = sqrt(Qxx(4,4)^2);
gdop = sqrt(trace_enu + Qxx(4,4)^2);

end