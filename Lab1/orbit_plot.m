function [] = orbit_plot()
[t_oe, sqrt_a, e, M_0, time_span] = ephemerides();
t_start = time_span(1);
t_end = time_span(2);
%time_vect = [t_start:100:t_end];

X = zeros(1, t_end- t_start);
Y = zeros(1, t_end- t_start);
i=1;
for t = t_start:t_end
    [X(i), Y(i)] = sat_coordinates(t, t_oe, sqrt_a, e, M_0);
    i = i+1;
end
figure(1);
plot3(t_start:t_end,X,Y);
ylabel('X coordinate');
zlabel('Y coordinate');
title('Movement of the satellite')
plot(X,Y);
