function [x, y] = posGPS(t, t_oe, a, e, M_o)
    format long
    mu =  3.986005e14;
    
    % Time elapsed since the ephemeride
    t_i = t-t_oe;
    
    % Mean anomalay
    M = M_o + sqrt(mu/(a^3))*t_i;

    % Iteratively find Eccentric anomaly
    E = M;
    E_old = E +1;
    while abs(E-E_old)>= 1e-13
        E_old = E;
        E = M + e*sin(E_old);
    end
    
    f = atan(sqrt(1-e^2)*sin(E)/(cos(E)-e));
    
    r = a*(1-e*cos(E));
    
    x = -r*cos(f);
    y = -r*sin(f);
end