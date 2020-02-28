function M = compute_mean_anomaly(M_0, a, t_i)
%%This function computes the mean anomaly
GM = 3.986005e14;
M = M_0 + t_i*(sqrt(GM/(a^3)));
%M_o + sqrt(mu/(a^3))*t_i;

end

