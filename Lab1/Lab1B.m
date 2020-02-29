%% Lab 1.B

% Satellite Navigation Message
sat_nums =  [2, 5, 8, 11, 12, 24, 25];% the satellites we want the coordinates for
t = 225445.0; % Time of week [s]
we=7292115e-11; % Earth's angular velocity, [rad/s]

% ECI and ECEF coordinates: 
[eci_matrix, ecef_matrix] = eci_and_ecef_coordinates(sat_nums, t, we);