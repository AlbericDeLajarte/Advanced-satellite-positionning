function [] = orbit_plot()
[t_oe, sqrt_a, e, M_0, time_span] = ephemerides();
first = time_span(1);
last = time_span(2);
time_vect = [first:100:last];

X = zeros(length(time_vect));
Y = zeros(length(time_vect));

i=1;
for time = time_vect
    [X(i), Y(i)] = sat_coordinates(time, t_oe, sqrt_a, e, M_0);
    i=i+1;
end
plot(X,Y);
xlabel('X coordinate');
ylabel('Y coordinate')