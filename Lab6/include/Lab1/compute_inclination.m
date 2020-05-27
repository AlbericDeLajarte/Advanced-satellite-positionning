function i = compute_inclination(i_0, i_dot, t_i, cic, w, cis, f)
%% This function computes the inclination
%%
% i_0, i_dot, cic, cis are correction terms
i = i_0 + i_dot*t_i + cic*cos(2*(w + f)) + cis*sin(2*(w + f));