function i = compute_inclination(i_0, i_dot, t_i, cic, w, cis, f)
i = i_0 + i_dot*t_i + cic*cos(2*(w + f)) + cis*sin(2*(w + f));