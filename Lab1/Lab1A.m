%% Lab 1.A

% Satellite Navigation Message
t_oe = .225600000000E+06; % [seconds]
a = (.544062105942E+04)^2; % [meters]
e = .404827296734E-04;
M_o = .194850072201E+01; % [radians]

% Position at one time
[x0, y0] = posGPS(225445, t_oe, a, e, M_o);


% Position in a time interval
t_start = 174600;
t_end = 225000;

x = zeros(1, t_end- t_start);
y = zeros(1, t_end- t_start);
k = 1;
for t = t_start:t_end
    [x(k), y(k)] = posGPS(t, t_oe, a, e, M_o);
    k = k+1;
end

% Apogee and Perigee
apo = a*(1+e);
peri = a*(1-e);

% Plot
%{
figure(1);
plot3(t_start:t_end,x,y);
xlabel('Time [s]')
ylabel('X coordinate [m]');
zlabel('Y coordinate[m] ');
%title("Movement of the satellite")

figure(2);
plot(t_start:t_end, x, t_start:t_end, y);
xlabel('Time [s]');
ylabel('X/Y coordinate [m] ');
legend('X position', 'Y position');
%}
plot(x,y);
