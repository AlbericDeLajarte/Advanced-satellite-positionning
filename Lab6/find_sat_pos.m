function [x_k, x_b, r_corrected]= find_sat_pos(obs, base_sat_nb)
%{
    This function computes the coordinates of satellites in ECEF. 
    Arguments:
    - obs: observations file of a receiver
    - base_sat_nb: the base satellite number
%}

Lab6Params;

nb_of_sat = length(all_sats_nb);
x_k = [];
pseudoranges = [];

% Find pseudoranges and concatenate them in a list
for k = 1:nb_of_sat
    pseudorange_k = (obs(end -(nb_of_sat-k), 3) + obs(end -(nb_of_sat-k), 4))/2;
    pseudoranges = [pseudoranges, pseudorange_k];
end

tow = obs(end, 1);

% bancroft then linearization, using functions of lab 2
[r, b, corrected_ecef, corrected_pseudoranges] = bancroft_approach(tow, all_sats_nb, we, pseudoranges, "lga00500.19p");
[deltas, ~] = linearized_approach(r, b, corrected_ecef, corrected_pseudoranges);
% We can correct the positions with the deltas
r_corrected = r + deltas(1:3);

% Concatenate the positions in matrix
for k = 1:nb_of_sat
    sat_k = all_sats_nb(k);
    if sat_k==base_sat_nb
        x_b = corrected_ecef(k,:);
    else
        x_k = [x_k; corrected_ecef(k,:)];
    end
end

end