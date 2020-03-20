function [ephm_kept, info] = parse_ephemerides(t_oe, sat_num, ephm, info)
%% This function parses the ephemerides: keep one set of parameters for a given satellite
%%

% Take all satellite ids:
sat_nums_ephemerides = ephm(1,:); 

toe_index = find(strcmp(info, 'toe'));
sat_column_indices = find(sat_nums_ephemerides == sat_num);

closest = Inf;
closest_index = 0;
% Loop over those columns, and check the time of week that is
% the closest to input t_oe (and before!)
for i = 1:length(sat_column_indices)
    time_diff =  t_oe - ephm(toe_index, sat_column_indices(i));
    if time_diff < closest && time_diff >= 0
        closest = time_diff;
        closest_index = sat_column_indices(i);
    end
end
% ephm_kept contains the ephemeride values we keep for the satellite
ephm_kept = ephm(:, closest_index);
    
end
