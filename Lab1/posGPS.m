function [x_orbit, y_orbit] = posGPS(t, t_oe, a, e, M_0)
    format long
        
    % Time elapsed since the ephemeride
    t_i = t-t_oe;
    
    % Mean anomaly
    M = compute_mean_anomaly(M_0, a, t_i, 0);

    % Eccentric anomaly
    E = compute_eccentric_anomaly(M, e);
    
    % True anomaly
    f = compute_true_anomaly(E, e);
    
    % Radial distance
    r = compute_radial_dist(a, e, E, 0,0,0,0);
    
    % Transform polar to cartesian coordinates
    x_orbit = r*cos(f);
    y_orbit = r*sin(f);
end