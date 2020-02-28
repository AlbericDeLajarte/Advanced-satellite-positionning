function [r_a, r_p, period] = lab1_questions()
[t_oe, sqrt_a, e, M_0, time_span] = ephemerides();
r_a = sqrt_a^2*(1+e)/1000; %answer in kilometers
r_p = sqrt_a^2*(1-e)/1000; %answer in kilometers
GM = 3.986005e14;
period = 2*pi*(sqrt_a^3/sqrt(GM));
civilian_day = 24*3600;

if period > civilian_day
    disp('orbit duration larger than civilian day')
else
    disp('orbit duration smaller than civilian day')
end