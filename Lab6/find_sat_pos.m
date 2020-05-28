function [x_k, x_b, r_corrected]= find_sat_pos(obs)

Lab6Params;

nb_of_sat = length(all_sats_nb);
[~, info, ~] = getrinexephGal("lga00500.19p");


toe_index = find(strcmp(info, 'toe'));
af0_index = find(strcmp(info, 'af0'));
af1_index = find(strcmp(info, 'af1'));
af2_index = find(strcmp(info, 'af2'));

x_k = [];
pseudoranges = [];

for k = 1:nb_of_sat
    pseudorange_k = (obs(end -(nb_of_sat-k), 3) + obs(end -(nb_of_sat-k), 4))/2;
    pseudoranges = [pseudoranges, pseudorange_k];
end

tow = obs(end, 1);

% bancroft then linearization
[r, b, corrected_ecef, corrected_pseudoranges] = bancroft_approach(tow, all_sats_nb, we, pseudoranges, "lga00500.19p");
[deltas, ~] = linearized_approach(r, b, corrected_ecef, corrected_pseudoranges);

% We can correct the positions with the deltas
r_corrected = r + deltas(1:3);


for k = 1:nb_of_sat
    if k==base_sat_nb
        x_b = corrected_ecef(k,:);
    else
        x_k = [x_k; corrected_ecef(k,:)];
    end
end



%{
for k = 1:nb_of_sat
    % Find coordinate of each satellite at final time - P/c
    pseudorange_k = (obs(end -(nb_of_sat-k), 3) + obs(end -(nb_of_sat-k), 4))/2;
    tow = obs(end, 1);
    t =  tow - pseudorange_k/c;
    
    
    [~, ecef_coord, parsed_ephm] = eci_and_ecef_coord(t, all_sats_nb(k), we, ephm, info);
    % correct dtk:
    af0 = parsed_ephm(af0_index);
    af1 = parsed_ephm(af1_index);
    af2 = parsed_ephm(af2_index);
    toe = parsed_ephm(toe_index);
    dtk = af0 + af1*(t-toe) + af2*(t-toe)^2;

    t = t - dtk;
    [~, ecef_coord, ~] = eci_and_ecef_coord(t, all_sats_nb(k), we, ephm, info);
    % refine dtk even more:
    af0 = parsed_ephm(af0_index);
    af1 = parsed_ephm(af1_index);
    af2 = parsed_ephm(af2_index);
    toe = parsed_ephm(toe_index);
    dtk = af0 + af1*(t-toe) + af2*(t-toe)^2;
    
    % correction for Earth Rotation:
    corrected_ecef_coord = correction_Earth_rotation(ecef_coord', worst_delay)'; 
    
    disp('ecef without Earth correction = ')
    disp(ecef_coord)
    disp('ecef corrected with Earth rotation, using worst delay = ')
    disp(corrected_ecef_coord)
    
    if k==base_sat_nb
        x_b = corrected_ecef_coord;
    else
        x_k = [x_k; corrected_ecef_coord];
    end

end
%}
end