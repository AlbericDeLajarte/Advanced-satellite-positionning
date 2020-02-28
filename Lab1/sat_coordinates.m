function [x_orbit, y_orbit] = sat_coordinates(t, t_oe, sqrt_a, e, M_0)
    format long
        
    % Time elapsed since the ephemeride
    t_i = t-t_oe;
    
    % Mean anomaly
    M = compute_mean_anomaly(M_0, sqrt_a, t_i);

    % Eccentric anomaly
    E = compute_eccentric_anomaly(M, e);
    
    % True anomaly
    f = compute_true_anomaly(E, e);
    
    % Radial distance
    r = sqrt_a^2*(1-e*cos(E));
    
    % Transform polar to cartesian coordinates
    x_orbit = r*cos(f);
    y_orbit = r*sin(f);
end