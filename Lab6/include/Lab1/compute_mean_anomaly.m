function M = compute_mean_anomaly(M_0, a, t_i, delta_n)
%% This function computes the mean anomaly
%%
GM = 3.986005e14;
%delta_n is a correction term
M = M_0 + t_i*(delta_n + sqrt(GM/(a^3)));

end

