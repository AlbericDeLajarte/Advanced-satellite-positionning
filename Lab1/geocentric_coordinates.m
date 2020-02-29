function [x, y, z] = geocentric_coordinates(r, phi, omega, i)

x = r*(cos(phi)*cos(omega) - sin(phi)*cos(i)*sin(omega));
y = r*(cos(phi)*cos(omega) + sin(phi)*cos(i)*sin(omega));
z = sin(phi)*sin(i);

