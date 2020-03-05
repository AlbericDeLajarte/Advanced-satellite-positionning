function E = compute_eccentric_anomaly(M, ecc)
%% This function computes the eccentric anomaly iteratively
%%
E = M;
E_old = E+1;
while abs(E-E_old)>= 1e-13
    E_old = E;
    E = M + ecc*sin(E_old);        
end

end

