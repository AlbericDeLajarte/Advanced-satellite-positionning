function [wi, phi] = compute_argument_perigee(w, cwc, cws, f)

wi = w + cwc*cos(2*(w + f)) + cws*sin(2*(w + f));
% with true anomaly f, can also be computed as: 
phi = w + f + cwc*cos(2*(w + f)) + cws*sin(2*(w + f));
