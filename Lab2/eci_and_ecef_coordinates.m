function [eci_matrix, ecef_matrix, parsed_ephm, info] = eci_and_ecef_coordinates(t, sat_nums, we)
%% This function computes the coordinates in ECi and ECEF 
 % reference frames for a list of satellite ids.

%%
format long g

% First we parse the ephemerides: we only keep one set of parameters for 
% each satellite asked
[parsed_ephm, info] = parse_matrix(t, sat_nums);

% Then we find the indices of the relevant parameters 
[toe_index, M0_index, sqrta_index, deltan_index,...
    ecc_index, omega_index, cwc_index, cws_index, crc_index, ...
    crs_index, i0_index, idot_index, cic_index, cis_index, ...
    omega0_index, omegadot_index] = find_indices(info);


% The following matrices will contain the final coordinates in eci and ecef
eci_matrix = zeros(length(sat_nums), 3);
ecef_matrix = zeros(length(sat_nums), 3);

for i=1:length(sat_nums)
    
    % Time elapsed since the ephemeride  
    t_i = t-parsed_ephm(toe_index, i);
    
    % Mean anomaly
    M = compute_mean_anomaly(parsed_ephm(M0_index, i),(parsed_ephm(sqrta_index, i))^2, t_i, parsed_ephm(deltan_index, i));

    % Eccentric anomaly
    E = compute_eccentric_anomaly(M, parsed_ephm(ecc_index, i));

    % True anomaly
    f = compute_true_anomaly(E, parsed_ephm(ecc_index, i));
    
    % Argument of perigee
    [w, phi] = compute_argument_perigee(parsed_ephm(omega_index, i), parsed_ephm(cwc_index, i), parsed_ephm(cws_index, i), f);
    
    % Radial distance
    r = compute_radial_dist((parsed_ephm(sqrta_index, i))^2,parsed_ephm(ecc_index, i), E, parsed_ephm(crc_index, i), w, f, parsed_ephm(crs_index, i));

    % Inclinaison
    inc = compute_inclination(parsed_ephm(i0_index, i), parsed_ephm(idot_index, i), t_i, parsed_ephm(cic_index, i), w, parsed_ephm(cis_index, i), f);

    % Longitude of ascending node in the 2 reference frames: 
    [eci_omega, ecef_omega] = compute_long_ascending_node(parsed_ephm(omega0_index, i), parsed_ephm(omegadot_index, i), t_i, parsed_ephm(toe_index, i), we);
   
    % geocentric coordinates
    [x_eci, y_eci, z_eci] = geocentric_coordinates(r, phi, eci_omega, inc);
    eci_matrix(i,:) = [x_eci, y_eci, z_eci];
    [x_ecef, y_ecef, z_ecef] = geocentric_coordinates(r, phi, ecef_omega, inc);
    ecef_matrix(i,:) = [x_ecef, y_ecef, z_ecef];
end
end

