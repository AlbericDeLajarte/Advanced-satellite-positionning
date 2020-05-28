function [x_k, x_b]= find_sat_pos(obs)

Lab6Params;

nb_of_sat = length(all_sats_nb);
[ephm, info, ~] = getrinexephGal("lga00500.19p");

x_k = [];


for k = 1:nb_of_sat
    % Find coordinate of each satellite at final time - P/c
    pseudorange = (obs(end -(nb_of_sat-k), 3) + obs(end -(nb_of_sat-k), 4))/2;
    t = obs(end, 1) - pseudorange/c;
    [~, ecef_coord, ~] = eci_and_ecef_coord(t, all_sats_nb(k), we, ephm, info);

    if k==base_sat_nb
        x_b = ecef_coord;
    else
        x_k = [x_k; ecef_coord];
    end

end

end