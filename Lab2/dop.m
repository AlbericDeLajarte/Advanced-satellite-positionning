function [pdop, hdop, vdop, gdop] = dop(Qxx)

%% Computation of coordinates
F = ; % use of function xyz2plh ? 
matrix_enu = F'*Qxx*F;
trace_enu = trace(matrix_enu);
trace_Qxx = trace(Qxx);
%% Computation of the different dilution of precision
pdop = sqrt(trace_enu);
hdop = sqrt(trace_enu - matrix_enu(3,3));
vdop = sqrt(Qxx(4,4)^2);
gdop = sqrt(trace_enu + Qxx(4,4)^2);
