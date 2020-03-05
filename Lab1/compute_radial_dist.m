function ri = compute_radial_dist(a, e, E, crc, w, f, crs)
%% This function computes the radial distance
%%
% crc, crs are correction terms
ri = a*(1 - e*cos(E))+ crc*cos(2*(w + f)) + crs*sin(2*(w + f));
