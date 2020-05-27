function [omega_eci, omega_ecef] = compute_long_ascending_node(omega_0, omega_dot, t_i, t_oe, we)
%% This function computes the longitude of the ascending node in
% both ECI and ECEF reference frames
%%
% omega_0, omega_dot are correction terms
omega_eci = omega_0 + t_i*omega_dot;
omega_ecef = omega_0 + (omega_dot - we)*t_i - we*t_oe;
