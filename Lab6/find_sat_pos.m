function [x_k, x_b]= find_sat_pos(master_obs, all_sats_nb, base_sat_nb)

we = 7292115e-11; % [rad/s]
c = 299792458; %[m/s]

nb_of_sat = length(all_sats_nb);
[ephm, info, ~] = getrinexephGal("lga00500.19p");

x_k = [];


for k = 1:nb_of_sat
    % Find coordinate of each satellite at final time - P/c
    t = master_obs(end, 1) - master_obs(end -(nb_of_sat-k), 3)/c;
    [~, ecef_coord, ~] = eci_and_ecef_coord(t, all_sats_nb(k), we, ephm, info);

    if k==base_sat_nb
        x_b = ecef_coord;
    else
        x_k = [x_k; ecef_coord];
    end

end

end