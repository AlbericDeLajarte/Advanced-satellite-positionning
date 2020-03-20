function [eci_coord, ecef_coord, parsed_ephm] = eci_and_ecef_coord(t, sat_num, we, ephm, info)
%% This function computes the coordinates in ECI and ECEF 
 % reference frames for one satellite id, for a given time.

%%
format long g

% First we parse the ephemerides: we only keep one set of parameters for 
% each satellite asked

[parsed_ephm, info] = parse_ephemerides(t, sat_num, ephm, info);

% Find the indices of the relevant parameters 
[toe_index, M0_index, sqrta_index, deltan_index,...
    ecc_index, omega_index, cwc_index, cws_index, crc_index, ...
    crs_index, i0_index, idot_index, cic_index, cis_index, ...
    omega0_index, omegadot_index] = find_indices(info);

% Time elapsed since the ephemeride  
t_i = t-parsed_ephm(toe_index);

% Mean anomaly
M = compute_mean_anomaly(parsed_ephm(M0_index),(parsed_ephm(sqrta_index))^2, t_i, parsed_ephm(deltan_index));

% Eccentric anomaly
E = compute_eccentric_anomaly(M, parsed_ephm(ecc_index));

% True anomaly
f = compute_true_anomaly(E, parsed_ephm(ecc_index));

% Argument of perigee
[w, phi] = compute_argument_perigee(parsed_ephm(omega_index), parsed_ephm(cwc_index), parsed_ephm(cws_index), f);

% Radial distance
r = compute_radial_dist((parsed_ephm(sqrta_index))^2,parsed_ephm(ecc_index), E, parsed_ephm(crc_index), w, f, parsed_ephm(crs_index));

% Inclinaison
inc = compute_inclination(parsed_ephm(i0_index), parsed_ephm(idot_index), t_i, parsed_ephm(cic_index), w, parsed_ephm(cis_index), f);

% Longitude of ascending node in the 2 reference frames: 
[eci_omega, ecef_omega] = compute_long_ascending_node(parsed_ephm(omega0_index), parsed_ephm(omegadot_index), t_i, parsed_ephm(toe_index), we);

% geocentric coordinates
[x_eci, y_eci, z_eci] = geocentric_coordinates(r, phi, eci_omega, inc);
eci_coord = [x_eci, y_eci, z_eci];
[x_ecef, y_ecef, z_ecef] = geocentric_coordinates(r, phi, ecef_omega, inc);
ecef_coord = [x_ecef, y_ecef, z_ecef];

end

