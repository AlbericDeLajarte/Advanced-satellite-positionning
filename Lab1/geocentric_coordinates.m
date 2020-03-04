function [x, y, z] = geocentric_coordinates(r, phi, omega, i)

x = r*(cos(phi)*cos(omega) - sin(phi)*cos(i)*sin(omega));
y = r*(cos(phi)*sin(omega) + sin(phi)*cos(i)*cos(omega));
z = r*sin(phi)*sin(i);

