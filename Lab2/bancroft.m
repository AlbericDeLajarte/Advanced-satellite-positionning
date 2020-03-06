function [] = bancroft(t, sat_nums, we)

% Computation of ECI and ECEF coordinates of given satellites: 
[eci_matrix, ecef_matrix] = eci_and_ecef_coordinates(t, sat_nums, we);


